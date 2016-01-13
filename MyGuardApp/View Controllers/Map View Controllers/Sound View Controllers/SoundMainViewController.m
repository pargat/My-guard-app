//
//  SoundMainViewController.m
//  MyGuardApp
//
//  Created by vishnu on 15/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SoundMainViewController.h"

@interface SoundMainViewController ()

@end

@implementation SoundMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self viewHelpers];
    
}
#pragma mark -
#pragma mark - View Helpers
-(void)viewHelpers
{
    [self.tableViewSound setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableViewSound reloadData];
}
-(void)setUpNavBar
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBarTintColor:KPurpleColorNav];
    [navigationBar setBarStyle:UIBarStyleBlack];
    [navigationBar setTranslucent:NO];
    
    [self.navigationItem setTitle:NSLocalizedString(@"alert_sounds", nil)];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;

}

#pragma mark - 
#pragma mark - Table View Delegate and datasource functions
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        SoundMainCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"SoundMainCell1"];
        [self configureCellMain:cell atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        SoundMainCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"SoundMainCell2"];
        [self configureCell:cell atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        static SoundMainCell1 *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"SoundMainCell1"];
        });
        
        [self configureCellMain:sizingCell atIndexPath:indexPath];
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;

    }
    else
    {
        static SoundMainCell2 *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"SoundMainCell2"];
        });
        
        [self configureCell:sizingCell atIndexPath:indexPath];
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;

    }
}
-(void)configureCellMain:(SoundMainCell1 *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell.label1 setText:NSLocalizedString(@"customise_alert", nil)];
    [cell.label2 setText:NSLocalizedString(@"or_choose_preset", nil)];
}
-(void)configureCell:(SoundMainCell2 *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1)
    {
        [cell.labelTypeName setText:NSLocalizedString(@"fire_walk_t", nil)];
        [cell.labelSelectedSound setText:[[[NSUserDefaults standardUserDefaults] valueForKey:@"FireSound"] stringByDeletingPathExtension]];
    }
    else if (indexPath.row==2)
    {
        [cell.labelTypeName setText:NSLocalizedString(@"gun_walk_t", nil)];
        [cell.labelSelectedSound setText:[[[NSUserDefaults standardUserDefaults] valueForKey:@"GunSound"] stringByDeletingPathExtension]];
    }
         
    else
    {
        [cell.labelTypeName setText:NSLocalizedString(@"co_walk_t", nil)];
        [cell.labelSelectedSound setText:[[[NSUserDefaults standardUserDefaults] valueForKey:@"COSound"] stringByDeletingPathExtension]];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1)
    {
        [self performSegueWithIdentifier:KSoundSelectSegue sender:@"Fire"];
    }
    else if (indexPath.row==2)
    {
        [self performSegueWithIdentifier:KSoundSelectSegue sender:@"Gun"];
    }
    else if (indexPath.row==3)
    {
        [self performSegueWithIdentifier:KSoundSelectSegue sender:@"CO"];
    }
}
#pragma mark -
#pragma mark - Button Actions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:KSoundSelectSegue])
    {
        SoundSelectViewController *soundVC = (SoundSelectViewController *)segue.destinationViewController;
        soundVC.stringType = (NSString *)sender;
    }
}


@end
