//
//  UserGuideViewController.m
//  MyGuardApp
//
//  Created by vishnu on 05/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "UserGuideViewController.h"

@interface UserGuideViewController ()

@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *stringH = NSLocalizedString(@"users_guide_text", nil);
    [self.webViewMain loadHTMLString:stringH baseURL:nil];
    [self setNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavBar
{
    [self.navigationItem setTitle:NSLocalizedString(@"users_guide", nil)];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;


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
