//
//  MyProfileViewController.h
//  MyGuardApp
//
//  Created by vishnu on 22/09/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "ProfileHeaderMyCell.h"
#import "SafetyProfileCell.h"
#import "Profile.h"
#import <UIImageView+WebCache.h>
#import "SafetyMeasure.h"
#import "FireViewController.h"
#import "CommunityNoCell.h"


@interface MyProfileViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,ZoomTransitionProtocol,UIActionSheetDelegate>


@property (nonatomic,strong) Profile *myProfile;
@property (nonatomic, strong) NSMutableArray *arraySafety;
@property (weak, nonatomic) IBOutlet UITableView *tableViewProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewS;

@end
