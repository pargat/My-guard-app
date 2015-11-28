//
//  NotificationViewController.m
//  MyGuardApp
//
//  Created by vishnu on 05/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "NotificationViewController.h"

@implementation NotificationViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self viewHelper];
    [self setUpLoaderView];
    [self getNotifs:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBar];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeLoaderView];
}
#pragma mark -
#pragma mark - View Helpers
-(NSString *) stringByStrippingHTML:(NSString *)s {
    NSRange r;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}
-(void)readNotif:(NSString *)idNotif
{
    [iOSRequest getJsonResponse:[NSString stringWithFormat:KMarkNotificationApi,KbaseUrl,[Profile getCurrentProfileUserId],idNotif] success:^(NSDictionary *responseDict) {
        
    } failure:^(NSString *errorString) {
        
    }];
}

-(void)readNotif
{
    NotificationModal *modal = [self.arrayNotifs objectAtIndex:self.selectedIndexPath.row];
    
    [iOSRequest getJsonResponse:[NSString stringWithFormat:KMarkNotificationApi,KbaseUrl,[Profile getCurrentProfileUserId],modal.notifId] success:^(NSDictionary *responseDict) {
        
    } failure:^(NSString *errorString) {
        
    }];
}
-(void)viewHelper
{
    [self.tableViewNotifs setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableViewNotifs setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}
-(void)setNavBar
{
    [self.navigationController.navigationBar setBarTintColor:KPurpleColorNav];
    [self.navigationItem setTitle:NSLocalizedString(@"alert", nil)];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    UIBarButtonItem *btnClearAll = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"clear_all", nil) style:UIBarButtonItemStylePlain target:self action:@selector(actionClearAll)];
    [btnClearAll setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = btnClearAll;
    
}

-(void)getNotifs:(BOOL)refresh
{
    if(refresh)
    {
        self.pageIndex = 0;
    }
    else
    {
        self.pageIndex++;
    }
    [NotificationModal callAPIForNotifications:[NSString stringWithFormat:KGetNotificationApi,KbaseUrl,[Profile getCurrentProfileUserId],self.pageIndex] Params:nil success:^(NSMutableArray *notifArr) {
        if(refresh)
        {
            self.arrayNotifs = notifArr;
        }
        else
        {
            [self.arrayNotifs addObjectsFromArray:notifArr];
        }
        if(self.tableViewNotifs.delegate ==nil)
        {
            [self.tableViewNotifs setDelegate:self];
            [self.tableViewNotifs setDataSource:self];
        }
        if(self.arrayNotifs.count == 0)
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
        [self.tableViewNotifs reloadData];
        [self removeLoaderView];
    } failure:^(NSString *errorStr) {
        [self removeLoaderView];
    }];
}

#pragma mark -
#pragma mark - Request delegate
-(void)delAcceptOrReject:(BOOL)accept atIndexPath:(NSIndexPath *)indexPath
{
    
    NotificationModal *modal = [self.arrayNotifs objectAtIndex:indexPath.row];
    NSString *familyUrl;
    if(accept)
    {
        NSString *type;
        if([modal.notifType isEqualToString:@"1"])
        {
            type = @"1";
        }
        else
        {
            type = @"2";
        }
        familyUrl = [NSString stringWithFormat:KAcceptRequest,KbaseUrl,[Profile getCurrentProfileUserId],modal.notifFromUser,type];
    }
    else
    {
        familyUrl = [NSString stringWithFormat:KCancelRequest,KbaseUrl,[Profile getCurrentProfileUserId],modal.notifFromUser];
        
        
        
    }
    [iOSRequest getJsonResponse:familyUrl success:^(NSDictionary *responseDict) {
        
    } failure:^(NSString *errorString) {
        
    }];
    
    [self.arrayNotifs removeObjectAtIndex:indexPath.row];
    [self.tableViewNotifs reloadData];
    [self readNotif:modal.notifId];
    
}

#pragma mark -
#pragma mark - Table View Delegate and datasource function

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(self.arrayNotifs.count==0)
        return 1;
    else
        return self.arrayNotifs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.arrayNotifs.count==0)
    {
        CommunityNoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityNoCell"];
        [cell.labelNoUsers setText:@"No new notifications"];
        cell.separatorInset = UIEdgeInsetsZero;
        return cell;
    }
    else
    {
        NotificationModal *modal = [self.arrayNotifs objectAtIndex:indexPath.row];
        
        if([modal.notifType isEqualToString:@"1"]||[modal.notifType isEqualToString:@"2"])
        {
            NotificationRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationRequestCell"];
            [self configureCellRequest:cell atIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            NotificationSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationSimpleCell"];
            [self configureCell:cell atIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.arrayNotifs.count==0)
    {
        
        static CommunityNoCell *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [self.tableViewNotifs dequeueReusableCellWithIdentifier:@"CommunityNoCell"];
        });
        
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
    }
    else
    {
        NotificationModal *modal = [self.arrayNotifs objectAtIndex:indexPath.row];
        
        if([modal.notifType isEqualToString:@"1"]||[modal.notifType isEqualToString:@"2"])
        {
            static NotificationRequestCell *sizingCell = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                sizingCell = [self.tableViewNotifs dequeueReusableCellWithIdentifier:@"NotificationRequestCell"];
            });
            
            [self configureCellRequest:sizingCell atIndexPath:indexPath];
            CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size.height+1;
            
        }
        else
        {
            static NotificationSimpleCell *sizingCell = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                sizingCell = [self.tableViewNotifs dequeueReusableCellWithIdentifier:@"NotificationSimpleCell"];
            });
            
            [self configureCell:sizingCell atIndexPath:indexPath];
            CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size.height+1;
            
        }
        
    }
    
}

