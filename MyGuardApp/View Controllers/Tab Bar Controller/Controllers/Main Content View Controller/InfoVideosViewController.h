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
#import <JTMaterialSpinner.h>
#import "YoutubeViewController.h"

@protocol InfoVideosDelegate

-(void)delHideShowHeader:(BOOL)hide;
-(void)delChangeNavButton:(BOOL)showOptional;
-(void)delNobutton;
@end


@interface InfoVideosViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSString *stringLink;
@property (weak, nonatomic) IBOutlet UITableView *tableViewVideos;

@property (nonatomic,weak) id<InfoVideosDelegate> delegate;
@property (nonatomic, strong) NSString *feedType;
@property (nonatomic, strong) NSMutableArray *arrayVideos;

@end
