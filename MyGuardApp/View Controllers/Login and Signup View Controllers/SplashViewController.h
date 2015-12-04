//
//  SplashViewController.h
//  MyGuardApp
//
//  Created by vishnu on 05/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit.h>
#import <CoreLocation/CoreLocation.h>
#import <JTMaterialSpinner.h>
#import "Register1ViewController.h"
#import "MainTabBarController.h"

@interface SplashViewController : UIViewController<CLLocationManagerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) NSDictionary *dictFB;
@property (nonatomic,strong) CLLocationManager *locationManager;

- (IBAction)actionLogin:(id)sender;
- (IBAction)actionFB:(id)sender;
- (IBAction)actionRegister:(id)sender;

@end
