//
//  CommunitySearchViewController.m
//  MyGuardApp
//
//  Created by vishnu on 22/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "CommunitySearchViewController.h"

@interface CommunitySearchViewController ()

@end

@implementation CommunitySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self searchUser];
    [self.tableViewCommunity setTableFooterView:[[UIView alloc] init]];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeLoaderView];
}

#pragma mark -
#pragma mark - View Helpers
-(void)searchUser
{
    CommunityViewController *cVC = (CommunityViewController *)self.parentViewController;
    if(cVC.isSearching==true)
    {
        [iOSRequest getJsonResponse:[NSString stringWithFormat:KSearchUsers,KbaseUrl,[Profile getCurrentProfileUserId],cVC.sBar.text] success:^(NSDictionary *responseDict) {
        //self.arrayCommunity
           self.arrayCommunity = [User parseDictToModal:[responseDict valueForKey:@"data"]];
            [self.tableViewCommunity reloadData];
        } failure:^(NSString *errorString) {
        
        }];
    }
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
            return 1;
        }
        else
        {
            return self.arrayCommunity.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommunityViewController *cVC = (CommunityViewController *)self.parentViewController;

    if(self.arrayCommunity.count==0&&cVC.isSearching==false)
    {
        CommunityNoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityNoCell"];
        [cell.labelNoUsers setText:@"Search Users"];
        cell.separatorInset = UIEdgeInsetsZero;
        return cell;
    }
    else if (cVC.isSearching&&self.arrayCommunity.count==0)
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
    User *tempuser;
    tempuser = [self.arrayCommunity objectAtIndex:indexPath.row];
    
    
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
#pragma mark -
#pragma mark - XlChild

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
        return NSLocalizedString(@"search", nil);
}

#pragma mark -
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    User *modal = [self.arrayCommunity objectAtIndex:self.selectedIndex];
    OtherProfileViewController *otherVC = (OtherProfileViewController *)segue.destinationViewController;
    otherVC.stringUserId = modal.userUserId;
    otherVC.stringUsername = modal.userUserName;
}

@end
