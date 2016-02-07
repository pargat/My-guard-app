//
//  COViewController.h
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "MainContentViewController.h"
#import "UIImage+Extras.h"
#import "AddSafetyViewController.h"
#import "SearchMainViewController.h"
#import "LOcationUpdater.h"
#import "CustomBadge.h"
#import "MyGuardInAppHelper.h"
#import "BaseViewController.h"
#import "AdminMessageViewController.h"
#import "MissingPersonViewController.h"


@interface COViewController : BaseViewController <MainContentDelegate>

@property (nonatomic,strong) NSArray *arrayInApp;


@property (weak, nonatomic) IBOutlet UIView *viewInpp;
@property (weak, nonatomic) IBOutlet UILabel *labelPremium;
@property (weak, nonatomic) IBOutlet UILabel *labelPrimiumDes;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;


@property (nonatomic,strong) CustomBadge *badgeC;
@property (nonatomic,strong) MainContentViewController *mainVC;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

- (IBAction)actionBuy:(id)sender;
@end
