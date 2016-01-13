//
//  MissingCommunityViewController.h
//  MyGuardApp
//
//  Created by vishnu on 13/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"
#import "iOSRequest.h"
#import "MissingCommunityCell.h"
#import "ApiConstants.h"
#import "LOcationUpdater.h"
#import "MissingModal.h"
#import <UIImageView+WebCache.h>

@interface MissingCommunityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewMissing;
@property (nonatomic,strong) NSMutableArray *arrayMissing;

@end
