//
//  BaseViewController.h
//  MyGuardApp
//
//  Created by vishnu on 19/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTMaterialSpinner.h>
#import "ApiConstants.h"
#import <JTMaterialSpinner.h>
@interface BaseViewController : UIViewController


-(void)setUpLoaderView:(UIColor *)colorLoader;
-(void)setUpLoaderView;
-(void)removeLoaderView;

-(void)showStaticAlert : (NSString *)title message : (NSString *)message;

@end
