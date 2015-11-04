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
#import <AVFoundation/AVFoundation.h>
#import "Profile.h"
#import "FeedMainCell.h"
#import "ApiConstants.h"
#import <UIImageView+WebCache.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+Extras.h"
#import <SVPullToRefresh.h>
#import <JTMaterialSpinner.h>
#import "MapViewController.h"
#import "ImageVideoViewController.h"
#import "BaseViewController.h"
#import "PostViewController.h"
#import "FeedFakeCell.h"

@protocol FeedDelegate

-(void)delHideShowHeader:(BOOL)hide;
-(void)delChangeNavButton:(BOOL)showOptional;

@end

@interface FeedViewController : BaseViewController <XLPagerTabStripChildItem,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FeedMainDelegate,UIActionSheetDelegate,FeedFakeDelegate>

@property (nonatomic,strong) NSIndexPath *selectedIndex;
@property int pageIndex;
@property int feedType;
@property (nonatomic,strong) NSString *markerUrl;
@property (nonatomic,weak) id<FeedDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableViewFeeds;
@property (nonatomic,strong) NSMutableArray *arrayFeeds;

@property (weak, nonatomic) IBOutlet UIButton *btnPostFeed;

- (IBAction)actionPostFeed:(id)sender;


@end
