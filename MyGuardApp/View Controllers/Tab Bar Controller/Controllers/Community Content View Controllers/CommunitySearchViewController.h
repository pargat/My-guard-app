//
//  CommunitySearchViewController.h
//  MyGuardApp
//
//  Created by vishnu on 22/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "BaseViewController.h"
#import "XLPagerTabStripViewController.h"
#import "CommunityNoCell.h"
#import "CommunityCell.h"
#import "CommunityViewController.h"
#import "Profile.h"

@interface CommunitySearchViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *arrayCommunity;
@property (weak, nonatomic) IBOutlet UITableView *tableViewCommunity;
@property NSInteger selectedIndex;
-(void)searchUser;

@end
