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
    [self viewHelpers];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBarAndTab:YES];
}


#pragma mark -
#pragma mark - View helpers
-(void)addMissing
{
    [self performSegueWithIdentifier:KAddMissingSegue sender:nil];
}
-(void)viewHelpers
{
    self.isProgressiveIndicator = YES;
    self.isElasticIndicatorLimit = NO;
    [self.buttonBarView.selectedBar setBackgroundColor:[UIColor whiteColor]];
    [self.buttonBarView setSelectedBarHeight:3];
    [self.buttonBarView setLabelFont:[UIFont boldSystemFontOfSize:13]];

    
    self.sBar = [[UISearchBar alloc]init];
    self.sBar.delegate = self;
    self.sBar.showsCancelButton = YES;
    [self.sBar setTintColor:[UIColor whiteColor]];
}
-(void)initialiseVCs
{
    self.community1 = [self.storyboard instantiateViewControllerWithIdentifier:KCommunityContent];
    self.community1.currentTab = NEIGHBOUR;
    self.community2 = [self.storyboard instantiateViewControllerWithIdentifier:KCommunityContent];
    self.community2.currentTab = FAMILY;
    self.community3 = [self.storyboard instantiateViewControllerWithIdentifier:KCommunityContent];
    self.community3.currentTab = FRIENDS;
    self.communityGroup = [self.storyboard instantiateViewControllerWithIdentifier:KCommunityContent];
    self.communityGroup.currentTab = GROUP;
    self.missingVC = [self.storyboard instantiateViewControllerWithIdentifier:KMissingPeople];

}


-(void)setNavBarAndTab:(BOOL)missing
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
        btnProfile.customView.clipsToBounds = YES;

        
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
            });
            
        });
    }
    
    if(missing)
    {
        UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addMissing)];
        [btnAdd setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = btnAdd;

    }
    else
    {
        
        UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_search"] style:UIBarButtonItemStylePlain target:self action:@selector(actionSearch)];
        [btnSearch setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = btnSearch;

    }

}

#pragma mark -
#pragma mark - Search helpers
-(void)searchInCommunity
{
    {
        NSMutableArray *arrayCommunity = self.community1.arrayCommunity;
        self.community1.arraySearch = [[NSMutableArray alloc] init];
        for (User *tempUser in arrayCommunity) {
            
            if([tempUser.userUserName respondsToSelector:@selector(localizedCaseInsensitiveContainsString:)])
            {
                if([tempUser.userUserName localizedCaseInsensitiveContainsString:self.sBar.text])
                {
                    [self.community1.arraySearch addObject:tempUser];
                }
            }
            else
            {
                if([tempUser.userUserName rangeOfString:self.sBar.text options:1].length!=0)
                {
                    [self.community1.arraySearch addObject:tempUser];
                }
            }
        }
        [self.community1.tableViewCommunity reloadData];
    }
    {
        NSMutableArray *arrayCommunity = self.community2.arrayCommunity;
        self.community2.arraySearch = [[NSMutableArray alloc] init];
        for (User *tempUser in arrayCommunity) {
            
            if([tempUser.userUserName respondsToSelector:@selector(localizedCaseInsensitiveContainsString:)])
            {
                if([tempUser.userUserName localizedCaseInsensitiveContainsString:self.sBar.text])
                {
                    [self.community2.arraySearch addObject:tempUser];
                }
            }
            else
            {
                if([tempUser.userUserName rangeOfString:self.sBar.text options:1].length!=0)
                {
                    [self.community2.arraySearch addObject:tempUser];
                }
            }
        }
        [self.community2.tableViewCommunity reloadData];
    }
    {
        NSMutableArray *arrayCommunity = self.community3.arrayCommunity;
        self.community3.arraySearch = [[NSMutableArray alloc] init];
        for (User *tempUser in arrayCommunity) {
            
            if([tempUser.userUserName respondsToSelector:@selector(localizedCaseInsensitiveContainsString:)])
            {
                if([tempUser.userUserName localizedCaseInsensitiveContainsString:self.sBar.text])
                {
                    [self.community3.arraySearch addObject:tempUser];
                }
            }
            else
            {
                if([tempUser.userUserName rangeOfString:self.sBar.text options:1].length!=0)
                {
                    [self.community3.arraySearch addObject:tempUser];
                }
            }
        }
        [self.community3.tableViewCommunity reloadData];
    }
    {
        [self.community4 searchUser];
    }
    
}

#pragma mark -
#pragma mark - Search bar delegate and buttons
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.isSearching = false;
    self.navigationItem.titleView = nil;
    [self setNavBarAndTab];
    [self.community1.tableViewCommunity reloadData];
    [self.community2.tableViewCommunity reloadData];
    [self.community3.tableViewCommunity reloadData];
    self.community4.arrayCommunity = nil;
    [self.community4.tableViewCommunity reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.isSearching = true;
    [self searchInCommunity];
}

#pragma mark -
#pragma mark - XLPagerDatasourec
-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    [self initialiseVCs];
    return @[self.community1,self.community2,self.community3,self.communityGroup,self.missingVC];

}



#pragma mark -
#pragma mark - Button Actions
-(void)actionSearch
{
//    [self.sBar becomeFirstResponder];
//    
//    self.navigationItem.titleView  = self.sBar;
//    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.rightBarButtonItem = nil;
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
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if([segue.identifier isEqualToString:KSearchMainSegue])
     {
         SearchMainViewController *searchVc= (SearchMainViewController *)segue.destinationViewController;
         searchVc.currentTab = 2;
     }
 }
 

@end
