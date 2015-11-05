//
//  DemoDetectViewController.m
//  MyGuardApp
//
//  Created by vishnu on 26/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "DemoDetectViewController.h"

@interface DemoDetectViewController ()

@end

@implementation DemoDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self viewHelper];
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

#pragma mark - 
#pragma mark - View Helper
-(void)viewHelper
{
    [self.labrlTitle setText:NSLocalizedString(@"detect_alarm_title", nil)];
    [self.labelDescription setText:NSLocalizedString(@"detect_alarm_description", nil)];
}

#pragma mark -
#pragma mark- button actions

- (IBAction)actionClickHer:(id)sender {
}

- (IBAction)actionCloseDemo:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-3] animated:YES];
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
