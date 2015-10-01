//
//  LOcationUpdater.m
//  MyGuardApp
//
//  Created by vishnu on 22/09/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "LOcationUpdater.h"

@implementation LOcationUpdater

+ (id)sharedManager {
    static LOcationUpdater *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];

    });
    return sharedMyManager;
}
-(id)init
{
    [self locationInitialiser];
    self.timerObj = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
    [self updateLocation];
    return self;
}

#pragma mark -
#pragma mark - Location Manager delegate and helper functions
-(void)updateLocation
{
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];
}


-(void)locationInitialiser
{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *currentLocation = [locations lastObject];
    self.currentLoc = [locations lastObject];
    Profile *myProfile = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    NSString *stringUpdateLoc = [NSString stringWithFormat:@"%@update_location.php?uid=%@&latitude=%f&longitude=%f",KbaseUrl,myProfile.profileUserId,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
    [iOSRequest getJsonResponse:stringUpdateLoc success:^(NSDictionary *responseDict) {
        
    } failure:^(NSString *errorString) {
        
    }];
    
    
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];
    
}


@end
