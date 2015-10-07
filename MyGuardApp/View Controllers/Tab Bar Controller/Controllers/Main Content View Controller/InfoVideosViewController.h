//
//  InfoVideosViewController.h
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"
#import "InfoVideoCell.h"
#import "Video.h"
#import <UIImageView+WebCache.h>

@protocol InfoVideosDelegate

-(void)delHideShowHeader:(BOOL)hide;
-(void)delChangeNavButton:(BOOL)showOptional;

@end


@interface InfoVideosViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableViewVideos;

@property (nonatomic,weak) id<InfoVideosDelegate> delegate;
@property (nonatomic, strong) NSString *feedType;
@property (nonatomic, strong) NSMutableArray *arrayVideos;

@end
