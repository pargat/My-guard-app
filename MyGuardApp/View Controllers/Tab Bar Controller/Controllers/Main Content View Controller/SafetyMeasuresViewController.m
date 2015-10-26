//
//  SafetyMeasuresViewController.m
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "SafetyMeasuresViewController.h"

@interface SafetyMeasuresViewController ()
{
    JTMaterialSpinner *loaderObj ;
}

@end

@implementation SafetyMeasuresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewHelper];
    [self addRefreshAndInfinite];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.delegate delChangeNavButton:YES];
}


#pragma mark -
#pragma mark - Helpers
-(void)viewHelper
{
    self.pageIndex = 0;
    [self.tableViewSafety setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    // Do any additional setup after loading the view.
    [self setUpLoaderView];
    [self getSafetyMeasures:YES];

}
-(void)getSafetyMeasures :(BOOL)isRefresh
{
    __weak SafetyMeasuresViewController *weakSelf = self;
    NSString *strSafety = [NSString stringWithFormat:KGetSafetyMeasure,KbaseUrl,@"34",self.feedType,self.pageIndex,10];
    [SafetyMeasure callAPIForSafetyMeasure:strSafety Params:nil success:^(NSMutableArray *safetyArr) {
        if(isRefresh)
        {
            weakSelf.arraySafetyMeasures = [[NSMutableArray alloc] initWithArray:safetyArr];

        }
        else
        {
            [weakSelf.arraySafetyMeasures addObjectsFromArray:safetyArr];
        }
        [weakSelf.tableViewSafety reloadData];
        [self.tableViewSafety.infiniteScrollingView stopAnimating];
        [self.tableViewSafety.pullToRefreshView stopAnimating];
        [self removeLoaderView];
    } failure:^(NSString *errorStr) {
        [self.tableViewSafety.infiniteScrollingView stopAnimating];
        [self.tableViewSafety.pullToRefreshView stopAnimating];
        [self removeLoaderView];

    }];
}
-(void)addRefreshAndInfinite
{
    [self.tableViewSafety addPullToRefreshWithActionHandler:^{
        self.pageIndex = 0;
        [self getSafetyMeasures:YES];
    }];
    
    [self.tableViewSafety addInfiniteScrollingWithActionHandler:^{
        self.pageIndex++;
        [self getSafetyMeasures:NO];
    }];
    
}


#pragma mark -
#pragma mark - XlChild

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return NSLocalizedString(@"safety_measures", nil);
}


#pragma mark -
#pragma mark - Table View Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arraySafetyMeasures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SafetyMeasureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SafetyMeasureCell"];
    [self configureSafetyCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
     
-(void)configureSafetyCell:(SafetyMeasureCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SafetyMeasure *mesaure = [self.arraySafetyMeasures objectAtIndex:indexPath.row];
    
    [cell.labelDescription setPreferredMaxLayoutWidth:[[UIScreen mainScreen] bounds].size.width - 98];
    [cell.labelName setText:mesaure.safetyFirstName];
    [cell.labelDescription setText:mesaure.safetyDescription];
    [cell.labelTime setText:mesaure.safetyDisplayTime];
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:KBaseTimbthumbUrl,mesaure.safetyImageName,cell.imageViewDp.frame.size.width*DisplayScale,cell.imageViewDp.frame.size.height*DisplayScale]]];

}
#pragma mark -
#pragma mark - Table view delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static SafetyMeasureCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableViewSafety dequeueReusableCellWithIdentifier:@"SafetyMeasureCell"];
    });
    
    [self configureSafetyCell:sizingCell atIndexPath:indexPath];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPathSelected = indexPath;
    [self performSegueWithIdentifier:KSafetyDetailSegue sender:self];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:KSafetyDetailSegue])
    {
        SafetyDetailViewController *safetyVC = (SafetyDetailViewController *)segue.destinationViewController;
        SafetyMeasure *modal = [self.arraySafetyMeasures objectAtIndex:self.indexPathSelected.row];
        safetyVC.currentTab = self.feedType;
        safetyVC.stringSafety = modal.safetyDescription;
    }
}


@end
