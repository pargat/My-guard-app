//
//  SearchFeedViewController.m
//  MyGuardApp
//
//  Created by vishnu on 02/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SearchFeedViewController.h"

@interface SearchFeedViewController ()

@end

@implementation SearchFeedViewController

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
    if(self.stringToSearch!=nil)
    {
        [self apiSearch:self.stringToSearch];
    }
}
#pragma mark -
#pragma mark -  View helpers
-(void)viewHelper
{
    [self.tableViewSearch setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableViewSearch setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
}
-(void)apiSearch:(NSString *)str
{
    NSString * stringSearchSafety = [NSString stringWithFormat:KSearchNewApi,KbaseUrl,[Profile getCurrentProfileUserId],str,@"2"];
    
    [iOSRequest getJsonResponse:stringSearchSafety success:^(NSDictionary *responseDict) {
        self.arraySearch = [FeedModal parseDictToFeed:[responseDict valueForKey:@"data"]];
        [self.tableViewSearch reloadData];
    } failure:^(NSString *errorString) {
        
    }];
}


#pragma mark -
#pragma mark - XlChild

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return NSLocalizedString(@"feed", nil);
}
#pragma mark -
#pragma mark - Feed main cell delegate
-(void)delImageCellClicked:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:KImageVideoSegue sender:[self.arraySearch objectAtIndex:indexPath.row]];
}
-(void)delCameraClicked:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo",@"Choose photo from gallery",@"Take Video",@"Choose Video from gallery",nil];
    [actionSheet showInView:self.view];
    
}


#pragma mark -
#pragma mark - Table View Datasource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    FeedModal *modal = [self.arraySearch objectAtIndex:indexPath.row];
    if(modal.feed_files.count>0)
        [self performSegueWithIdentifier:KImageVideoSegue sender:modal];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arraySearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedMainCell"];
    
    [self configureMapCell:cell atIndexPath:indexPath];
    cell.selectedPath = indexPath;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    FeedModal *modal = [self.arraySearch objectAtIndex:indexPath.row];
    
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(FeedMainCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    
    
    
    UIBezierPath *shadowPath  = [UIBezierPath bezierPathWithRect:cell.viewOverlay.bounds];
    cell.viewOverlay.layer.masksToBounds = NO;
    cell.viewOverlay.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.viewOverlay.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    cell.viewOverlay.layer.shadowOpacity = 0.75f;
    cell.viewOverlay.layer.shadowPath = shadowPath.CGPath;
    
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
    FeedModal *modal = [self.arraySearch objectAtIndex:indexPath.row];
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
    
    
    [cell.heightMap setConstant:12*[[UIScreen mainScreen] bounds].size.width/16];
    
    if([modal.feed_address isEqualToString:@""]||modal.feed_address==nil)
    {
        [cell.labelAddress setText:@"N.A."];
    }
    else
        [cell.labelAddress setText:modal.feed_address];
    [cell.labelTimeDetail setText:modal.feed_full_time];
    NSString *markerUrl;
    if([modal.feed_type isEqualToString:@"1"])
    {
        [cell.labelEmergencyName setText:@"Fire"];
        [cell.labelEmergencyName setTextColor:KOrangeColor];
        markerUrl = KFireIcon;
        
    }
    else if ([modal.feed_type isEqualToString:@"3"])
    {
        [cell.labelEmergencyName setText:@"Gun"];
        [cell.labelEmergencyName setTextColor:KRedColor];
        markerUrl = KGunIcon;
    }
    else
    {
        [cell.labelEmergencyName setText:@"CO Emergency"];
        [cell.labelEmergencyName setTextColor:KGreenColor];
        markerUrl = KCOIcon;
        
    }
    [cell.labelAddress setPreferredMaxLayoutWidth:self.view.frame.size.width - 192];
    
    
    
    [cell.imageViewMap sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&zoom=14&size=%dx%d&markers=icon:%@|label:C|size=mid|%@,%@",modal.feed_lat,modal.feed_lng,(int)(cell.imageViewMap.frame.size.width*DisplayScale),(int)(cell.imageViewMap.frame.size.height*DisplayScale),markerUrl,modal.feed_lat,modal.feed_lng] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:KMapFeedSegue])
    {
        MapViewController *mapVC = (MapViewController *)segue.destinationViewController;
        mapVC.feed = (FeedModal *)sender;
    }
    else
    {
        ImageVideoViewController *imageVc = (ImageVideoViewController *)segue.destinationViewController;
        imageVc.feedModal = (FeedModal *)sender;
        FeedModal *modal = (FeedModal *)sender;
        if([modal.feed_type isEqualToString:@"1"])
        {
            imageVc.currentTab = 1;

        }
        else if([modal.feed_type isEqualToString:@"1"])
        {
            imageVc.currentTab = 3;
        }
        else
        {
            imageVc.currentTab = 2;
        }
}

    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
