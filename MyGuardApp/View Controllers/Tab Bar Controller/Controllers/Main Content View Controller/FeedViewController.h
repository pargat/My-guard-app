//
//  FeedViewController.h
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"

@protocol FeedDelegate

-(void)delHideShowHeader:(BOOL)hide;

@end

@interface FeedViewController : UIViewController <XLPagerTabStripChildItem,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,weak) id<FeedDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableViewFeeds;
@property (nonatomic,strong) NSMutableArray *arrayFeeds;

@end
