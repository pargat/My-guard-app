//
//  MyProfileViewController.m
//  MyGuardApp
//
//  Created by vishnu on 22/09/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "MyProfileViewController.h"

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myProfile = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    [self.tableViewProfile setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getSafetyMeasure];
    [self.tableViewProfile reloadData];
    [self setNavBarAndTab];

}


#pragma mark - 
#pragma mark - View Helper
-(void)afterApi
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.myProfile.profileUnreadCount.integerValue;

}

#pragma mark - 
#pragma mark - Animation zoom
-(UIView *)viewForZoomTransition:(BOOL)isSource
{
    ProfileHeaderMyCell *cell = [self.tableViewProfile cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cell.imageViewDp;
}

#pragma mark -
#pragma mark - Helpers
- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

-(void)setNavBarAndTab
{
    [self.tabBarController.tabBar setTintColor:KOrangeColor];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    [navigationBar setBackgroundColor:KOrangeColor];
    
    [navigationBar setBarTintColor:KPurpleColorNav];
    [navigationBar setBarStyle:UIBarStyleBlack];
    [navigationBar setTranslucent:NO];
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [navigationBar setShadowImage:[UIImage new]];
    [self.navigationItem setTitle:NSLocalizedString(@"my_profile", nil)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIBarButtonItem *btnMore = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_more"] style:UIBarButtonItemStylePlain target:self action:@selector(actionMore)];
    [btnMore setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = btnMore;
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;

    
}
-(void)getSafetyMeasure
{
    
    [SafetyMeasure callAPIForSafetyMeasureOfUserOther:[NSString stringWithFormat:KGetProfile,KbaseUrl,self.myProfile.profileUserId,self.myProfile.profileUserId] Params:nil success:^(NSMutableDictionary *dict) {
        self.arraySafety = [dict valueForKey:@"array"];
        self.myProfile = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
        self.myProfile.profileUnreadCount = ((Profile *)[dict valueForKey:@"profile"]).profileUnreadCount;
        [[NSUserDefaults standardUserDefaults] rm_setCustomObject:self.myProfile forKey:@"profile"];
        [self.tableViewProfile reloadData];
        [self afterApi];
        
    } failure:^(NSString *errorStr) {
        
    }];

//    [SafetyMeasure callAPIForSafetyMeasureOfUserSelf:[NSString stringWithFormat:KGetProfile,KbaseUrl,self.myProfile.profileUserId,self.myProfile.profileUserId] Params:nil success:^(NSMutableArray *safetyArr) {
//        
//        self.arraySafety = [[NSMutableArray alloc] initWithArray:safetyArr];
//        [self.tableViewProfile reloadData];
//        
//    } failure:^(NSString *errorStr) {
//        
//    }];
}
#pragma mark -
#pragma mark - ProfileMyDelegate
-(void)delBigView
{
    [self performSegueWithIdentifier:KImageFullSegue sender:nil];
}

#pragma mark - 
#pragma mark - Animations 
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    MyProfileViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    FireViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.frame = [transitionContext.containerView convertRect:toViewController.imageViewS.frame  fromView:(UIButton *)[fromViewController.navigationItem.leftBarButtonItems firstObject]];
    
    [UIView animateWithDuration:0.5 animations:^{
        toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

#pragma mark -
#pragma mark - Table View Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.arraySafety.count==0)
    {
        return 2;
    }
    else
        return 1+self.arraySafety.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        ProfileHeaderMyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileHeaderMyCell"];
        [self configureProfileHeaderCell:cell atIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        if(self.arraySafety.count==0)
        {
            CommunityNoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityNoCell"];
            [cell.labelNoUsers setText:@"No safety measures shared yet"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
        else
        {
            SafetyProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SafetyProfileCell"];
            [self configureSafetyCell:cell atIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
    }
}

-(void)configureSafetyCell:(SafetyProfileCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SafetyMeasure *modal = [self.arraySafety objectAtIndex:indexPath.row-1];
    [cell.labelDescription setText:modal.safetyDescription];
    [cell.labelDescription setPreferredMaxLayoutWidth:self.view.frame.size.width - 82];
    if([modal.safetyType isEqualToString:@"1"])
    {
        [cell.imageViewType setImage:[UIImage imageNamed:@"tb_fire_pressed"]];
        [cell.labelTitle setText:@"Shared a safety measure in Fire Safety"];
    }
    else if ([modal.safetyType isEqualToString:@"2"])
    {
        [cell.imageViewType setImage:[UIImage imageNamed:@"tb_co_pressed"]];
        [cell.labelTitle setText:@"Shared a safety measure in CO"];
    }
    else
    {
        [cell.imageViewType setImage:[UIImage imageNamed:@"tb_gun_pressed"]];
        [cell.labelTitle setText:@"Shared a safety measure in Gun Safety"];
    }
    [cell.labelTitle setHidden:NO];
    [cell.labelDisplayTime setText:modal.safetyDisplayTime];
}
-(void)configureProfileHeaderCell:(ProfileHeaderMyCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.delegate = self;
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:KBaseTimbthumbUrl,self.myProfile.profileImageFullLink,cell.imageViewDp.frame.size.width*DisplayScale,cell.imageViewDp.frame.size.height*DisplayScale]]];
    [cell.labelName setText:self.myProfile.profileUserName];
    [cell.labelPhoneNumber setText:self.myProfile.profilePhoneNumber];
    [cell.labelAddress setText:self.myProfile.profileAddress];
    if([self.myProfile.profileUnreadCount integerValue]>0)
    {
        [cell.viewNotifCount setHidden:NO];
        [cell.labelNotifCount setText:self.myProfile.profileUnreadCount];
    }
    else
    {
        [cell.viewNotifCount setHidden:YES];
    }
}

#pragma mark -
#pragma mark - Table view delegates
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
    static ProfileHeaderMyCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileHeaderMyCell"];
    });
    
    [self configureProfileHeaderCell:sizingCell atIndexPath:indexPath];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
    }
    else
    {
        if(self.arraySafety.count==0)
        {
            static CommunityNoCell *sizingCell = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                sizingCell = [tableView dequeueReusableCellWithIdentifier:@"CommunityNoCell"];
            });
            
            CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size.height+1;
            
        }
        else
        {
            static SafetyProfileCell *sizingCell = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                sizingCell = [tableView dequeueReusableCellWithIdentifier:@"SafetyProfileCell"];
            });
            
            [self configureSafetyCell:sizingCell atIndexPath:indexPath];
            CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size.height+1;
        }
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        if(indexPath.row>0&&self.arraySafety.count!=0)
     [self performSegueWithIdentifier:KSafetyDetailSegue sender:[self.arraySafety objectAtIndex:indexPath.row-1]];
}
#pragma mark -
#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self performSegueWithIdentifier:KEditProfileSegue sender:self];
    }
}

#pragma mark -
#pragma mark - Button Actions
-(void)actionMore
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit Profile", nil];
    [actionSheet showInView:self.view];
    
}
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - 
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:KSafetyDetailSegue])
    {
        SafetyDetailViewController *safetyVC = (SafetyDetailViewController *)segue.destinationViewController;
        SafetyMeasure *modal = (SafetyMeasure *)sender;
        if([modal.safetyType isEqualToString:@"1"])
        {
            safetyVC.currentTab = @"1";
            
        }
        else if ([modal.safetyType isEqualToString:@"2"])
        {
            safetyVC.currentTab = @"2";
        }
        else
        {
            safetyVC.currentTab = @"3";
        }
        
        safetyVC.stringSafety = modal.safetyDescription;

        safetyVC.stringSafety = modal.safetyDescription;
    }
    else if ([segue.identifier isEqualToString:KImageFullSegue])
    {
        ImageFullViewController *imageVc = (ImageFullViewController *)segue.destinationViewController;
        imageVc.username = self.myProfile.profileUserName;
        imageVc.imageLink = self.myProfile.profileImageFullLink;
    }
}
@end
