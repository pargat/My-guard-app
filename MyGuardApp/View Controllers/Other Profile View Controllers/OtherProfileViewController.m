//
//  OtherProfileViewController.m
//  MyGuardApp
//
//  Created by vishnu on 15/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "OtherProfileViewController.h"

@interface OtherProfileViewController ()

@end

@implementation OtherProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSafetyMeasure];
    [self.tableViewProfile setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self setNavBarAndTab];
    [self.tableViewProfile setDelegate:self];
    [self.tableViewProfile setDataSource:self];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Helpers
- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

-(void)setNavBarAndTab
{
        
    [self.navigationItem setTitle:self.stringUsername];
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
    [self setUpLoaderView];
    [SafetyMeasure callAPIForSafetyMeasureOfUserOther:[NSString stringWithFormat:KGetProfile,KbaseUrl,self.stringUserId,[Profile getCurrentProfileUserId]] Params:nil success:^(NSMutableDictionary *dict) {
        self.arraySafety = [dict valueForKey:@"array"];
        self.myProfile = [dict valueForKey:@"profile"];
        [self.tableViewProfile reloadData];
        [self removeLoaderView];

    } failure:^(NSString *errorStr) {
        [self removeLoaderView];
        
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
        ProfileHeaderOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileHeaderOtherCell"];
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
-(void)configureProfileHeaderCell:(ProfileHeaderOtherCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:KBaseTimbthumbUrl,self.myProfile.profileImageName,cell.imageViewDp.frame.size.width*DisplayScale,cell.imageViewDp.frame.size.height*DisplayScale]]];
    [cell.labelName setText:self.myProfile.profileFirstName];
    [cell.labelPhoneNumber setText:self.myProfile.profilePhoneNumber];
    [cell.labelAddress setText:self.myProfile.profileAddress];
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
        static ProfileHeaderOtherCell *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileHeaderOtherCell"];
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


#pragma mark -
#pragma mark - Button Actions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)actionMore
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
