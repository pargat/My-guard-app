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
    [self fetchAd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.searchBar becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark -
#pragma mark - View Helpers
-(void)fetchAd
{
    [iOSRequest getJsonResponse:[NSString stringWithFormat:KGetAdvertisment,KbaseUrl] success:^(NSDictionary *responseDict) {
        if([responseDict valueForKeyPath:@"data.image"] !=(id)[NSNull null])
        {
            [self.imageViewAd sd_setImageWithURL:[NSURL URLWithString:[responseDict valueForKeyPath:@"data.image"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self setUpAd:responseDict];
                
            }];
        }
    } failure:^(NSString *errorString) {
        
    }];
}
-(void)setUpAd:(NSDictionary *)dict
{
    self.layoutHeightAd.constant = self.view.frame.size.width/5;
    self.dictAd = dict;
}
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
    
    self.searchBar.delegate = self;
    
    [self moveToViewControllerAtIndex:self.currentTab];
    
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
    if(![[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        self.searchFeedVC.stringToSearch = searchBar.text;
        self.searchSafetyVC.stringToSearch = searchBar.text;
        self.searchUserVC.stringToSearch = searchBar.text;
        
        //        if (self.currentIndex==0) {
        //            [self.searchFeedVC apiSearch:searchBar.text];
        //        }
        //        else if (self.currentIndex==1)
        //        {
        //            [self.searchSafetyVC apiSearch:searchBar.text];
        //        }
        //        else
        //        {
        //            [self.searchUserVC apiSearch:searchBar.text];
        //        }
        [self setUpLoaderView];
        [self.searchFeedVC apiSearch:searchBar.text];
        [self.searchUserVC apiSearch:searchBar.text];
        [self.searchSafetyVC apiSearch:searchBar.text];
        
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
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


#pragma mark -
#pragma mark - Button Actions
- (IBAction)actionAdClicked:(id)sender {
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[self.dictAd valueForKeyPath:@"data.link"]]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.dictAd valueForKeyPath:@"data.link"]]];
}
@end
