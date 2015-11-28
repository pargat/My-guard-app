//
//  OtherProfileViewController.h
//  MyGuardApp
//
//  Created by vishnu on 15/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "ProfileHeaderOtherCell.h"
#import "SafetyProfileCell.h"
#import "Profile.h"
#import <UIImageView+WebCache.h>
#import "SafetyMeasure.h"
#import "BaseViewController.h"
#import "CommunityNoCell.h"
#import "SafetyDetailViewController.h"
#import "ImageFullViewController.h"

@interface OtherProfileViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ProfileOtherDelegate>

@property (nonatomic,strong) NSString *stringUsername;
@property (nonatomic,strong) NSString *stringUserId;
@property (nonatomic,strong) Profile *myProfile;
@property (nonatomic, strong) NSMutableArray *arraySafety;
@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutWidthView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutWidthBtn2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutWidthBtn1;

@property (weak, nonatomic) IBOutlet UITableView *tableViewProfile;
@property (weak, nonatomic) IBOutlet UIView *viewButtonHolder;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFriend;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFamily;
- (IBAction)actionAddFamily:(id)sender;

- (IBAction)actionAddFriend:(id)sender;

@end
