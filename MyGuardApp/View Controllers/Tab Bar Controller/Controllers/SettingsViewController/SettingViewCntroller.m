//
//  SettingViewCntroller.m
//  MyGuardApp
//
//  Created by vishnu on 28/09/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SettingViewCntroller.h"

@implementation SettingViewCntroller
{
    JTMaterialSpinner *loaderObj ;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.arraySettings = @[NSLocalizedString(@"sex_title", nil),NSLocalizedString(@"video_title", nil),NSLocalizedString(@"change_alert_sounds", nil),NSLocalizedString(@"users_guide", nil),NSLocalizedString(@"demo", nil),NSLocalizedString(@"invite_fb_friends", nil),NSLocalizedString(@"contact_us", nil),NSLocalizedString(@"legal", nil),NSLocalizedString(@"logout", nil)];
    [self.tableViewSettings setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self setUpNavBar];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Demo"];
}
-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
     [self.navigationController.navigationBar setHidden:NO];
    
}

#pragma mark -
#pragma mark - Helper functions
-(void)setUpNavBar
{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    [self.navigationItem setTitle:NSLocalizedString(@"setting_title", nil)];
}
#pragma mark -
#pragma mark - Table View Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0||indexPath.row==1)
    {
        SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingSwitchCell"];
        [self configureSettingSwitch:cell atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    else if(indexPath.row==2||indexPath.row==3)
    {
        SettingCellDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellDescriptionCell"];
        [cell.labelTitle setText:[self.arraySettings objectAtIndex:indexPath.row]];
        [self configureSettingCelldescription:cell atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
        [self configureSettingCell:cell atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)configureSettingCell:(SettingCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell.labelTitle setText:[self.arraySettings objectAtIndex:indexPath.row]];
    
    
}
-(void)configureSettingCelldescription:(SettingCellDescriptionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell.labelDescription setPreferredMaxLayoutWidth:self.view.frame.size.width - 64];
    if(indexPath.row==2)
    {
        [cell.viewBottom setHidden:YES];
        cell.heightBottom.constant = 0;
        [cell.labelDescription setText:NSLocalizedString(@"custom_alert_description", nil)];
    }
    else
    {
        [cell.viewBottom setHidden:NO];
        cell.heightBottom.constant = 8;
        [cell.labelDescription setText:NSLocalizedString(@"user_guide_des", nil)];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:cell.viewShadow.bounds];
        cell.viewShadow.layer.masksToBounds = NO;
        cell.viewShadow.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.viewShadow.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        cell.viewShadow.layer.shadowOpacity = 0.75f;
        cell.viewShadow.layer.shadowPath = shadowPath.CGPath;
        cell.separatorInset = UIEdgeInsetsMake(0.f, 10+cell.bounds.size.width, 0.f, 0.f);
        
        
    }
    
}
-(void)configureSettingSwitch:(SettingSwitchCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell.labelDescription setPreferredMaxLayoutWidth:self.view.frame.size.width - 64 - cell.switchVideo.frame.size.width ];
    [cell.labelTitle setText:[self.arraySettings objectAtIndex:indexPath.row]];
    cell.indexPath = indexPath;
    if(indexPath.row==0)
    {
        [cell.switchVideo setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"sex_permission"]];
        [cell.labelDescription setText:NSLocalizedString(@"sex_desc", nil)];

    }
    else
    {
        [cell.switchVideo setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"video_permission"]];
        [cell.labelDescription setText:NSLocalizedString(@"video_description", nil)];
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
    [self.view addSubview:loaderObj];
    [loaderObj beginRefreshing];
}

-(void)removeLoaderView
{
    [loaderObj removeFromSuperview];
    [loaderObj endRefreshing];
}


#pragma mark -
#pragma mark - Table Helper
- (void)logOutClicked
{
    
    NSString *urlString = [NSString stringWithFormat:KLogoutApi,KbaseUrl,[Profile getCurrentProfileUserId]];
    [self setUpLoaderView];
    [iOSRequest getJsonResponse:urlString success:^(NSDictionary *responseDict) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profile"];
        [[NSUserDefaults standardUserDefaults] rm_setCustomObject:nil forKey:@"sex_loc"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sex_loc"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"sex_list"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"sex_in"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"sex_in"];

        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

        [[NSUserDefaults standardUserDefaults] synchronize];
        LOcationUpdater *loc = [LOcationUpdater sharedManager];
        loc.imageDp = nil;
        [loaderObj removeFromSuperview];
        
        [self performSegueWithIdentifier:KLogoutUnwindSegue sender:self];
    } failure:^(NSString *errorString) {
        [loaderObj removeFromSuperview];
    }];
    
    
}


#pragma mark -
#pragma mark - Table view delegates
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=1)
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==2)
    {
        [self performSegueWithIdentifier:KSoundMainSegue sender:self];
    }
    else if (indexPath.row==3)
    {
        [self performSegueWithIdentifier:KUserGuideSegue sender:self];
    }
    else if (indexPath.row==4)
    {
           [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"Demo"];
        [self performSegueWithIdentifier:KDemo1Segue sender:nil];
    }
    else if(indexPath.row==5)
    {
        FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
        content.appLinkURL = [NSURL URLWithString:@"https://fb.me/727046074067178"];
        //optionally set previewImageURL
        content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://img.youtube.com/vi/fuBhQX3ki1Q/mqdefault.jpg"];
        
        // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
        [FBSDKAppInviteDialog showWithContent:content
                                     delegate:self];
    }
    else if (indexPath.row==6)
    {
        [self mailComposer];
    }
    else if (indexPath.row==7)
    {
        [self performSegueWithIdentifier:KTCSegue sender:self];
        
    }
    else if(indexPath.row==8)
    {
        [self logOutClicked];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0||indexPath.row==1)
    {
        static SettingSwitchCell *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"SettingSwitchCell"];
        });
        
        [self configureSettingSwitch:sizingCell atIndexPath:indexPath];
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
    }
    else if(indexPath.row==2||indexPath.row==3)
    {
        static SettingCellDescriptionCell *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellDescriptionCell"];
        });
        
        [self configureSettingCelldescription:sizingCell atIndexPath:indexPath];
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
    }
    else
    {
        static SettingCell *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
        });
        
        [self configureSettingCell:sizingCell atIndexPath:indexPath];
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    }
    
}


#pragma mark -
#pragma mark - Helpers setting
-(void)mailComposer
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Sample Subject"];
        [mail setMessageBody:@"Here is some main text in the email!" isHTML:NO];
        [mail setToRecipients:@[@"support@firesonar.com"]];
        
        [self presentViewController:mail animated:YES completion:nil];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
    
}

#pragma mark -
#pragma mark - Mail composer delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark -
#pragma mark - facebook invite delegate
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    
}
#pragma mark -
#pragma mark - Button Actions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
