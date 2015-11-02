//
//  SearchSafetyViewController.m
//  MyGuardApp
//
//  Created by vishnu on 02/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SearchSafetyViewController.h"

@interface SearchSafetyViewController ()

@end

@implementation SearchSafetyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark -  View helpers
-(void)apiSearch
{
    SearchMainViewController *searchMain = (SearchMainViewController *)self.parentViewController;
    NSString * stringSearchSafety = [NSString stringWithFormat:KSearchNewApi,KbaseUrl,[Profile getCurrentProfileUserId],searchMain.searchBar.text,@"2"];
    
    [iOSRequest getJsonResponse:stringSearchSafety success:^(NSDictionary *responseDict) {
        
    } failure:^(NSString *errorString) {
        
    }];
}

#pragma mark - 
#pragma mark - Delegate
-(void)del

#pragma mark -
#pragma mark - XlChild

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return NSLocalizedString(@"safety_measures", nil);
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
