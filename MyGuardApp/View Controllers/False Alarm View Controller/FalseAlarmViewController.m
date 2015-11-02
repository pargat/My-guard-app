//
//  FalseAlarmViewController.m
//  MyGuardApp
//
//  Created by vishnu on 31/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "FalseAlarmViewController.h"

@interface FalseAlarmViewController ()

@end

@implementation FalseAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewHelper];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - View helper functions
-(void)viewHelper
{
    self.imageViewDp.layer.cornerRadius = self.imageViewDp.frame.size.width/2;
    self.imageViewDp.clipsToBounds = YES;
    [self.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:KBaseTimbthumbUrl,[self.dictInfo valueForKey:@"image"],DisplayScale*self.imageViewDp.frame.size.width,DisplayScale*self.imageViewDp.frame.size.height]]];
    [self.labelDescription setText:[self.dictInfo valueForKey:@"message"]];
    [self.labelUserName setText:[self.dictInfo valueForKey:@"username"]];

}
-(void)setUpNavBar
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
