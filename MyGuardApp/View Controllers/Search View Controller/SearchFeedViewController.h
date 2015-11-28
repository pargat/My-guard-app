//
//  SearchFeedViewController.h
//  MyGuardApp
//
//  Created by vishnu on 02/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"
#import "ApiConstants.h"
#import <UIImageView+WebCache.h>
#import "FeedMainCell.h"
#import "FeedModal.h"
#import "MapViewController.h"
#import "ImageVideoViewController.h"
#import "FeedFakeCell.h"
#import "BaseViewController.h"
#import <JTMaterialSpinner.h>
#import "PostViewController.h"

@class SearchMainViewController;
@interface SearchFeedViewController : BaseViewController<FeedMainDelegate,UIActionSheetDelegate,UINavigationBarDelegate,UIImagePickerControllerDelegate,FeedFakeDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSString *stringUserID;
@property (nonatomic,strong) NSIndexPath *selectedIndex;
@property (nonatomic,strong) NSString *stringToSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSearch;
@property (nonatomic,strong) NSMutableArray *arraySearch;

-(void)apiSearch:(NSString *)str;
@end
