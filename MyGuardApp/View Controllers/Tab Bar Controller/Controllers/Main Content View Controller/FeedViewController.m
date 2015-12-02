//
//  FeedViewController.m
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()



@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewHelper];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.delegate delChangeNavButton:NO];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeLoaderView];
}

#pragma mark -
#pragma mark - api related and helper function
-(void)addImage:(NSNotification *)notification
{
    if(notification.userInfo!=nil)
    {
    NSDictionary *dict = notification.userInfo;
    FeedModal *feed = [self.arrayFeeds objectAtIndex:self.selectedIndex.row];
    NSMutableArray *arrayMut = [NSMutableArray arrayWithArray:feed.feed_files];
    [arrayMut addObject:[[FileModal alloc] initWithAttributes:dict]];
    feed.feed_files = [NSArray arrayWithArray:arrayMut];
    @try {
        [self.tableViewFeeds reloadRowsAtIndexPaths:@[self.selectedIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    @catch (NSException *exception) {
        
    }
    }
    else
    {
        [self getFeed:YES];
    }

}
-(void)updateFeed:(NSNotification *)notification
{
    if(notification.object!=nil&&self.selectedIndex!=nil)
    {
        FeedModal *modal = [self.arrayFeeds objectAtIndex:self.selectedIndex.row];
        modal.feed_files = notification.object;
        [self.arrayFeeds replaceObjectAtIndex:self.selectedIndex.row withObject:modal];
        [self.tableViewFeeds reloadRowsAtIndexPaths:@[self.selectedIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
-(void)viewHelper
{
    
    self.pageIndex = 0;
    [self setUpLoaderView1];
    [self getFeed:YES];
    [self.tableViewFeeds setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addRefreshAndInfinite];

    self.stringUserID = [Profile getCurrentProfileUserId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFeed:) name:@"updateFeed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addImage:) name:@"addFeed" object:nil];
    if(self.feedType ==1)
    {
        [self.btnPostFeed setBackgroundColor:KOrangeColor];
        
    }
    else if (self.feedType==3)
    {
        [self.btnPostFeed setBackgroundColor:KRedColor];
        
    }
    else
    {
        [self.btnPostFeed setBackgroundColor:KGreenColor];
        
    }
    self.btnPostFeed.layer.cornerRadius = self.btnPostFeed.frame.size.width/2;
    self.btnPostFeed.clipsToBounds = YES;
}
-(void)addRefreshAndInfinite
{
    [self.tableViewFeeds addPullToRefreshWithActionHandler:^{
        self.pageIndex = 0;
        [self getFeed:YES];
    }];
    
    [self.tableViewFeeds addInfiniteScrollingWithActionHandler:^{
        self.pageIndex++;
        [self getFeed:NO];
    }];
    
}
-(void)getFeed : (BOOL)refresh
{
    
    
    Profile *profileD = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    NSString *strUrl = [NSString stringWithFormat:KGetAlarms,KbaseUrl,profileD.profileUserId,self.feedType,self.pageIndex,(long)[[NSTimeZone localTimeZone] secondsFromGMT]];
    
    [FeedModal callAPIForFeed:strUrl Params:nil success:^(NSMutableArray *feedArr) {
        
        if(refresh)
        {
            self.arrayFeeds = [[NSMutableArray alloc] initWithArray:feedArr];
            [self.tableViewFeeds.pullToRefreshView stopAnimating];
        }
        else
        {
            [self.arrayFeeds addObjectsFromArray:feedArr];
            [self.tableViewFeeds.infiniteScrollingView stopAnimating];
        }
        [self.tableViewFeeds reloadData];
        
        [self removeLoaderView];
    } failure:^(NSString *errorStr) {
        [self removeLoaderView];
    }];
    
}


#pragma mark -
#pragma mark - XlChild

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    
    return NSLocalizedString(@"feed", nil);
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

#pragma mark -
#pragma mark - Feed main cell delegate
-(void)delImageCellClicked:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath;
    [self performSegueWithIdentifier:KImageVideoSegue sender:self];
}
-(void)delCameraClicked:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath;
    [self performSegueWithIdentifier:KPostAlarmSegue sender:self.selectedIndex];
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo",@"Choose photo from gallery",@"Take Video",@"Choose Video from gallery",nil];
//    [actionSheet showInView:self.view];
    
}

#pragma mark -
#pragma mark - Table View Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayFeeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedModal *modal = [self.arrayFeeds objectAtIndex:indexPath.row];
    
    if([modal.feed_is_fake isEqualToString:@"0"])
    {
        
        FeedMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedMainCell"];
        
        [self configureMapCell:cell atIndexPath:indexPath];
        cell.selectedPath = indexPath;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setDelegate:self];
        FeedModal *modal = [self.arrayFeeds objectAtIndex:indexPath.row];
        
        if(modal.feed_files.count==0)
        {
            [cell setDataAndDelegateNil];
        }
        else
        {
            [cell setDelegateAndData];
            
        }
        
        
        return cell;
    }
    else
    {
        FeedFakeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedFakeCell"];
        
        [self configureFakeCell:cell atIndexPath:indexPath];
        cell.selectedPath = indexPath;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setDelegate:self];
        FeedModal *modal = [self.arrayFeeds objectAtIndex:indexPath.row];
        
        if(modal.feed_files.count==0)
        {
            [cell setDataAndDelegateNil];
        }
        else
        {
            [cell setDelegateAndData];
            
        }
        
        
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(FeedMainCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    
    
    
    UIBezierPath *shadowPath1 = [UIBezierPath bezierPathWithRect:cell.viewShadow.bounds];
    cell.viewShadow.layer.masksToBounds = NO;
    cell.viewShadow.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.viewShadow.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell.viewShadow.layer.shadowOpacity = 0.75f;
    cell.viewShadow.layer.shadowPath = shadowPath1.CGPath;
}
#pragma mark -
#pragma mark - Table view helpers
-(void)configureMapCell:(FeedMainCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FeedModal *modal = [self.arrayFeeds objectAtIndex:indexPath.row];
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:KBaseTimbthumbUrl,modal.feed_imageName,cell.imageViewDp.frame.size.width*DisplayScale,cell.imageViewDp.frame.size.width*DisplayScale]]];
    [cell.labelName setText:modal.feed_fullname];
    [cell.labelDistance setText:[NSString stringWithFormat:@"%@ away",modal.feed_distance]];
    [cell.labelTimeSince setText:modal.feed_time_passed];
    
    
    if(modal.feed_files.count==0)
    {
        cell.heightCollctionView.constant = 0;
        [cell.collectionViewImages setHidden:YES];
        cell.arrayFiles = [[NSMutableArray alloc] init];
    }
    else
    {
        cell.heightCollctionView.constant = 100;
        [cell.collectionViewImages setHidden:NO];
        cell.arrayFiles = [modal.feed_files mutableCopy];
    }
    
    
    [cell.heightMap setConstant:9*[[UIScreen mainScreen] bounds].size.width/16];
    

    if ([self.stringUserID isEqualToString:modal.feed_userid]) {
        [cell.btnCamera setHidden:NO];
    }
    else
    {
        [cell.btnCamera setHidden:YES];
    }

    
    
    [cell.imageViewMap sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&zoom=14&size=%dx%d&markers=icon:%@|label:C|size=mid|%@,%@",modal.feed_lat,modal.feed_lng,(int)(cell.imageViewMap.frame.size.width*DisplayScale),(int)(cell.imageViewMap.frame.size.height*DisplayScale),self.markerUrl,modal.feed_lat,modal.feed_lng] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
}
-(void)configureFakeCell:(FeedFakeCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FeedModal *modal = [self.arrayFeeds objectAtIndex:indexPath.row];
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:KBaseTimbthumbUrl,modal.feed_imageName,cell.imageViewDp.frame.size.width*DisplayScale,cell.imageViewDp.frame.size.width*DisplayScale]]];
    [cell.labelName setText:modal.feed_fullname];
    [cell.labelTimeSince setText:modal.feed_time_passed];
    [cell.labelDescription setText:modal.feed_description];
    if(modal.feed_description.length==0)
    {
        cell.layoutBottomDescription.constant = 0;
    }
    else
    {
        cell.layoutBottomDescription.constant = 16;
    }
    [cell.labelDescription setPreferredMaxLayoutWidth:self.view.frame.size.width-48];
    if(modal.feed_files.count<2)
    {
        cell.heightCollctionView.constant = 0;
        [cell.collectionViewImages setHidden:YES];
        cell.arrayFiles = [[NSMutableArray alloc] init];
    }
    else
    {
        cell.heightCollctionView.constant = 100;
        [cell.collectionViewImages setHidden:NO];
        cell.arrayFiles = [modal.feed_files mutableCopy];
        [cell.arrayFiles removeObjectAtIndex:0];
    }
    
    
    [cell.heightMap setConstant:12*[[UIScreen mainScreen] bounds].size.width/16-44];
    FileModal *fileModal = [modal.feed_files firstObject];
    if(fileModal.fileType)
    {
        [cell.btnDuration setHidden:NO];
        [cell.btnDuration setTitle:[NSString stringWithFormat:@" %@",fileModal.fileDuration] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnDuration setHidden:YES];
    }
    
    
    if ([self.stringUserID isEqualToString:modal.feed_userid]) {
        [cell.btnCamera setHidden:NO];
    }
    else
    {
        [cell.btnCamera setHidden:YES];
    }

    [cell.btnCommentCount setTitle:[NSString stringWithFormat:@" %@",fileModal.fileNumberOfComments] forState:UIControlStateNormal];
    [cell.imageViewMap sd_setImageWithURL:[NSURL URLWithString:[CommonFunctions getFullImage:fileModal.fileThumbCumImageLink view:cell.imageViewMap] ]];
    
}





