//
//  MissingCommunityViewController.m
//  MyGuardApp
//
//  Created by vishnu on 13/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import "MissingCommunityViewController.h"

@interface MissingCommunityViewController ()

@end

@implementation MissingCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getMissingPeople];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Helper functions
-(void)getMissingPeople
{
    
    Profile *profile = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    LOcationUpdater *loc = [LOcationUpdater sharedManager];

    [MissingModal callAPIForMissing:[NSString stringWithFormat:KListMissing,KbaseUrl,profile.profileUserId,loc.currentLoc.coordinate.latitude,loc.currentLoc.coordinate.longitude,0] Params:nil success:^(NSMutableArray *offenderArr) {
        self.arrayMissing = offenderArr;
        [self.tableViewMissing reloadData];
    } failure:^(NSString *errorStr) {
        
    }];
}

#pragma mark -
#pragma mark - XlChild

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    
    return NSLocalizedString(@"missing_people", nil);
        
}

#pragma mark -
#pragma mark - Table View Datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
        static MissingCommunityCell *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"MissingCommunityCell"];
        });
        
        [self configureMissingCell:sizingCell atIndexPath:indexPath];
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
  }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMissing.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        MissingCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissingCommunityCell"];
        
        [self configureMissingCell:cell atIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        return cell;
}

#pragma mark -
#pragma mark - Table view helpers
-(void)configureMissingCell:(MissingCommunityCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    MissingModal *modal = [self.arrayMissing objectAtIndex:indexPath.row];
    [cell.labelLast setText:modal.missingLocation];
    [cell.labelMissingSince setText:modal.missingDate];
    [cell.labelDescription setText:modal.missingDescription];
    [cell.labelName setText:modal.missingName];
    [cell.imageViewPerson sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:modal.missingImage]]];
    
    
}

@end
