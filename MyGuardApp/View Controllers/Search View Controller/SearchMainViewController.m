//
//  SearchMainViewController.m
//  MyGuardApp
//
//  Created by vishnu on 31/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SearchMainViewController.h"

@interface SearchMainViewController ()

@end

@implementation SearchMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self viewHelper];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - View Helpers
-(void)viewHelper
{
    self.isProgressiveIndicator = YES;
    self.isElasticIndicatorLimit = NO;
    [self.buttonBarView.selectedBar setBackgroundColor:KPurpleColor];
    [self.buttonBarView setSelectedBarHeight:3];
    [self.buttonBarView setLabelFont:[UIFont boldSystemFontOfSize:13]];
    

    UIBezierPath *shadowPath  = [UIBezierPath bezierPathWithRect:self.buttonBarView.bounds];
    self.buttonBarView.layer.masksToBounds = NO;
    self.buttonBarView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.buttonBarView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.buttonBarView.layer.shadowOpacity = 0.75f;
    self.buttonBarView.layer.shadowPath = shadowPath.CGPath;

}
-(void)initialiseVCs
{
    self.searchFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:KSearchFeedVC];
    self.searchSafetyVC = [self.storyboard instantiateViewControllerWithIdentifier:KSearchSafetyVC];
    self.searchUserVC = [self.storyboard instantiateViewControllerWithIdentifier:KSearchUserVC];

}
#pragma mark -
#pragma mark - XLPagerDatasourec
-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    [self initialiseVCs];
    return @[self.searchFeedVC,self.searchSafetyVC,self.searchUserVC];
}

#pragma mark - 
#pragma mark - Search bar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.delegate delSearch];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