#pragma mark -
#pragma mark -  Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedModal *modal = [self.arrayFeeds objectAtIndex:indexPath.row];
    self.selectedIndex = indexPath;

    if([modal.feed_is_fake isEqualToString:@"1"])
    {
        [self performSegueWithIdentifier:KImageVideoSegue sender:nil];
    }
    else
    {
    [self performSegueWithIdentifier:KMapFeedSegue sender:self];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedModal *modal = [self.arrayFeeds objectAtIndex:indexPath.row];
    
    if([modal.feed_is_fake isEqualToString:@"0"])
    {
        static FeedMainCell *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"FeedMainCell"];
        });
        
        [self configureMapCell:sizingCell atIndexPath:indexPath];
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    }
    else
    {
        static FeedFakeCell *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"FeedFakeCell"];
        });
        
        [self configureFakeCell:sizingCell atIndexPath:indexPath];
        [sizingCell setNeedsLayout];
        [sizingCell layoutIfNeeded];
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
        
    }
}


#pragma mark - Hide Unhide Loader View

-(void)setUpLoaderView1
{
    UIColor *colorProfile;
    if(self.feedType==1)
    {
        colorProfile = KOrangeColor;
    }
    else if (self.feedType==3)
    {
        colorProfile = KRedColor;
    }
    else
    {
        colorProfile = KGreenColor;
    }
    [self setUpLoaderView:colorProfile];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:KMapFeedSegue])
    {
        MapViewController *mapVC = (MapViewController *)segue.destinationViewController;
        mapVC.feed = [self.arrayFeeds objectAtIndex:self.selectedIndex.row];
    }
    else if([segue.identifier isEqualToString:KImageVideoSegue])
    {
        ImageVideoViewController *imageVc = (ImageVideoViewController *)segue.destinationViewController;
        imageVc.feedModal = [self.arrayFeeds objectAtIndex:self.selectedIndex.row];
        imageVc.currentTab = self.feedType;
    }
    else if ([segue.identifier isEqualToString:KPostAlarmSegue])
    {
        PostViewController *postVC = (PostViewController *)segue.destinationViewController;
        postVC.feedType = self.feedType;
       if([sender isKindOfClass:[NSIndexPath class]])
       {
           FeedModal *f = [self.arrayFeeds objectAtIndex:self.selectedIndex.row];
           postVC.stringFeedId = f.feed_id;
       }
    }
}


#pragma mark -
#pragma mark - Button Actions
- (IBAction)actionPostFeed:(id)sender {
    
    [self performSegueWithIdentifier:KPostAlarmSegue sender:self];
}
@end
