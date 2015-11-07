//
//  CommunityViewController.h
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "XLButtonBarPagerTabStripViewController.h"
#import "CommunityContentViewController.h"
#import "CommunitySearchViewController.h"
#import "UIImage+Extras.h"
#import "User.h"
#import "SearchMainViewController.h"
#import "LOcationUpdater.h"

@class CommunitySearchViewController;
@class CommunityContentViewController;
@interface CommunityViewController : XLButtonBarPagerTabStripViewController<UISearchBarDelegate>

@property BOOL isSearching;
@property (nonatomic,strong) UISearchBar *sBar;
@property (nonatomic,strong) CommunityContentViewController *community1;
@property (nonatomic,strong) CommunityContentViewController *community2;
@property (nonatomic,strong) CommunityContentViewController *community3;
@property (nonatomic,strong) CommunityContentViewController *communityGroup;
@property (nonatomic,strong) CommunitySearchViewController *community4;

@end
