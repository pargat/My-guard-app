//
//  AdminMessageViewController.m
//  MyGuardApp
//
//  Created by vishnu on 05/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "AdminMessageViewController.h"

@interface AdminMessageViewController ()

@end

@implementation AdminMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarAndTab];
    [self viewHelper];
    [self fetchAdminMessage];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 
#pragma mark - View helpers
-(void)fetchAdminMessage
{
    [self setUpLoaderView];
    [iOSRequest getJsonResponse:[NSString stringWithFormat:KGetMessage,KbaseUrl,[Profile getCurrentProfileUserId],self.messageId] success:^(NSDictionary *responseDict) {
        [self.textViewAdmin setText:[responseDict valueForKey:@"tile"]];
        [self removeLoaderView];
    } failure:^(NSString *errorString) {
        [self removeLoaderView];
    }];
}
-(void)setNavBarAndTab
{
    [self.tabBarController.tabBar setTintColor:KOrangeColor];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    [navigationBar setBackgroundColor:KOrangeColor];
    
    [navigationBar setBarTintColor:KPurpleColorNav];
    [navigationBar setBarStyle:UIBarStyleBlack];
    [navigationBar setTranslucent:NO];
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [navigationBar setShadowImage:[UIImage new]];
    [self.navigationItem setTitle:NSLocalizedString(@"admin", nil)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    
}
-(void)viewHelper
{
    [self.textViewAdmin setText:self.messageString];
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
