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
    [self setNavBarAndTab];
}


#pragma mark -
#pragma mark - View helpers
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
    self.community4 = [self.storyboard instantiateViewControllerWithIdentifier:KCommunitySearchContent];
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
    
    Profile *modal = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *tmpdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:modal.profileImageFullLink]];
        UIImage *image = [UIImage imageWithData:tmpdata];
        image = [image circularScaleAndCropImage:CGRectMake(0, 0, 32, 32)];
        image = [image imageByScalingAndCroppingForSize:CGSizeMake(32, 32)];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.isSearching==false)
            {
                UIButton *btnProfileA = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
                [btnProfileA setImage:image forState:UIControlStateNormal];
                [btnProfileA addTarget:self action:@selector(actionProfile) forControlEvents:UIControlEventTouchUpInside];
                btnProfileA.layer.cornerRadius = btnProfileA.frame.size.width/2;
                btnProfileA.layer.borderColor = [[UIColor whiteColor] CGColor];
                btnProfileA.layer.borderWidth = 1.0;
                
                
                UIBarButtonItem *btnProfile = [[UIBarButtonItem alloc] initWithCustomView:btnProfileA];
                [btnProfile setTintColor:[UIColor whiteColor]];
                self.navigationItem.leftBarButtonItem = btnProfile;
            }
        });
        
    });
    
    
}

#pragma mark -
#pragma mark - Search helpers
-(void)searchInCommunity
{
    {
        NSMutableArray *arrayCommunity = self.community1.arrayCommunity;
        self.community1.arraySearch = [[NSMutableArray alloc] init];
        for (User *tempUser in arrayCommunity) {
            
            if([tempUser.userFirstName respondsToSelector:@selector(localizedCaseInsensitiveContainsString:)])
            {
                if([tempUser.userFirstName localizedCaseInsensitiveContainsString:self.sBar.text])
                {
                    [self.community1.arraySearch addObject:tempUser];
                }
            }
            else
            {
                if([tempUser.userFirstName rangeOfString:self.sBar.text options:1].length!=0)
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
            
            if([tempUser.userFirstName respondsToSelector:@selector(localizedCaseInsensitiveContainsString:)])
            {
                if([tempUser.userFirstName localizedCaseInsensitiveContainsString:self.sBar.text])
                {
                    [self.community2.arraySearch addObject:tempUser];
                }
            }
            else
            {
                if([tempUser.userFirstName rangeOfString:self.sBar.text options:1].length!=0)
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
            
            if([tempUser.userFirstName respondsToSelector:@selector(localizedCaseInsensitiveContainsString:)])
            {
                if([tempUser.userFirstName localizedCaseInsensitiveContainsString:self.sBar.text])
                {
                    [self.community3.arraySearch addObject:tempUser];
                }
            }
            else
            {
                if([tempUser.userFirstName rangeOfString:self.sBar.text options:1].length!=0)
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
    return @[self.community1,self.community2,self.community3];
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




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
