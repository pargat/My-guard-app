//
//  CommunityViewController.m
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "CommunityViewController.h"

@interface CommunityViewController ()

@end

@implementation CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isProgressiveIndicator = YES;
    self.isElasticIndicatorLimit = NO;
    [self.buttonBarView.selectedBar setBackgroundColor:[UIColor whiteColor]];
    [self.buttonBarView setSelectedBarHeight:3];
    
    
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBarAndTab];
}


#pragma mark -
#pragma mark - View helpers
-(void)initialiseVCs
{
    self.community1 = [self.storyboard instantiateViewControllerWithIdentifier:KCommunityContent];
    self.community1.currentTab = NEIGHBOUR;
    self.community2 = [self.storyboard instantiateViewControllerWithIdentifier:KCommunityContent];
    self.community2.currentTab = FAMILY;
    self.community3 = [self.storyboard instantiateViewControllerWithIdentifier:KCommunityContent];
    self.community3.currentTab = FRIENDS;
    self.community4 = [self.storyboard instantiateViewControllerWithIdentifier:KCommunityContent];
    self.community4.currentTab = SEARCH;
}


-(void)setNavBarAndTab
{
    [self.tabBarController.tabBar setTintColor:KPurpleColor];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBarTintColor:KPurpleColorNav];
    [navigationBar setBarStyle:UIBarStyleBlack];
    [navigationBar setTranslucent:NO];
    
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [navigationBar setShadowImage:[UIImage new]];
    [self.navigationItem setTitle:NSLocalizedString(@"community", nil)];

    
    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_search"] style:UIBarButtonItemStylePlain target:self action:@selector(actionSearch)];
    [btnSearch setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = btnSearch;

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *tmpdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://api.firesonar.com/FireSonar/timthumb.php?src=uploads/iSf0mKHUG5vgEt2pncuW.jpeg"]];
        UIImage *image = [UIImage imageWithData:tmpdata];
        image = [image circularScaleAndCropImage:CGRectMake(0, 0, 32, 32)];
        image = [image imageByScalingAndCroppingForSize:CGSizeMake(32, 32)];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIButton *btnProfileA = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
            [btnProfileA setImage:image forState:UIControlStateNormal];
            [btnProfileA addTarget:self action:@selector(actionProfile) forControlEvents:UIControlEventTouchUpInside];
            btnProfileA.layer.cornerRadius = btnProfileA.frame.size.width/2;
            btnProfileA.layer.borderColor = [[UIColor whiteColor] CGColor];
            btnProfileA.layer.borderWidth = 1.0;
            
            
            UIBarButtonItem *btnProfile = [[UIBarButtonItem alloc] initWithCustomView:btnProfileA];
            [btnProfile setTintColor:[UIColor whiteColor]];
            self.navigationItem.leftBarButtonItem = btnProfile;
        });
        
    });


}


#pragma mark -
#pragma mark - Search bar delegate
-(void)actionSearch
{
    UISearchBar  *sBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10,10,self.navigationController.navigationBar.bounds.size.width-20,self.navigationController.navigationBar.bounds.size.height/2)];
    sBar.showsCancelButton = YES;
    sBar.delegate = self;
    [sBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar addSubview:sBar];
    self.navigationItem.rightBarButtonItem = nil;
    [sBar becomeFirstResponder];
    
}

#pragma mark -
#pragma mark - XLPagerDatasourec
-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    [self initialiseVCs];
    return @[self.community1,self.community2,self.community3,self.community4];
}

-(void)actionProfile
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
