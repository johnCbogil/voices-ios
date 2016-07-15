//
//  NotiOnboardingViewController.m
//  Voices
//
//  Created by John Bogil on 7/14/16.
//  Copyright © 2016 John Bogil. All rights reserved.
//

#import "NotiOnboardingViewController.h"
#import "VoicesConstants.h"
#import "UIColor+voicesColor.h"
#import "UIFont+voicesFont.h"

#import "AppDelegate.h"

@import FirebaseMessaging;

@interface NotiOnboardingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *turnOnNotiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *notiOnboardingImageView;
@property (weak, nonatomic) IBOutlet UIView *singleLineView;
@property (weak, nonatomic) IBOutlet UIButton *turnOnNotificationsButton;
@property (weak, nonatomic) IBOutlet UIButton *deferNotiButton;

@end

@implementation NotiOnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate]   ;
    

    
    
    [appDelegate addObserver:self forKeyPath:@"isRegisteredForPushNotis" options:NSKeyValueObservingOptionNew context:nil];

//    [[LocationService sharedInstance] addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];

}

- (IBAction)turnOnNotiButtonDidPress:(id)sender {
    
    UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isRegisteredForPushNotis"]) {
        NSLog(@"OtherVC: The value of self.myVC.mySetting has changed");
    }
}



@end
