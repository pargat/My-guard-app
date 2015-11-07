//
//  DemoHushViewController.m
//  MyGuardApp
//
//  Created by vishnu on 06/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "DemoHushViewController.h"

@interface DemoHushViewController ()

@end

@implementation DemoHushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startOverlayAnimation];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - 
#pragma mark - View Helpers

-(void)startOverlayAnimation
{
    NSArray *animationArray=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"alarm_ringing_01.png"],
                             [UIImage imageNamed:@"alarm_ringing_02.png"],
                             [UIImage imageNamed:@"alarm_ringing_03.png"],
                             nil];
    self.imageViewAnim.animationImages=animationArray;
    self.imageViewAnim.animationDuration=0.16;
    self.imageViewAnim.animationRepeatCount=0;
    [self.imageViewAnim startAnimating];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionHush:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-3] animated:YES];
    [self.navigationController.navigationBar setHidden:NO];
}
@end
