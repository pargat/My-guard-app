//
//  MainContentViewController.h
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLButtonBarPagerTabStripViewController.h"
#import "FeedViewController.h"
#import "SafetyMeasuresViewController.h"
#import "InfoVideosViewController.h"
#import "ApiConstants.h"

@interface MainContentViewController : XLButtonBarPagerTabStripViewController<FeedDelegate,SafetyDelegate,InfoVideosDelegate>

@property MAINTAB currentTab;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) FeedViewController *feedVC;
@property (strong, nonatomic) SafetyMeasuresViewController *safetyVC;
@property (strong, nonatomic) InfoVideosViewController *infoVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightExtra;
- (IBAction)actionEmergencyContact:(id)sender;
- (IBAction)actionAlarm:(id)sender;


@end
