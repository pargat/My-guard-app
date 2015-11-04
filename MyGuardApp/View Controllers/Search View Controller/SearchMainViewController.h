//
//  SearchMainViewController.h
//  MyGuardApp
//
//  Created by vishnu on 31/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLButtonBarPagerTabStripViewController.h"
#import "SearchUserViewController.h"
#import "SearchFeedViewController.h"
#import "SearchSafetyViewController.h"
#import "ApiConstants.h"


@class SearchFeedViewController;
@class SearchSafetyViewController;
@class SearchUserViewController;
@interface SearchMainViewController : XLButtonBarPagerTabStripViewController<XLPagerTabStripViewControllerDataSource,UISearchBarDelegate>

@property (nonatomic,strong) SearchUserViewController *searchUserVC;
@property (nonatomic,strong) SearchSafetyViewController *searchSafetyVC;
@property (nonatomic,strong) SearchFeedViewController *searchFeedVC;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
