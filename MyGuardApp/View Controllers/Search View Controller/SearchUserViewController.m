//
//  SearchUserViewController.m
//  MyGuardApp
//
//  Created by vishnu on 02/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SearchUserViewController.h"

@interface SearchUserViewController ()

@end

@implementation SearchUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewHelper];
    // Do any additional setup after loading the view.
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
    
}

-(void)apiSearch:(NSString *)str
{
    NSString * stringSearchSafety = [NSString stringWithFormat:KSearchNewApi,KbaseUrl,[Profile getCurrentProfileUserId],str,@"3"];
    
    [iOSRequest getJsonResponse:stringSearchSafety success:^(NSDictionary *responseDict) {
        self.arraySearch = [User parseDictToModal:[responseDict valueForKey:@"data"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        if(self.tableViewSearch.delegate == nil)
        {
            [self.tableViewSearch setDelegate:self];
            [self.tableViewSearch setDataSource:self];
        }
        });


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
#pragma mark - XlChild

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return NSLocalizedString(@"user_search", nil);
}


#pragma mark -
#pragma mark - Table View Delegate and datasource function

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(self.arraySearch.count==0)
        return 1;
    else
    {
        return self.arraySearch.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.arraySearch.count==0)
    {
        CommunityNoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityNoCell"];
        if(self.loaded)
        {
            [cell.labelNoUsers setText:@"No users found"];
        }
        else
        {
            [cell.labelNoUsers setText:@"Search"];
        }
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    if(self.arraySearch.count==0)
    {
        
        static CommunityNoCell *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [self.tableViewSearch dequeueReusableCellWithIdentifier:@"CommunityNoCell"];
        });
        
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    }
    else
    {
        static CommunityCell *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [self.tableViewSearch dequeueReusableCellWithIdentifier:@"CommunityCell"];
        });
        
        [self configureCell:sizingCell atIndexPath:indexPath];
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    }
    
}

-(void)configureCell:(CommunityCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    User *tempuser= [self.arraySearch objectAtIndex:indexPath.row];
    
    
    
    [cell.labelDistance setText:@""];
    [cell.labelName setText:tempuser.userUserName];
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&w=%f&h=%f",tempuser.userImageName,cell.imageViewDp.frame.size.width*DisplayScale,cell.imageViewDp.frame.size.height*DisplayScale]]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.arraySearch.count!=0)
        [self performSegueWithIdentifier:KOtherProfileSegue sender:[self.arraySearch objectAtIndex:indexPath.row]];
    
}

#pragma mark -
#pragma mark - Navigation related
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    User *modal = (User *)sender;
    
    OtherProfileViewController *otherVC = (OtherProfileViewController *)segue.destinationViewController;
    otherVC.stringUserId = modal.userUserId;
    otherVC.stringUsername = modal.userUserName;
}

@end
