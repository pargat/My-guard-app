//
//  InfoVideosViewController.m
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "InfoVideosViewController.h"

@interface InfoVideosViewController ()

@end

@implementation InfoVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getVideos];
    [self.tableViewVideos setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableViewVideos.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getVideos
{
    [Video callAPIForVideos:[NSString stringWithFormat:KGetVideos,KbaseUrl,@"34",self.feedType,0] Params:nil success:^(NSMutableArray *videoArr) {
        self.arrayVideos = [[NSMutableArray alloc] initWithArray:videoArr];
        [self.tableViewVideos reloadData];
    } failure:^(NSString *errorStr) {
        
    }];
}
#pragma mark -
#pragma mark - XlChild

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return NSLocalizedString(@"info_videos", nil);
}

#pragma mark -
#pragma mark - Table View Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayVideos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoVideoCell"];
    [self configureSafetyCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureSafetyCell:(InfoVideoCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Video *video = [self.arrayVideos objectAtIndex:indexPath.row];
    
    [cell.labelTitle setText:video.videoTitle];
    [cell.labelDisplayTime setText:video.videoDisplayTime];
    [cell.imageViewVideo sd_setImageWithURL:[NSURL URLWithString:video.videoImageName]];

    
}
#pragma mark -
#pragma mark - Table view delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width*400/700;
    
}


#pragma mark -
#pragma mark - Scroll View Delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    if(velocity.y<0&&targetContentOffset->y==0)
    {
        [self.delegate delHideShowHeader:NO];
    }
    else
    {
        [self.delegate delHideShowHeader:YES];
    }
    
}

@end