-(void)configureCell:(NotificationSimpleCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell.labelTitlw setPreferredMaxLayoutWidth:self.view.frame.size.width - 88];
    [cell.labelDescription setPreferredMaxLayoutWidth:self.view.frame.size.width - 88];

    NotificationModal *modal = [self.arrayNotifs objectAtIndex:indexPath.row];
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&w=%f&h=%f",modal.notifDp,cell.imageViewDp.frame.size.width*DisplayScale,cell.imageViewDp.frame.size.height*DisplayScale]]];
    
    
    [cell.labelTitlw setText:[self stringByStrippingHTML:modal.notifTitle]];
    [cell.labelTitlw setFont:[UIFont systemFontOfSize:14]];
    [cell.labelDescription setText:@""];
    [cell.labelTimePassed setText:modal.notifTimePassed];
    if([modal.notifIsRead isEqualToString:@"y"])
    {
        [cell.viewOverlay setHidden:YES];
    }
    else
    {
        [cell.viewOverlay setHidden:NO];
    }
    
}
-(void)configureCellRequest:(NotificationRequestCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    cell.selectedIndex = indexPath;
    NotificationModal *modal = [self.arrayNotifs objectAtIndex:indexPath.row];
    cell.delegate = self;
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&w=%f&h=%f",modal.notifDp,cell.imageViewDp.frame.size.width*DisplayScale,cell.imageViewDp.frame.size.height*DisplayScale]]];
    
    
    
    [cell.labelTitle setText:[self stringByStrippingHTML:modal.notifTitle]];
    [cell.labelTitle setFont:[UIFont systemFontOfSize:14]];
    [cell.labelTimePassed setText:modal.notifTimePassed];
    if([modal.notifIsRead isEqualToString:@"y"])
    {
        [cell.viewOverlauy setHidden:YES];
    }
    else
    {
        [cell.viewOverlauy setHidden:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.arrayNotifs.count!=0)
    {
        self.selectedIndexPath = indexPath;
        NotificationModal *modal = [self.arrayNotifs objectAtIndex:indexPath.row];
        if([modal.notifType isEqualToString:@"5"])
        {
            [self performSegueWithIdentifier:KSafetyDetailSegue sender:self];
        }
        else if ([modal.notifType isEqualToString:@"3"]||[modal.notifType isEqualToString:@"1"]||[modal.notifType isEqualToString:@"2"])
        {
            [self performSegueWithIdentifier:KOtherProfileSegue sender:modal];
        }
        else if ([modal.notifType isEqualToString:@"4"]||[modal.notifType isEqualToString:@"6"])
        {
            [self performSegueWithIdentifier:KImageVideoDetailSegue sender:@{@"id":modal.notifAlarmId,@"mid":modal.notifRefId}];
        }
        else if ([modal.notifType isEqualToString:@"7"])
        {
            [self performSegueWithIdentifier:KImageVideoDetailSegue sender:@{@"id":modal.notifAlarmId,@"mid":modal.notifRefId,@"Comment":@"yes"}];
        }
        
        [self readNotif];
        modal.notifIsRead = @"y";
        [self.tableViewNotifs reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark -
#pragma mark - Button Actions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)actionClearAll
{
    [iOSRequest getJsonResponse:[NSString stringWithFormat:KClearAllNotifs,KbaseUrl,[Profile getCurrentProfileUserId]] success:^(NSDictionary *responseDict) {
        
    } failure:^(NSString *errorString) {
        
    }];
    self.arrayNotifs = [[NSMutableArray alloc] init];
    [self.tableViewNotifs reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NotificationModal *modal = [self.arrayNotifs objectAtIndex:self.selectedIndexPath.row];
    if([segue.identifier isEqualToString:KSafetyDetailSegue])
    {
        SafetyDetailViewController *safetyVC = (SafetyDetailViewController *)segue.destinationViewController;
        safetyVC.stringId = modal.notifRefId;
        
    }
    else if ([segue.identifier isEqualToString:KOtherProfileSegue])
    {
        OtherProfileViewController *otherVC = (OtherProfileViewController *)segue.destinationViewController;
        NotificationModal *modal = (NotificationModal *)sender;
        otherVC.stringUserId = modal.notifFromUser;
        otherVC.stringUsername = modal.notifFirstName;
    }
    else if ([segue.identifier isEqualToString:KImageVideoDetailSegue])
    {
        ImageVideoDetailViewController *imageVideoDetailVc = (ImageVideoDetailViewController *)segue.destinationViewController;
        imageVideoDetailVc.stringFeedId = [sender valueForKey:@"id"];
        imageVideoDetailVc.stringPostId = [sender valueForKey:@"mid"];
        if([sender valueForKey:@"Comment"]!=nil)
            imageVideoDetailVc.isCommentShow = YES;
        
    }
}


@end
