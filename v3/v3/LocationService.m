//
//  LocationService.m
//  v2
//
//  Created by John Bogil on 7/23/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "LocationService.h"
#import "NetworkManager.h"

@implementation LocationService

+ (LocationService *) sharedInstance {
    static LocationService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if(self != nil) {
        
    }
    return self;
}

- (void)startUpdatingLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100; // meters
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location service failed with error %@", error);
    // THERE NEEDS TO BE AN ALERT HERE
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray*)locations {
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    CLLocation *location = [locations lastObject];
    NSLog(@"Latitude %+.6f, Longitude %+.6f\n", location.coordinate.latitude, location.coordinate.longitude);
    self.currentLocation = location;
}

- (void)getCoordinatesFromSearchText:(NSString*)searchText withCompletion:(void(^)(CLLocation *results))successBlock
                             onError:(void(^)(NSError *error))errorBlock {
    
    [[NetworkManager sharedInstance]getStreetAddressFromSearchText:searchText withCompletion:^(NSArray *results) {
        if ([[results valueForKey:@"status"]isEqualToString:@"ZERO_RESULTS"]) {
            NSLog(@"theres beena mistake!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"We couldn't find your location. Try being more specific." delegate:nil cancelButtonTitle:@"Alright" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            CLLocationDegrees latitude = [[[[[results valueForKey:@"results"]valueForKey:@"geometry"]valueForKey:@"location"]valueForKey:@"lat"][0]doubleValue];
            CLLocationDegrees longitude = [[[[[results valueForKey:@"results"]valueForKey:@"geometry"]valueForKey:@"location"]valueForKey:@"lng"][0]doubleValue];
            
            CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
            NSLog(@"%@", location);
            successBlock(location);
        }
    } onError:^(NSError *error) {
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"location authorization denied");
    }
    else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        NSLog(@"Starting location updates");
        [self.locationManager startUpdatingLocation];
    }
}
@end