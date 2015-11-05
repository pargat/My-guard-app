//
//  DemoBringViewController.m
//  MyGuardApp
//
//  Created by vishnu on 26/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "DemoBringViewController.h"

@interface DemoBringViewController ()

@end

@implementation DemoBringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.labelDemoString setText:NSLocalizedString(@"bring_your_phone", nil)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
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
#pragma mark - Button Action
- (IBAction)actionCloseDemo:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionNext:(id)sender {
}
@end
