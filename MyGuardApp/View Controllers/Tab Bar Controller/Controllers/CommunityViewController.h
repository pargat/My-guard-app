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
#import "UIImage+Extras.h"


@interface CommunityViewController : XLButtonBarPagerTabStripViewController<UISearchBarDelegate>

@property (nonatomic,strong) CommunityContentViewController *community1;
@property (nonatomic,strong) CommunityContentViewController *community2;
@property (nonatomic,strong) CommunityContentViewController *community3;
@property (nonatomic,strong) CommunityContentViewController *community4;



@end
