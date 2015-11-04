//
//  NotificationViewController.h
//  MyGuardApp
//
//  Created by vishnu on 05/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "NotificationModal.h"
#import "NotificationRequestCell.h"
#import "NotificationSimpleCell.h"
#import "CommunityNoCell.h"
#import <UIImageView+WebCache.h>
#import "BaseViewController.h"
#import <SVPullToRefresh.h>
#import "SafetyDetailViewController.h"

@interface NotificationViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,NotificationDelegate>

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) NSMutableArray *arrayNotifs;
@property int pageIndex;
@property (weak, nonatomic) IBOutlet UITableView *tableViewNotifs;


@end
