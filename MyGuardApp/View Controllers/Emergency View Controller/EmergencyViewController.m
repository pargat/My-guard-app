//
//  EmergencyViewController.m
//  MyGuardApp
//
//  Created by vishnu on 13/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "EmergencyViewController.h"

@interface EmergencyViewController ()

@end

@implementation EmergencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self viewHelper];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Helpers
-(void)setNavBar
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBarTintColor:KPurpleColorNav];
    [navigationBar setBarStyle:UIBarStyleBlack];
    [navigationBar setTranslucent:NO];

    [self.navigationItem setTitle:NSLocalizedString(@"emergency_screen_title", nil)];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    
}
-(void)viewHelper
{
    [self.tableViewEmergency setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark -
#pragma mark - Table View Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayEmergencyContacts.count+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        EmergencyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"EmergencyCell1"];
        return cell;
    }
    else if (indexPath.row==1)
    {
        EmergencyCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"EmergencyCell2"];
        return cell;
    }
    else
    {
        EmergencyCellContact *cell = [tableView dequeueReusableCellWithIdentifier:@"EmergencyCellContact"];
        return cell;
    }
}

-(void)configureCellEmergency:(EmergencyCellContact *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark -
#pragma mark - Button Actions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
