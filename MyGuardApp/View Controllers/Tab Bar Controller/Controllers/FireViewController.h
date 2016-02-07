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
#import "AddSafetyViewController.h"
#import "ZoomInteractiveTransition.h"
#import "OtherProfileViewController.h"
#import "SafetyDetailViewController.h"
#import "MapViewController.h"
#import "FalseAlarmViewController.h"
#import "SearchMainViewController.h"
#import "ImageVideoDetailViewController.h"
#import "AdminMessageViewController.h"
#import "LOcationUpdater.h"
#import "MissingPersonViewController.h"
#import "MyGuardInAppHelper.h"
#import "Profile.h"
#import "BaseViewController.h"
#import "CustomBadge.h"

@interface FireViewController : BaseViewController<ZoomTransitionProtocol,MainContentDelegate>

@property (nonatomic,strong) CustomBadge *badgeC;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (nonatomic,strong) MainContentViewController *mainVC;

@property (nonatomic, strong) ZoomInteractiveTransition * transition;
@property (nonatomic,strong) NSArray *arrayInApp;


@property (weak, nonatomic) IBOutlet UIView *viewInpp;
@property (weak, nonatomic) IBOutlet UILabel *labelPremium;
@property (weak, nonatomic) IBOutlet UILabel *labelPrimiumDes;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;

- (IBAction)actionBuy:(id)sender;

@end
