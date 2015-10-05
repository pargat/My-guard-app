//
//  FeedViewController.h
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"
#import "FeedModal.h"
#import "Profile.h"
#import "FeedMainCell.h"
#import "ApiConstants.h"
#import <UIImageView+WebCache.h>
#import <MobileCoreServices/MobileCoreServices.h>


@protocol FeedDelegate

-(void)delHideShowHeader:(BOOL)hide;

@end

@interface FeedViewController : UIViewController <XLPagerTabStripChildItem,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) NSIndexPath *selectedIndex;
@property int pageIndex;
@property int feedType;
@property (nonatomic,strong) NSString *markerUrl;
@property (nonatomic,weak) id<FeedDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableViewFeeds;
@property (nonatomic,strong) NSMutableArray *arrayFeeds;

@end
