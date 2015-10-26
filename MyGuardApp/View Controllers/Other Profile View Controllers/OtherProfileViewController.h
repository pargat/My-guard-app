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

@interface OtherProfileViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString *stringUsername;
@property (nonatomic,strong) NSString *stringUserId;
@property (nonatomic,strong) Profile *myProfile;
@property (nonatomic, strong) NSMutableArray *arraySafety;

@property (weak, nonatomic) IBOutlet UITableView *tableViewProfile;

@end
