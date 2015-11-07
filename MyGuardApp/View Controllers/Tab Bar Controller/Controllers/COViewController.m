//
//  COViewController.m
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "COViewController.h"

@interface COViewController ()

@end

@implementation COViewController

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

-(void)setNavBarAndTab
{
    [self.tabBarController.tabBar setTintColor:KGreenColor];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBarTintColor:KGreenColor];
    [navigationBar setBarStyle:UIBarStyleBlack];
    [navigationBar setTranslucent:NO];
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [navigationBar setShadowImage:[UIImage new]];
    [self.navigationItem setTitle:NSLocalizedString(@"tb_co", nil)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    LOcationUpdater *locationUpdater = [LOcationUpdater sharedManager];
    if(locationUpdater.imageDp!=nil)
    {
        UIButton *btnProfileA = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [btnProfileA setImage:locationUpdater.imageDp forState:UIControlStateNormal];
        [btnProfileA addTarget:self action:@selector(actionProfile) forControlEvents:UIControlEventTouchUpInside];
        btnProfileA.layer.cornerRadius = btnProfileA.frame.size.width/2;
        btnProfileA.layer.borderColor = [[UIColor whiteColor] CGColor];
        btnProfileA.layer.borderWidth = 1.0;
        
        
        UIBarButtonItem *btnProfile = [[UIBarButtonItem alloc] initWithCustomView:btnProfileA];
        [btnProfile setTintColor:[UIColor whiteColor]];
        self.navigationItem.leftBarButtonItem = btnProfile;
        
    }
    else
    {
        Profile *modal = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSData *tmpdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:modal.profileImageFullLink]];
            
            UIImage *image = [UIImage imageWithData:tmpdata];
            image = [image circularScaleAndCropImage:CGRectMake(0, 0, image.size.width, image.size.width)];
            image = [image imageByScalingAndCroppingForSize:CGSizeMake(image.size.width, image.size.width)];
            locationUpdater.imageDp = image;
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
    
    
    [self addNavbuttons:NO];
    
}
-(void)addNavbuttons:(BOOL)shouldShowSafety
{
    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_search"] style:UIBarButtonItemStylePlain target:self action:@selector(actionSearch)];
    [btnSearch setTintColor:[UIColor whiteColor]];
    
    if(shouldShowSafety)
    {
        UIBarButtonItem *btnAddSafetyMeasure = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_add_safety"] style:UIBarButtonItemStylePlain target:self action:@selector(actionAddSafety)];
        [btnAddSafetyMeasure setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItems = @[btnSearch,btnAddSafetyMeasure];
    }
    else
    {
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.rightBarButtonItem = btnSearch;
    }
}

#pragma mark -
#pragma mark - Main Content Delegate
-(void)delChangeNavButton:(BOOL)showOptional
{
    [self addNavbuttons:showOptional];
}
-(void)delNobutton
{
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
}


#pragma mark -
#pragma mark - Helpers
-(void)viewHelper
{
    self.mainVC = (MainContentViewController *)[self.storyboard instantiateViewControllerWithIdentifier:KMainVC];
    self.mainVC.currentTab = CO;
    self.mainVC.delegate1 = self;
    [self.mainVC.view setFrame:self.viewContainer.bounds];
    [self.viewContainer addSubview:self.mainVC.view];
    [self addChildViewController:self.mainVC];
    [self.mainVC didMoveToParentViewController:self];
    
}
#pragma mark -
#pragma mark - Button Actions
-(void)actionAddSafety
{
    [self performSegueWithIdentifier:KAddSafetySegue sender:self];

}

-(void)actionSearch
{
    [self performSegueWithIdentifier:KSearchMainSegue sender:self];
}

-(void)actionProfile
{
    [self performSegueWithIdentifier:KMyProfileSegue sender:nil];

}

#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:KAddSafetySegue])
    {
        AddSafetyViewController *addSafetyVC = (AddSafetyViewController *)segue.destinationViewController;
        addSafetyVC.currentTab = FIRE;
    }
    else     if([segue.identifier isEqualToString:KSearchMainSegue])
    {
        SearchMainViewController *searchVc= (SearchMainViewController *)segue.destinationViewController;
        if(self.mainVC.currentIndex==1)
        {
            searchVc.currentTab = 1;

        }
        else
        {
            searchVc.currentTab = 0;
        }
    }

}


@end
