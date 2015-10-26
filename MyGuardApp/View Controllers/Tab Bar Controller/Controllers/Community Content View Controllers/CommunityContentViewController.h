//
//  CommunityContentViewController.h
//  MyGuardApp
//
//  Created by vishnu on 21/09/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "CommunityCell.h"
#import "XLPagerTabStripViewController.h"
#import "User.h"
#import "LOcationUpdater.h"
#import <UIImageView+WebCache.h>
#import "OtherProfileViewController.h"
#import <JTMaterialSpinner.h>
#import "CommunityNoCell.h"
#import "CommunityViewController.h"

@interface CommunityContentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *arraySearch;
@property NSInteger selectedIndex;
@property COMMUNITYTAB currentTab;
@property(nonatomic,strong) NSMutableArray *arrayCommunity;
@property (weak, nonatomic) IBOutlet UITableView *tableViewCommunity;




@end
