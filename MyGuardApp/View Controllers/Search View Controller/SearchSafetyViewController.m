//
//  SearchSafetyViewController.m
//  MyGuardApp
//
//  Created by vishnu on 02/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SearchSafetyViewController.h"

@interface SearchSafetyViewController ()

@end

@implementation SearchSafetyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewHelper];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableViewSearch reloadData];
//    if(self.stringToSearch!=nil)
//    {
//        [self apiSearch:self.stringToSearch];
//    }
}


#pragma mark - 
#pragma mark -  View helpers
-(void)viewHelper
{
    [self.tableViewSearch setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableViewSearch setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.tableViewSearch setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void)apiSearch:(NSString *)str
{
    NSString * stringSearchSafety = [NSString stringWithFormat:KSearchNewApi,KbaseUrl,[Profile getCurrentProfileUserId],str,@"2"];
    
    [iOSRequest getJsonResponse:stringSearchSafety success:^(NSDictionary *responseDict) {
        self.loaded = true;
        self.arraySearch = [SafetyMeasure parseDictToModal:[responseDict valueForKey:@"data"]];
        if(self.tableViewSearch.delegate == nil)
        {
            [self.tableViewSearch setDelegate:self];
            [self.tableViewSearch setDataSource:self];
        }
        [self.tableViewSearch reloadData];
        if([[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] isKindOfClass:[JTMaterialSpinner class]])
        {
            [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
            
        }

    } failure:^(NSString *errorString) {
        if([[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] isKindOfClass:[JTMaterialSpinner class]])
        {
            [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
            
        }

    }];
}

#pragma mark - 
#pragma mark - Delegate
-(void)del
{
    
}

#pragma mark -
#pragma mark - XlChild

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return NSLocalizedString(@"safety_measures", nil);
}

#pragma mark -
#pragma mark - Table view delegate and datasource function
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.arraySearch.count!=0)
    {
        [self performSegueWithIdentifier:KSafetyDetailSegue sender:[self.arraySearch objectAtIndex:indexPath.row]];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.arraySearch.count==0)
    {
        return 1;
    }
    else
        return self.arraySearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
            if(self.arraySearch.count==0)
        {
            CommunityNoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityNoCell"];
            if(self.loaded)
            {
                [cell.labelNoUsers setText:@"No safety measures found"];
            }
            else
            {
                [cell.labelNoUsers setText:@"Search"];
            }
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

-(void)configureSafetyCell:(SafetyProfileCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SafetyMeasure *modal = [self.arraySearch objectAtIndex:indexPath.row];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if(self.arraySearch.count==0)
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
    }
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
