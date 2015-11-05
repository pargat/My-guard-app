//
//  SearchUserViewController.h
//  MyGuardApp
//
//  Created by vishnu on 02/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"
#import "ApiConstants.h"
#import "CommunityCell.h"
#import "CommunityNoCell.h"
#import "User.h"
#import <UIImageView+WebCache.h>
#import "OtherProfileViewController.h"
#import <JTMaterialSpinner.h>


@interface SearchUserViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString *stringToSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSearch;
@property (nonatomic,strong) NSMutableArray *arraySearch;

-(void)apiSearch:(NSString *)str;
@end
