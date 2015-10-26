//
//  InfoVideosViewController.m
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "InfoVideosViewController.h"

@interface InfoVideosViewController ()
{
    JTMaterialSpinner *loaderObj ;
}
@end

@implementation InfoVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLoaderView];
    [self getVideos];
    [self.tableViewVideos setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableViewVideos.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.delegate delNobutton];
}


#pragma mark -
#pragma mark - Helper and api related functions
-(void)getVideos
{
    [Video callAPIForVideos:[NSString stringWithFormat:KGetVideos,KbaseUrl,@"34",self.feedType,0] Params:nil success:^(NSMutableArray *videoArr) {
        self.arrayVideos = [[NSMutableArray alloc] initWithArray:videoArr];
        [self.tableViewVideos reloadData];
        [self removeLoaderView];
    } failure:^(NSString *errorStr) {
        [self removeLoaderView];
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
    [cell.labelDisplayTime setText:video.videoDuration];
    [cell.imageViewVideo sd_setImageWithURL:[NSURL URLWithString:video.videoImageName]];

    
}
#pragma mark -
#pragma mark - Table view delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width*400/700;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Video *vid = [self.arrayVideos objectAtIndex:indexPath.row];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"youtube://"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:vid.videoLink]];
        
    }
    else
    {
   
        self.stringLink = vid.videoLink;
        [self performSegueWithIdentifier:KYoutubeVideoSegue sender:self];
    }

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


#pragma mark - Hide Unhide Loader View

-(void)setUpLoaderView
{
    [loaderObj removeFromSuperview];
    loaderObj = [[JTMaterialSpinner alloc] init];
    loaderObj.frame = CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-20, 40, 40);
    loaderObj.circleLayer.lineWidth = 2.0;
    if([self.feedType isEqualToString:@"1"])
    {
        loaderObj.circleLayer.strokeColor = KOrangeColor.CGColor;
    }
    else if ([self.feedType isEqualToString:@"3"])
    {
        loaderObj.circleLayer.strokeColor = KRedColor.CGColor;
    }
    else
    {
        loaderObj.circleLayer.strokeColor = KGreenColor.CGColor;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:loaderObj];
    [loaderObj beginRefreshing];
}

-(void)removeLoaderView
{
    [loaderObj removeFromSuperview];
    [loaderObj endRefreshing];
}

#pragma mark - 
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:KYoutubeVideoSegue])
    {
        YoutubeViewController *yVC = (YoutubeViewController *)segue.destinationViewController;
        yVC.stringLink = self.stringLink;
    }
}



@end
