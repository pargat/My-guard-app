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
#import "ImageFullViewController.h"
#import <UIImageView+WebCache.h>
#import "CustomBadge.h"
#import "ProfileSelectionCell.h"
#import "MissingCommunityCell.h"
#import "MissingModal.h"
#import "MissingPersonViewController.h"
#import "BaseViewController.h"
@interface MyProfileViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,ZoomTransitionProtocol,UIActionSheetDelegate,ProfileMyDelegate,ProfileSelectionDelegate>

@property BOOL isSafetyShowing;
@property (nonatomic,strong) Profile *myProfile;
@property (nonatomic, strong) NSMutableArray *arrayMissing;
@property (nonatomic, strong) NSMutableArray *arraySafety;
@property (weak, nonatomic) IBOutlet UITableView *tableViewProfile;

@end
