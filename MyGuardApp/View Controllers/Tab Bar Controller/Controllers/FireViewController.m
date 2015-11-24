//
//  FireViewController.m
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "FireViewController.h"

@interface FireViewController ()

@end

@implementation FireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewHelper];
    [self showUseGuide];
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
-(void)showUseGuide
{
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"FirstGuide"]==nil)
    {
        [self performSegueWithIdentifier:KUserGuideSegue sender:self];
        [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"FirstGuide"];
    }
}
-(void)setNavBarAndTab
{
    [self.tabBarController.tabBar setTintColor:KOrangeColor];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    [navigationBar setBackgroundColor:KOrangeColor];
    
    [navigationBar setBarTintColor:KOrangeColor];
    [navigationBar setBarStyle:UIBarStyleBlack];
    [navigationBar setTranslucent:NO];
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [navigationBar setShadowImage:[UIImage new]];
    [self.navigationItem setTitle:NSLocalizedString(@"fire", nil)];
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
-(void)viewHelper
{
    self.mainVC = (MainContentViewController *)[self.storyboard instantiateViewControllerWithIdentifier:KMainVC];
    self.mainVC.currentTab = FIRE;
    self.mainVC.delegate1 = self;
    [self.mainVC.view setFrame:self.viewContainer.bounds];
    [self.viewContainer addSubview:self.mainVC.view];
    [self addChildViewController:self.mainVC];
    [self.mainVC didMoveToParentViewController:self];
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"pushInfo"]!=nil)
        [self performActionForPush];

//    self.transition = [[ZoomInteractiveTransition alloc] initWithNavigationController:self.navigationController];
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
#pragma mark - Push Handling
-(void)performActionForPush
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKeyPath:@"pushInfo.C"];
    NSString *str = [dict valueForKey:@"type"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"pushInfo"];
    
    if([str isEqualToString:@"1"])
    {
        [self performSegueWithIdentifier:KMapFeedSegue sender:dict];
    }
    else if([str isEqualToString:@"2"])
    {
        [self performSegueWithIdentifier:KFalseAlarmSegue sender:dict];
    }
    else if([str isEqualToString:@"6"]||[str isEqualToString:@"7"]||[str isEqualToString:@"8"]||[str isEqualToString:@"9"])
    {
        [self performSegueWithIdentifier:KOtherProfileSegue sender:dict];
    }
    else if ([str isEqualToString:@"10"])
    {
        [self performSegueWithIdentifier:KSafetyDetailSegue sender:dict];
    }
    else if([str isEqualToString:@"11"])
    {
        [self performSegueWithIdentifier:KImageVideoDetailSegue sender:dict];
    }
    else if ([str isEqualToString:@"13"])
    {
        NSMutableDictionary *dictPush = [NSMutableDictionary dictionaryWithDictionary:dict];
        [dictPush setObject:@"Yes" forKey:@"Comment"];
        [self performSegueWithIdentifier:KImageVideoDetailSegue sender:dictPush];
    }
    else if ([str isEqualToString:@"5"])
    {
        [self performSegueWithIdentifier:KAdminSegue sender:dict];
    }
}


#pragma mark - ZoomTransitionProtocol

-(UIView *)viewForZoomTransition:(BOOL)isSource
{
    UIBarButtonItem *btn = [self.navigationItem.leftBarButtonItems firstObject];
    UIButton *btn1 = btn.customView;
    return btn1;
}





 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {
     
     if([segue.identifier isEqualToString:KAddSafetySegue])
     {
         AddSafetyViewController *addSafetyVC = (AddSafetyViewController *)segue.destinationViewController;
         addSafetyVC.currentTab = FIRE;
     }
     else if([segue.identifier isEqualToString:KOtherProfileSegue])
     {
         OtherProfileViewController *otherVc = (OtherProfileViewController *)segue.destinationViewController;
         otherVc.stringUserId = [sender valueForKey:@"id"];
     }
     else if([segue.identifier isEqualToString:KSafetyDetailSegue])
     {
         SafetyDetailViewController *safetyDetailVC = (SafetyDetailViewController *)segue.destinationViewController;
         safetyDetailVC.stringId = [sender valueForKey:@"id"];
     }
     else if ([segue.identifier isEqualToString:KMapFeedSegue])
     {
         MapViewController *mapVC = (MapViewController *)segue.destinationViewController;
         mapVC.dictInfo = sender;
         
     }
     else if ([segue.identifier isEqualToString:KFalseAlarmSegue])
     {
         //FalseAlarmViewController *falseVC = (FalseAlarmViewController *)segue.destinationViewController;
         //falseVC.dictInfo  = sender;
                 [[NSUserDefaults standardUserDefaults] setObject:sender forKey:@"false"];
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
     else if ([segue.identifier isEqualToString:KImageVideoDetailSegue])
     {
         ImageVideoDetailViewController *imageVideoDetailVc = (ImageVideoDetailViewController *)segue.destinationViewController;
         imageVideoDetailVc.stringFeedId = [sender valueForKey:@"id"];
         imageVideoDetailVc.stringPostId = [sender valueForKey:@"mid"];
         if([sender valueForKey:@"Comment"]!=nil)
             imageVideoDetailVc.isCommentShow = YES;
     }
     else if ([segue.identifier isEqualToString:KAdminSegue])
     {
         AdminMessageViewController *adminVC = (AdminMessageViewController *)segue.destinationViewController;
         adminVC.messageId = [sender valueForKey:@"id"];
         adminVC.messageString = [sender valueForKey:@"m"];
     }


 }


@end
