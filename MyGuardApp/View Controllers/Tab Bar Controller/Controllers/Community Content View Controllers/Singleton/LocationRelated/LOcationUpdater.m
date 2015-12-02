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
    [self locationSex];
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
-(void)locationSex
{
    // Start location services
    self.locationManager1 = [[CLLocationManager alloc] init];
    self.locationManager1.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Only report to location manager if the user has traveled 1000 meters
    self.locationManager1.distanceFilter = 30.0f;
    self.locationManager1.delegate = self;
    self.locationManager1.activityType = CLActivityTypeAutomotiveNavigation;
    // Start monitoring significant locations here as default, will switch to
    // update locations on enter foreground
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }

    [self.locationManager1 startMonitoringSignificantLocationChanges];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    if([manager isEqual:self.locationManager1])
//    {
//        [[[UIAlertView alloc] initWithTitle:@"Cool" message:@"Coolness" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
//    }
//    else
//    {
        CLLocation *currentLocation = [locations lastObject];
        self.currentLoc = [locations lastObject];
        Profile *myProfile = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
        NSString *stringUpdateLoc = [NSString stringWithFormat:@"%@update_location.php?uid=%@&latitude=%f&longitude=%f",KbaseUrl,myProfile.profileUserId,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
        [iOSRequest getJsonResponse:stringUpdateLoc success:^(NSDictionary *responseDict) {
            
        } failure:^(NSString *errorString) {
            
        }];
        [self.locationManager stopUpdatingLocation];
        [self.locationManager setDelegate:nil];
    
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"sex_permission"]&&[[NSUserDefaults standardUserDefaults] valueForKey:@"profile"]!=nil)
            [self checkSexLat:self.currentLoc];
    
    //}
    
}
-(void)checkSexLat:(CLLocation *)loc
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"sex_loc"]!=nil)
    {
        CLLocation *prevLoc = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"sex_loc"];
        BOOL shouldHit = [self whetherTravelledSignificant:loc prevLoc:prevLoc];
        if(shouldHit)
        {
            [self hitSexOffender];
        }
        
        
        [[NSUserDefaults standardUserDefaults] rm_setCustomObject:loc forKey:@"sex_loc"];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] rm_setCustomObject:loc forKey:@"sex_loc"];
        [self hitSexOffender];

    }
}
-(BOOL)whetherTravelledSignificant:(CLLocation *)loc prevLoc:(CLLocation *)locPre
{
    double distance = (loc.coordinate.latitude-locPre.coordinate.latitude)*2+(loc.coordinate.longitude-locPre.coordinate.longitude)*2;
    distance = sqrt(distance);
    CLLocationDistance dis = [locPre distanceFromLocation:loc];
    if(dis<100)
        return NO;
    else
        return YES;
}
-(void)hitSexOffender
{
   
    NSArray *array = [CommonFunctions getBoundingBox:10 lat:self.currentLoc.coordinate.latitude lon:self.currentLoc.coordinate.longitude];
    [SexOffender callAPIForSexOffenders:[ NSString stringWithFormat:@"http://services.familywatchdog.us/json/json.asp?key=%@&lite=0&type=searchbylatlong&minlat=%@&maxlat=%@&minlong=%@&maxlong=%@",KSEXKEY,[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2],[array objectAtIndex:3]] Params:nil success:^(NSMutableArray *offenderArr) {
        
        if(offenderArr.count>0)
        {
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:offenderArr forKey:@"sex_list"];
            [self showSexOverlay];
        }
//        else
//        {
//            [[[UIAlertView alloc] initWithTitle:@"Working" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
//        }
//

    } failure:^(NSString *errorStr) {
    
        
    }];
}
-(void)showSexOverlay
{
    
    if(![[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] isKindOfClass:[SexOverlayNew class]])
    {
        SexOverlayNew *viewSex = [[SexOverlayNew alloc] init];
        [viewSex setFrame:[[UIScreen mainScreen] bounds]];
        [[[UIApplication sharedApplication] keyWindow] addSubview:viewSex];
    }
}
@end
