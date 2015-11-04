//
//  SearchSafetyViewController.h
//  MyGuardApp
//
//  Created by vishnu on 02/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"
#import "SafetyProfileCell.h"
#import "ApiConstants.h"
#import "SearchMainViewController.h"
#import "SafetyMeasure.h"
#import "CommunityNoCell.h"
#import "SafetyDetailViewController.h"

@interface SearchSafetyViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString *stringToSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSearch;
@property (nonatomic,strong) NSMutableArray *arraySearch;

-(void)apiSearch:(NSString *)str;

@end
