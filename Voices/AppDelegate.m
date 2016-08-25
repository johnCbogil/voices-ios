
//  AppDelegate.m
//  Voices
//
//  Created by John Bogil on 7/23/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "AppDelegate.h"
#import "PageViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworkReachabilityManager.h"
#import "OnboardingNavigationController.h"
#import "LocationOnboardingViewController.h"
#import "NotiOnboardingViewController.h"
#import "SSZipArchive.h"
#import "RepManager.h"
#import "GroupsViewController.h"
#import "TabBarViewController.h"

@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setInitialViewController];
    [self setCache];
    [self enableFeedbackAndReporting];
    [self unzipNYCDataSet];
    [self excludeGeoJSONFromCloudBackup];
    [FIRApp configure];
    
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (notificationPayload) {
        
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray *))restorationHandler {
    
    BOOL handled = [[FIRDynamicLinks dynamicLinks]
                    handleUniversalLink:userActivity.webpageURL
                    completion:^(FIRDynamicLink * _Nullable dynamicLink,
                                 NSError * _Nullable error) {
                        if (dynamicLink.url) {
                            [self handleDynamicLink:dynamicLink];
                        }
                        else if (error) {
                            NSLog(@"%@", error);
                        }
                    }];
    return handled;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    FIRDynamicLink *dynamicLink = [[FIRDynamicLinks dynamicLinks]dynamicLinkFromCustomSchemeURL:url];
    if (dynamicLink) {
        NSLog(@"I am handling a link through the openURL method");
        [self handleDynamicLink:dynamicLink];
        return YES;
    }
    else {
        return NO;
    }
}

- (void)handleDynamicLink:(FIRDynamicLink *)dynamicLink {
    NSLog(@"%@", dynamicLink);
}


- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to appliation server.
}

- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // Pring full message.
    NSLog(@"%@", userInfo);
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TabBarViewController *tabVC = (TabBarViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"TabBarViewController"];
    self.window.rootViewController = tabVC;
    tabVC.selectedIndex = 1;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self connectToFcm];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//
//
//}

- (void)setInitialViewController {
 
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        NSLog(@"First launch");
        UIStoryboard *onboardingStoryboard = [UIStoryboard storyboardWithName:@"Onboarding" bundle: nil];
        OnboardingNavigationController *onboardingPageViewController = (OnboardingNavigationController*)[onboardingStoryboard instantiateViewControllerWithIdentifier: @"OnboardingNavigationController"];
        self.window.rootViewController = onboardingPageViewController;
        [self.window makeKeyAndVisible];
    }
}

- (void)enableFeedbackAndReporting {
    // Override point for customization after application launch.
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    
    
}

- (void)setCache {
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024
                                                            diskCapacity:100 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
}

- (void)unzipNYCDataSet {
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kCityCouncilZip]) {
        [RepManager sharedInstance].nycDistricts = [[[NSUserDefaults standardUserDefaults]objectForKey:kCityCouncilZip]valueForKey:@"features"];
        
    }
    else {
        // Get the file path for the zip
        NSString *archiveFilePath = [[NSBundle mainBundle] pathForResource:kCityCouncilZip ofType:@"zip"];
        // Get the file path for the destination
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        // Specify that we want the council data set
        self.dataSetPathWithComponent = [documentsPath stringByAppendingPathComponent:kCityCouncilJSON];
        // Check if the file exists at the path
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.dataSetPathWithComponent];
        // If the file does not already exist, unzip it
        if (!fileExists) {
            // Unzip the archive and send it to destination
            [SSZipArchive unzipFileAtPath:archiveFilePath toDestination:documentsPath];
        }
        
        NSString *myJSON = [[NSString alloc] initWithContentsOfFile:((AppDelegate*)[UIApplication sharedApplication].delegate).dataSetPathWithComponent encoding:NSUTF8StringEncoding error:NULL];
        NSError *error =  nil;
        NSDictionary *jsonDataDict = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        
        [[NSUserDefaults standardUserDefaults]setObject:jsonDataDict forKey:kCityCouncilZip];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [RepManager sharedInstance].nycDistricts = [jsonDataDict valueForKey:@"features"];
    }
}

- (void)excludeGeoJSONFromCloudBackup {
    // Exclude files from iCloud backup
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSArray *documents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:basePath error:nil];
    NSURL *URL;
    NSString *completeFilePath;
    for (NSString *file in documents) {
        completeFilePath = [NSString stringWithFormat:@"%@/%@", basePath, file];
        URL = [NSURL fileURLWithPath:completeFilePath];
        [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
        // NSLog(@"File %@  is excluded from backup %@", file, [URL resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsExcludedFromBackupKey] error:nil]);
    }
}

- (void)printFontFamilies {
    for (NSString *familyName in [UIFont familyNames]){
        NSLog(@"Family name: %@", familyName);
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSLog(@"--Font name: %@", fontName);
        }
    }
}

// Remove Apple bug error warning that occurs when phone call occurs
- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame {
    for(UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if([window.class.description isEqual:@"UITextEffectsWindow"]) {
            [window removeConstraints:window.constraints];
        }
    }
}

@end