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
    
    
        Profile *profile = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    if([profile.profileCOBuy isEqualToString:@"1"])
    {
        [self.viewInpp setHidden:YES];
        [self addNavbuttons:NO purchased:YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchased:) name:@"in_app" object:nil];
        [self addNavbuttons:NO purchased:YES];
    }
    [self setInAppThing];
//    if([[NSUserDefaults standardUserDefaults] valueForKey:@"pushInfo"]!=nil)
//        [self performActionForPush];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.badgeC removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"in_app" object:nil];
    [self removeLoaderView];

    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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
        btnProfile.customView.clipsToBounds = YES;
        self.navigationItem.leftBarButtonItem = btnProfile;
        [self badge];
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
                btnProfile.customView.clipsToBounds = YES;
                self.navigationItem.leftBarButtonItem = btnProfile;

                [self badge];
            });
            
        });
    }
    
    
    
}

-(void)badge
{
    [self.badgeC removeFromSuperview];
    
    Profile *modal = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    if([modal.profileUnreadCount integerValue]>0)
    {
        self.badgeC = [CustomBadge customBadgeWithString:modal.profileUnreadCount];
        [self.badgeC setBadgeText:modal.profileUnreadCount];
        [self.badgeC setFrame:CGRectMake(35, 16, 28, 28)];
        //    [self.navigationController.navigationBar addSubview:self.badgeC];
        //    [self.badgeC bringSubviewToFront:self.navigationController.navigationBar];
        UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
        [currentWindow addSubview:self.badgeC];
    }
}

//-(void)addNavbuttons:(BOOL)shouldShowSafety
//{
//    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_search"] style:UIBarButtonItemStylePlain target:self action:@selector(actionSearch)];
//    [btnSearch setTintColor:[UIColor whiteColor]];
//    
//    if(shouldShowSafety)
//    {
//        UIBarButtonItem *btnAddSafetyMeasure = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_add_safety"] style:UIBarButtonItemStylePlain target:self action:@selector(actionAddSafety)];
//        [btnAddSafetyMeasure setTintColor:[UIColor whiteColor]];
//        self.navigationItem.rightBarButtonItems = @[btnSearch,btnAddSafetyMeasure];
//    }
//    else
//    {
//        self.navigationItem.rightBarButtonItems = nil;
//        self.navigationItem.rightBarButtonItem = btnSearch;
//    }
//}
-(void)addNavbuttons:(BOOL)shouldShowSafety purchased:(BOOL)purchased
{
    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_search"] style:UIBarButtonItemStylePlain target:self action:@selector(actionSearch)];
    [btnSearch setTintColor:[UIColor whiteColor]];
    
    if(shouldShowSafety)
    {
        if(purchased)
        {
            UIBarButtonItem *btnAddSafetyMeasure = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_add_safety"] style:UIBarButtonItemStylePlain target:self action:@selector(actionAddSafety)];
            [btnAddSafetyMeasure setTintColor:[UIColor whiteColor]];
            self.navigationItem.rightBarButtonItems = @[btnSearch,btnAddSafetyMeasure];
        }
        else
        {
            UIBarButtonItem *btnAddSafetyMeasure = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_add_safety"] style:UIBarButtonItemStylePlain target:self action:@selector(actionAddSafety)];
            [btnAddSafetyMeasure setTintColor:[UIColor whiteColor]];
            self.navigationItem.rightBarButtonItems =nil;
            self.navigationItem.rightBarButtonItem = btnAddSafetyMeasure;
        }
        
    }
    else
    {
        if(purchased)
        {
            
            self.navigationItem.rightBarButtonItems = nil;
            self.navigationItem.rightBarButtonItem = btnSearch;
        }
        else
        {        self.navigationItem.rightBarButtonItems = nil;
            self.navigationItem.rightBarButtonItem = nil;
            
            
        }
    }
}

#pragma mark -
#pragma mark - Main Content Delegate
-(void)delChangeNavButton:(BOOL)showOptional
{
    Profile *profile = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    
    if([profile.profileCOBuy isEqualToString:@"1"])
    {
        
        [self addNavbuttons:showOptional purchased:YES];
    }
    else
    {
        [self addNavbuttons:showOptional purchased:NO];
        
    }
}
-(void)delNobutton
{
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
}


#pragma mark -
#pragma mark - perform push
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
    else if ([str isEqualToString:@"14"])
    {
        [self performSegueWithIdentifier:KMissingDetailSegue sender:dict];
    }
    
    
}

#pragma mark -
#pragma mark - In app purchase functions
-(void)setInAppThing
{
    self.btnBuy.layer.cornerRadius = 8.0;
    self.btnBuy.clipsToBounds = YES;
    
    [self.labelPremium setText:NSLocalizedString(@"sex_premium", nil)];
    [self.labelPrimiumDes setText:NSLocalizedString(@"sex_description", nil)];
    [self.btnBuy setTitle:[NSString stringWithFormat:@"%@ (%@)",NSLocalizedString(@"sex_activate", nil),@"$1.99/yr"] forState:UIControlStateNormal];
    [self fetchInAppPurchases];
}

-(void)purchased:(NSNotification *)n
{
    if([n.object isEqualToString:INAPP_CO_ID])
    {
        [self removeLoaderView];
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"co_in"];
        [self.viewInpp setHidden:YES];
        [self addNavbuttons:NO purchased:YES];
    }
    else
    {
        [self removeLoaderView];
        
    }
}


- (void)fetchInAppPurchases {
    [[MyGuardInAppHelper sharedInstance] requestProductWithCompletionHandler:^(BOOL success, NSArray *products) {
        
        
        if (success) {
            //sort products according to price
            //            NSSortDescriptor *lowestPriceToHighest = [NSSortDescriptor sortDescriptorWithKey:@"price" ascending:YES];
            //            NSArray *sortedProducts = [products sortedArrayUsingDescriptors:[NSArray arrayWithObject:lowestPriceToHighest]];
            self.arrayInApp = [NSArray arrayWithArray:products];
            
        }
        else {
        }
        
    }];
}
-(void)fetchAndPurchase
{
    [[MyGuardInAppHelper sharedInstance] requestProductWithCompletionHandler:^(BOOL success, NSArray *products) {
        
        
        if (success) {
            //sort products according to price
            //            NSSortDescriptor *lowestPriceToHighest = [NSSortDescriptor sortDescriptorWithKey:@"price" ascending:YES];
            //            NSArray *sortedProducts = [products sortedArrayUsingDescriptors:[NSArray arrayWithObject:lowestPriceToHighest]];
            self.arrayInApp = [NSArray arrayWithArray:products];
            [self actionBuy:nil];
        }
        else {
        }
        
    }];
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
        addSafetyVC.currentTab = CO;
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
    else if ([segue.identifier isEqualToString:KMissingDetailSegue])
    {
        MissingPersonViewController *missingVC = (MissingPersonViewController *)segue.destinationViewController;
        missingVC.missingId = [sender valueForKey:@"id"];
    }


}


- (IBAction)actionBuy:(id)sender {
    [self setUpLoaderView:KGreenColor];
    for (SKProduct *product in self.arrayInApp) {
        if([product.productIdentifier isEqualToString:INAPP_CO_ID])
        {
            [[MyGuardInAppHelper sharedInstance] buy_Product:product];
            break;
        }
    }
    if(self.arrayInApp.count == 0)
    {
        [self fetchAndPurchase];
    }
    
}


@end
