//
//  LoginViewController.h
//  MyGuardApp
//
//  Created by vishnu on 15/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import <CoreLocation/CoreLocation.h>
#import <JTMaterialSpinner.h>
#import "Profile.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "BaseViewController.h"
#import "MainTabBarController.h"

@interface LoginViewController : BaseViewController<CLLocationManagerDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
- (IBAction)actionForgotPassword:(id)sender;

@end
