//
//  SafetyDetailViewController.m
//  MyGuardApp
//
//  Created by vishnu on 20/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SafetyDetailViewController.h"

@interface SafetyDetailViewController ()

@end

@implementation SafetyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBAr];
    [self viewHelper];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeLoaderView];
}

#pragma mark - 
#pragma mark - View Helpers
-(void)viewHelper
{
    [self.textViewDescription setText:@""];
    if(self.stringId.length>0)
    {
        [self apiHit];
    }
    else
    {
        [self.textViewDescription setText:self.stringSafety];

    }
}
-(void)apiHit
{
    [self setUpLoaderView];
    [iOSRequest getJsonResponse:[NSString stringWithFormat:KViewSafetyMeasure,KbaseUrl,self.stringId] success:^(NSDictionary *responseDict) {
        self.safetyModal = [[SafetyMeasure alloc] initWithAttributes:[responseDict valueForKey:@"data"]];
        [self.textViewDescription setText:self.safetyModal.safetyDescription];
        [self removeLoaderView];
    } failure:^(NSString *errorString) {
        [self removeLoaderView];
    }];
}
- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

-(void)setUpNavBAr
{
    NSString *title;
    if([self.currentTab isEqualToString:@"1"])
    {
        title = @"Safety measure for fire";

    }
    else if([self.currentTab isEqualToString:@"2"])
    {
        title = @"Safety measure for co";

    }
    else if ([self.currentTab isEqualToString:@"3"])
    {
        title = @"Safety measure for gun";
   
    }
    [self.navigationItem setTitle:title];
    
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
