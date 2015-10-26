//
//  CommunityContentViewController.m
//  MyGuardApp
//
//  Created by vishnu on 21/09/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "CommunityContentViewController.h"

@implementation CommunityContentViewController

{
    JTMaterialSpinner *loaderObj ;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLoaderView];
    [self getCommunityUsers];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setter];
    
}



#pragma mark -
#pragma mark - Helper and api related functions
-(void)setter
{
    [self.tableViewCommunity setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self getCommunityUsers];

}
-(void)getCommunityUsers
{
    NSString *stringUrl;
    Profile *profile = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    LOcationUpdater *loc = [LOcationUpdater sharedManager];
    if(self.currentTab==NEIGHBOUR)
    {
        stringUrl = [NSString stringWithFormat:KListNeighbours,KbaseUrl,profile.profileUserId,loc.currentLoc.coordinate.latitude,loc.currentLoc.coordinate.longitude];
    }
    else if (self.currentTab==FAMILY)
    {
        stringUrl = [NSString stringWithFormat:KListFamily,KbaseUrl,profile.profileUserId];
    }
    else if (self.currentTab==FRIENDS)
    {
        stringUrl = [NSString stringWithFormat:KListFriends,KbaseUrl,profile.profileUserId];
    }
    else
    {
        stringUrl = [NSString stringWithFormat:KListFriends,KbaseUrl,profile.profileUserId];

    }
    [User callAPIForCommunityUser:stringUrl Params:nil success:^(NSMutableArray *userArr) {
        self.arrayCommunity = [[NSMutableArray alloc] initWithArray:userArr];
        [self.tableViewCommunity reloadData];
        [self removeLoaderView];
    } failure:^(NSString *errorStr) {
        [self removeLoaderView];
    }];
    
}
#pragma mark -
#pragma mark - XlChild

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    
    if(self.currentTab==NEIGHBOUR)
    {
        return NSLocalizedString(@"neighbourhood", nil);
    }
    else if (self.currentTab==FAMILY)
    {
        return NSLocalizedString(@"family", nil);
    }
    else if (self.currentTab==FRIENDS)
    {
        return NSLocalizedString(@"friends", nil);
        
    }
    else
    {
        return NSLocalizedString(@"search", nil);
        
    }
    
    return NSLocalizedString(@"feed", nil);
}


#pragma mark -
#pragma mark - Table View Delegate and datasource function

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(self.arrayCommunity.count==0)
        return 1;
    else
    {
        CommunityViewController *cVC = (CommunityViewController *)self.parentViewController;
        if(cVC.isSearching)
        {
            return self.arraySearch.count;
        }
        else
        {
            return self.arrayCommunity.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.arrayCommunity.count==0)
    {
        CommunityNoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityNoCell"];
        [cell.labelNoUsers setText:@"No users"];
        cell.separatorInset = UIEdgeInsetsZero;
        return cell;
    }
    else
    {
        CommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityCell"];
        [self configureCell:cell atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.arrayCommunity.count==0)
    {
        
        static CommunityNoCell *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [self.tableViewCommunity dequeueReusableCellWithIdentifier:@"CommunityNoCell"];
        });
        
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    }
    else
    {
    static CommunityCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableViewCommunity dequeueReusableCellWithIdentifier:@"CommunityCell"];
    });
    
    [self configureCell:sizingCell atIndexPath:indexPath];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
    }
    
}

-(void)configureCell:(CommunityCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CommunityViewController *cVC = (CommunityViewController *)self.parentViewController;
    User *tempuser;
    if(cVC.isSearching)
    {
        tempuser = [self.arraySearch objectAtIndex:indexPath.row];

    }
    else
    {
        tempuser = [self.arrayCommunity objectAtIndex:indexPath.row];

    }

        [cell.labelDistance setText:@"1"];
    [cell.labelName setText:tempuser.userFirstName];
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:KBaseTimbthumbUrl,tempuser.userImageName,cell.imageViewDp.frame.size.width*DisplayScale,cell.imageViewDp.frame.size.height*DisplayScale]]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.arrayCommunity.count!=0)
    {
    self.selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:KOtherProfileSegue sender:self];
    }
}

#pragma mark - Hide Unhide Loader View

-(void)setUpLoaderView
{
    [loaderObj removeFromSuperview];
    loaderObj = [[JTMaterialSpinner alloc] init];
    loaderObj.frame = CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-20, 40, 40);
    loaderObj.circleLayer.lineWidth = 2.0;
    
    loaderObj.circleLayer.strokeColor = KPurpleColor.CGColor;
    [[UIApplication sharedApplication].keyWindow addSubview:loaderObj];
    [loaderObj beginRefreshing];
}

-(void)removeLoaderView
{
    [loaderObj removeFromSuperview];
    [loaderObj endRefreshing];
}


#pragma mark -
#pragma mark - Navigation related
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    User *modal ;
    CommunityViewController *cVC = (CommunityViewController *)self.parentViewController;
    if(cVC.isSearching)
    {
        modal = [self.arraySearch objectAtIndex:self.selectedIndex];
    }
    else
    {
        modal = [self.arrayCommunity objectAtIndex:self.selectedIndex];
    }

    OtherProfileViewController *otherVC = (OtherProfileViewController *)segue.destinationViewController;
    otherVC.stringUserId = modal.userUserId;
    otherVC.stringUsername = modal.userUserName;
}


@end
