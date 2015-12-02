//
//  LOcationUpdater.h
//  MyGuardApp
//
//  Created by vishnu on 22/09/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ApiConstants.h"
#import <math.h>
#import "CommonFunctions.h"
#import "SexOffender.h"
#import "SexOverlayNew.h"

@interface LOcationUpdater : NSObject<CLLocationManagerDelegate>



+ (id)sharedManager;

@property (strong,nonatomic) UIImage *imageDp;
@property (strong,nonatomic) NSTimer *timerObj;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocationManager *locationManager1;
@property (nonatomic, strong)  CLLocation *currentLoc;

@end
