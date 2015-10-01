//
//  GunViewController.m
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "GunViewController.h"

@interface GunViewController ()

@end

@implementation GunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewHelper];

    // Do any additional setup after loading the view.
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
#pragma mark - Helpers
-(void)viewHelper
{
    self.mainVC = (MainContentViewController *)[self.storyboard instantiateViewControllerWithIdentifier:KMainVC];
    self.mainVC.currentTab = GUN;
    [self.mainVC.view setFrame:self.viewContainer.bounds];
    [self.viewContainer addSubview:self.mainVC.view];
    [self addChildViewController:self.mainVC];
    [self.mainVC didMoveToParentViewController:self];
    
    
    
}

-(void)setNavBarAndTab
{
    [self.tabBarController.tabBar setTintColor:KRedColor];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBarTintColor:KRedColor];
    [navigationBar setBarStyle:UIBarStyleBlack];
    [navigationBar setTranslucent:NO];
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [navigationBar setShadowImage:[UIImage new]];
    [self.navigationItem setTitle:NSLocalizedString(@"gunshot", nil)];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
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
#pragma mark - Button Actions
-(void)actionSearch
{
    
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
