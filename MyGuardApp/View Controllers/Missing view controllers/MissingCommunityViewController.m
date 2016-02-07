//
//  MissingCommunityViewController.m
//  MyGuardApp
//
//  Created by vishnu on 13/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import "MissingCommunityViewController.h"

@interface MissingCommunityViewController ()

@end

@implementation MissingCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableViewMissing setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    // Do any additional setup after loading the view.
    [self setUpLoaderView];
    [self addPullToRefresh];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMissingPeople];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.delegate delShouldShowAdd:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.delegate delShouldShowAdd:NO];
    [self removeLoaderView];
}
#pragma mark -
#pragma mark - Helper functions
-(void)addPullToRefresh
{
    [self.tableViewMissing addPullToRefreshWithActionHandler:^{
        self.page = 0;
        [self getMissingPeople];
        
    }];
    [self.tableViewMissing addInfiniteScrollingWithActionHandler:^{
        self.page++;
        [self getMissingPeople];
    }];
}
-(void)getMissingPeople
{
    
    Profile *profile = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    LOcationUpdater *loc = [LOcationUpdater sharedManager];

    [MissingModal callAPIForMissing:[NSString stringWithFormat:KListMissing,KbaseUrl,profile.profileUserId,loc.currentLoc.coordinate.latitude,loc.currentLoc.coordinate.longitude,self.page] Params:nil success:^(NSMutableArray *offenderArr) {
        if (self.page==0) {
            self.arrayMissing = offenderArr;
        }
        else
        {
            [self.arrayMissing addObjectsFromArray:offenderArr];
        }
        [self.tableViewMissing reloadData];

        [self removeLoaderView];
        [self.tableViewMissing.infiniteScrollingView stopAnimating];
        [self.tableViewMissing.pullToRefreshView stopAnimating];
    } failure:^(NSString *errorStr) {
        [self removeLoaderView];
        [self.tableViewMissing.infiniteScrollingView stopAnimating];
        [self.tableViewMissing.pullToRefreshView stopAnimating];
    }];
}

#pragma mark -
#pragma mark - XlChild

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    
    return NSLocalizedString(@"missing_people", nil);
        
}

#pragma mark -
#pragma mark - Table View Datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:KMissingDetailSegue sender:[self.arrayMissing objectAtIndex:indexPath.row]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
        static MissingCommunityCell *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"MissingCommunityCell"];
        });
        
        [self configureMissingCell:sizingCell atIndexPath:indexPath];
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
  }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMissing.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        MissingCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissingCommunityCell"];
        
        [self configureMissingCell:cell atIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        return cell;
}

#pragma mark -
#pragma mark - Table view helpers
-(void)configureMissingCell:(MissingCommunityCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    MissingModal *modal = [self.arrayMissing objectAtIndex:indexPath.row];
    [cell.labelLast setText:modal.missingLocation];
    [cell.labelMissingSince setText:modal.missingDate];
    [cell.labelDescription setText:modal.missingDescription];
    [cell.labelName setText:modal.missingName];
    [cell.labelEye setText:modal.missingEye];
    [cell.labelHair setText:modal.missingHair];
    [cell.labelHeight setText:modal.missingHeight];
    [cell.labelAge setText:modal.missingAge];
    [cell.imageViewPerson sd_setImageWithURL:[NSURL URLWithString:modal.missingImage]];
    cell.stringPhone = modal.missingPhone;
    [cell.labelDescription setPreferredMaxLayoutWidth:self.view.frame.size.width - 112];
}


#pragma mark-
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    MissingPersonViewController *mVC = (MissingPersonViewController *)segue.destinationViewController;
    mVC.missingModal = (MissingModal*)sender;
}


@end
