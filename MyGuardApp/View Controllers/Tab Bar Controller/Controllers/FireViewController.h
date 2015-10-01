//
//  FireViewController.h
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "MainContentViewController.h"
#import <UIButton+WebCache.h>
#import "UIImage+Extras.h"
#import "ZoomInteractiveTransition.h"
@interface FireViewController : UIViewController<ZoomTransitionProtocol>

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (nonatomic,strong) MainContentViewController *mainVC;

@property (nonatomic, strong) ZoomInteractiveTransition * transition;


@end
