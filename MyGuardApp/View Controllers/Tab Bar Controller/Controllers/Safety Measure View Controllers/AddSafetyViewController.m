//
//  AddSafetyViewController.m
//  MyGuardApp
//
//  Created by vishnu on 07/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "AddSafetyViewController.h"

@interface AddSafetyViewController ()

@end

@implementation AddSafetyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self loader];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loader
{
    
}
- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}
-(void)setNavBar
{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if(self.currentTab==FIRE)
    {
        [self.navigationController.navigationBar setBarTintColor:KOrangeColor];
    }
    else if (self.currentTab==GUN)
    {
        [self.navigationController.navigationBar setBarTintColor:KRedColor];
    }
    else
    {
        [self.navigationController.navigationBar setBarTintColor:KGreenColor];
    }
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - 
#pragma mark - Button Actions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionType:(UIButton *)sender {
    
    if(sender.tag==0)
    {
        [self.navigationController.navigationBar setBarTintColor:KOrangeColor];
    }
    else if (sender.tag==1)
    {
        [self.navigationController.navigationBar setBarTintColor:KRedColor];
    }
    else
    {
        [self.navigationController.navigationBar setBarTintColor:KGreenColor];
    }
}

@end
