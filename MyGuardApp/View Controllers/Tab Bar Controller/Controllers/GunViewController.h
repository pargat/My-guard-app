//
//  GunViewController.h
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "MainContentViewController.h"
#import "UIImage+Extras.h"
@interface GunViewController : UIViewController
@property (nonatomic,strong) MainContentViewController *mainVC;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@end
