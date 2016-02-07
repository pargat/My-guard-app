//
//  SexOffenderViewController.m
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "SexOffenderViewController.h"
#define RGB(r, g, b)	 [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha : 1]
@interface SexOffenderViewController ()
{
    JTMaterialSpinner *loaderObj ;
}

@end

@implementation SexOffenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arraySexOffender = [[NSMutableArray alloc] init];
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar setDelegate:self];
    [self.searchBar setShowsCancelButton:YES];
    [self.searchBar setTintColor:[UIColor whiteColor]];
    [self refresh];
    self.arraySexOffender = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"sex_list"];
    
    [self.viewContainer setDelegate:self];
    [self.viewContainer setDataSource:self];
    self.viewContainer.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight;
    [self setInAppThing];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{    [super viewWillAppear:animated];

   
    [self refresh];
    [self.tabBarController.tabBar setHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"sex" object:nil];

    [CommonFunctions buySexInApp];

    
    self.layoutLaid = false;
    self.deleteCount = 0;
    [self setNavBarAndTab];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    self.layoutLaid = true;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeLoaderView];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sex" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"in_app" object:nil];
    [self.badgeC removeFromSuperview];
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if(!self.layoutLaid)
    {
        [self.viewContainer reloadCardContainer];
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

-(void)refresh
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"sex_permission"]==false||[[NSUserDefaults standardUserDefaults] valueForKey:@"sex_permission"] == nil)
    {
        [self.viewContainer setHidden:YES];
        [self.viewNoOne setHidden:NO];
        [self.labelCool setText:NSLocalizedString(@"sex_disabled", nil)];
    }
    else if([[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"sex_list"]==nil)
    {
        [self.viewContainer setHidden:YES];
        [self.labelCool setText:NSLocalizedString(@"sex_nearby", nil)];
        [self.viewNoOne setHidden:NO];
    }
    else
    {
        self.arraySexOffender = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"sex_list"];
        [self.viewContainer setHidden:NO];
        [self.viewNoOne setHidden:YES];
    }
    
    [self.viewContainer reloadCardContainer];
    Profile *profile = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    
    if([profile.profileSexBuy isEqualToString:@"1"])
    {
        [self.viewInpp setHidden:YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchased:) name:@"in_app" object:nil];
    }

}




#pragma mark -
#pragma mark - In app purchase functions
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

-(void)setInAppThing
{
    self.btnBuy.layer.cornerRadius = 8.0;
    self.btnBuy.clipsToBounds = YES;
    
    [self.labelPremium setText:NSLocalizedString(@"sex_premium", nil)];
    [self.labelPrimiumDes setText:NSLocalizedString(@"sex_description", nil)];
    [self.btnBuy setTitle:[NSString stringWithFormat:@"%@ (%@)",NSLocalizedString(@"sex_activate", nil),@"$4.99/yr"] forState:UIControlStateNormal];
    [self fetchInAppPurchases];
}

-(void)purchased:(NSNotification *)n
{
    if([n.object isEqualToString:INAPP_SEX_ID])
    {
        [self removeLoaderView];
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"sex_in"];
        [self.viewInpp setHidden:YES];
        [self refresh];
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


#pragma mark -
#pragma mark - Helper functions
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
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [navigationBar setShadowImage:[UIImage new]];
    [self.navigationItem setTitle:NSLocalizedString(@"tb_sex_offenders", nil)];
    
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
    
//    if([[NSUserDefaults standardUserDefaults] valueForKey:@"purchased"]!=nil)
//    {
//        UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_search"] style:UIBarButtonItemStylePlain target:self action:@selector(actionSearch)];
//        [btnSearch setTintColor:[UIColor whiteColor]];
//        self.navigationItem.rightBarButtonItem = btnSearch;
  //  }
    
    self.navigationItem.titleView = nil;
    
}
-(void)setSearchInNavBar
{
    self.navigationItem.title = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [self.navigationItem setTitleView:self.searchBar];
    [self.searchBar becomeFirstResponder];
}


#pragma mark -
#pragma mark - Button Actions
-(void)actionProfile
{
    [self performSegueWithIdentifier:KMyProfileSegue sender:nil];
}

-(void)actionSearch
{
    [self setSearchInNavBar];
}

#pragma mark -
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:KSexOffenderDetailSegue])
    {
        SexOffenderDetailViewController *sexVC = (SexOffenderDetailViewController *)segue.destinationViewController;
        sexVC.sexOffenderModal = self.sexOffenderModal;
    }
    
    
}



- (IBAction)actionBuy:(id)sender {
    [self setUpLoaderView];
    for (SKProduct *product in self.arrayInApp) {
        if([product.productIdentifier isEqualToString:INAPP_SEX_ID])
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



#pragma mark -- YSLDraggableCardContainer DataSource
- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index
{
    SexOffender *modal = [self.arraySexOffender objectAtIndex:index];
    CardView *view = [[CardView alloc]init];
    [view setFrame:CGRectMake(32, 32, self.viewContainer.frame.size.width-64, self.viewContainer.frame.size.height-80)];
    [view setNeedsLayout];
    [view layoutIfNeeded];
    //[view setFrame:self.viewContainer.frame];
    view.backgroundColor = [UIColor whiteColor];
    [view.imageViewSex sd_setImageWithURL:[NSURL URLWithString:modal.offenderPhoto]];

    view.labelName.text = modal.offenderName;
    [view.labelGenderAge setText:[NSString stringWithFormat:@"%@ , %@ yrs",modal.offenderSex,modal.offenderAge]];
    [view.labelAddress setText:modal.offenderAddress];
    
    
  UIBezierPath *shadowPath1 = [UIBezierPath bezierPathWithRect:view.bounds];
//    UIBezierPath *shadowPath1 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 5, view.frame.size.width, view.frame.size.height)];

    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    view.layer.shadowOpacity = 0.75f;
    view.layer.shadowPath = shadowPath1.CGPath;
    //view.clipsToBounds = YES;
   // view.imageViewSex.clipsToBounds = YES;
    
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:view.imageViewSex.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(7.0, 7.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.imageViewSex.bounds;
    maskLayer.path = maskPath.CGPath;
    view.imageViewSex.layer.mask = maskLayer;

    view.imageViewSex.layer.masksToBounds = YES;
    
    return view;
}

- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index
{
    return self.arraySexOffender.count;
}



#pragma mark -- YSLDraggableCardContainer Delegate
- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection
{
    @try {
        [self.arraySexOffender removeObjectAtIndex:0];
        [[NSUserDefaults standardUserDefaults] rm_setCustomObject:self.arraySexOffender forKey:@"sex_list"];
        if (self.arraySexOffender.count==0) {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"sex_list"];
            [self refresh];
        }
        
        
    }
    @catch (NSException *exception) {
        
    }

    if (draggableDirection == YSLDraggableDirectionLeft) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionUp) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
}

- (void)cardContainderView:(YSLDraggableCardContainer *)cardContainderView updatePositionWithDraggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio
{
}

- (void)cardContainerViewDidCompleteAll:(YSLDraggableCardContainer *)container;
{
}

- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didSelectAtIndex:(NSInteger)index draggableView:(UIView *)draggableView
{
     self.sexOffenderModal = [self.arraySexOffender objectAtIndex:0];
    [self performSegueWithIdentifier:KSexOffenderDetailSegue sender:nil];
   
}



@end
