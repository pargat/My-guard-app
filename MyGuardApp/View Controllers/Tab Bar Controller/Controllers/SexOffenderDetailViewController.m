//
//  SexOffenderDetailViewController.m
//  MyGuardApp
//
//  Created by vishnu on 12/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SexOffenderDetailViewController.h"

@interface SexOffenderDetailViewController ()

@end

@implementation SexOffenderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self viewHelper];
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

-(void)viewHelper
{
    [self.navigationItem setTitle:NSLocalizedString(@"sex_offender_title", nil)];
    self.arrayTitle =[ @[@"DOB",@"AGE",@"SEX",@"RACE",@"HAIR",@"EYES",@"HEIGHT",@"WEIGHT",@"ADDRESS"] mutableCopy];
    [self.imageViewPic sd_setImageWithURL:[NSURL URLWithString:self.sexOffenderModal.offenderPhoto]];
    [self.labelFullName setText:self.sexOffenderModal.offenderName];
    [self.labelId setText:self.sexOffenderModal.offenderId];
    
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    

}

#pragma mark -
#pragma mark - Table View Datasource and delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static SexOffenderDetailCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableViewOffender dequeueReusableCellWithIdentifier:@"SexOffenderDetailCell"];
    });
    
    [self configureCell:sizingCell atIndexPath:indexPath];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        SexOffenderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SexOffenderDetailCell"];
        [self configureCell:cell atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
}

-(void)configureCell:(SexOffenderDetailCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell.labelTitlw setText:[self.arrayTitle objectAtIndex:indexPath.row]];
    switch (indexPath.row) {
        case 0:
            [cell.labelDescription setText:self.sexOffenderModal.offenderDob];
            break;
        case 1:
            [cell.labelDescription setText:self.sexOffenderModal.offenderAge];
            break;
        case 2:
            [cell.labelDescription setText:self.sexOffenderModal.offenderSex];
            break;
        case 3:
            [cell.labelDescription setText:self.sexOffenderModal.offenderRace];
            break;
        case 4:
            [cell.labelDescription setText:self.sexOffenderModal.offenderHair];
            break;
        case 5:
            [cell.labelDescription setText:self.sexOffenderModal.offenderEye];
            break;
        case 6:
            [cell.labelDescription setText:self.sexOffenderModal.offenderHeight];
            break;
        case 7:
            [cell.labelDescription setText:self.sexOffenderModal.offenderWeight];
            break;
        case 8:
            [cell.labelDescription setText:self.sexOffenderModal.offenderAddress];
            break;
        default:
            break;
            
    }

}

#pragma mark -
#pragma mark - Buton Actions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
