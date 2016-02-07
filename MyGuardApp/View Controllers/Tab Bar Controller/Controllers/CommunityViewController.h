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
#import "MissingCommunityViewController.h"
#import "CustomBadge.h"


@class MissingCommunityViewController;
@class CommunitySearchViewController;
@class CommunityContentViewController;
@interface CommunityViewController : XLButtonBarPagerTabStripViewController<UISearchBarDelegate,MDelegate>

@property (nonatomic,strong) CustomBadge *badgeC;
@property BOOL isSearching;
@property (nonatomic,strong) UISearchBar *sBar;
@property (nonatomic,strong) CommunityContentViewController *community1;
@property (nonatomic,strong) CommunityContentViewController *community2;
@property (nonatomic,strong) CommunityContentViewController *community3;
@property (nonatomic,strong) CommunityContentViewController *communityGroup;
@property (nonatomic,strong) CommunitySearchViewController *community4;
@property (nonatomic,strong) MissingCommunityViewController *missingVC;

@end
