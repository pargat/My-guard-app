//
//  CommunityContentViewController.m
//  MyGuardApp
//
//  Created by vishnu on 21/09/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "CommunityContentViewController.h"

@implementation CommunityContentViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setter];
    
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
    
    [User callAPIForCommunityUser:stringUrl Params:nil success:^(NSMutableArray *userArr) {
        self.arrayCommunity = [[NSMutableArray alloc] initWithArray:userArr];
        [self.tableViewCommunity reloadData];
    } failure:^(NSString *errorStr) {
        
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
    return self.arrayCommunity.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityCell"];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static CommunityCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableViewCommunity dequeueReusableCellWithIdentifier:@"CommunityCell"];
    });
    
    [self configureCell:sizingCell atIndexPath:indexPath];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
    
}

-(void)configureCell:(CommunityCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    User *tempuser = [self.arrayCommunity objectAtIndex:indexPath.row];
    [cell.labelDistance setText:@"1"];
    [cell.labelName setText:tempuser.userFirstName];
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:KBaseTimbthumbUrl,tempuser.userImageName,cell.imageViewDp.frame.size.width*DisplayScale,cell.imageViewDp.frame.size.height*DisplayScale]]];
}



@end
