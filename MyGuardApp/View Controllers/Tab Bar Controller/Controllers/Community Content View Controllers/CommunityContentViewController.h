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
#import "BaseViewController.h"
#import <SVPullToRefresh.h>

@protocol CVDelegate <NSObject>

-(void)delShouldShowAdd:(BOOL)show;

@end

@interface CommunityContentViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign) id<CVDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *arraySearch;
@property NSInteger selectedIndex;
@property COMMUNITYTAB currentTab;
@property(nonatomic,strong) NSMutableArray *arrayCommunity;
@property (weak, nonatomic) IBOutlet UITableView *tableViewCommunity;
@property (weak, nonatomic) IBOutlet UILabel *labelCommunity;




@end
