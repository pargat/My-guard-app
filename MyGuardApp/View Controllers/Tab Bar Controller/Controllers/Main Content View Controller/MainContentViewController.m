//
//  MainContentViewController.m
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "MainContentViewController.h"

@interface MainContentViewController ()

@end

@implementation MainContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isProgressiveIndicator = YES;
    self.isElasticIndicatorLimit = NO;
    [self.buttonBarView.selectedBar setBackgroundColor:[UIColor whiteColor]];
    [self.buttonBarView setSelectedBarHeight:3];
    // Do any additional setup after loading the view.
    [self viewColorThemeSelector];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
#pragma mark -
#pragma mark - Helpers
-(void)viewColorThemeSelector
{
    switch (self.currentTab) {
        case FIRE:
            [self.buttonBarView setBackgroundColor:KOrangeColor];
            [self.viewHeader setBackgroundColor:KOrangeColor];
            [self.view setBackgroundColor:KOrangeColor];

            break;
        case GUN:
            [self.buttonBarView setBackgroundColor:KRedColor];
            [self.viewHeader setBackgroundColor:KRedColor];
            [self.view setBackgroundColor:KRedColor];

            break;
        case CO:
            [self.buttonBarView setBackgroundColor:KGreenColor];
            [self.viewHeader setBackgroundColor:KGreenColor];
            [self.view setBackgroundColor:KGreenColor];

            break;
        default:
            break;
    }
}
-(void)initialiseVCs
{
    self.feedVC = (FeedViewController *)[self.storyboard instantiateViewControllerWithIdentifier:KFeedVC];
    self.safetyVC = (SafetyMeasuresViewController *)[self.storyboard instantiateViewControllerWithIdentifier:KSafetyVC];
    self.infoVC = (InfoVideosViewController *)[self.storyboard instantiateViewControllerWithIdentifier:KInfoVC];
    self.feedVC.delegate = self;
    self.safetyVC.delegate = self;
    self.infoVC.delegate = self;
    if(self.currentTab==FIRE)
    {
        self.safetyVC.feedType = @"1";
        self.infoVC.feedType = @"1";
        self.feedVC.feedType = 1;
        self.feedVC.markerUrl = KFireIcon;
    }
    else if (self.currentTab==GUN)
    {
        self.safetyVC.feedType = @"3";
        self.infoVC.feedType = @"3";
        self.feedVC.feedType = 3;
        self.feedVC.markerUrl = KGunIcon;
    }
    else
    {
        self.safetyVC.feedType = @"2";
        self.infoVC.feedType = @"2";
        self.feedVC.feedType = 2;
        self.feedVC.markerUrl = KCOIcon;
    }

}

#pragma mark -
#pragma mark - Feed Delegate
-(void)delHideShowHeader:(BOOL)hide
{
    if(hide&&self.heightExtra.constant==100)
    {
        self.heightExtra.constant = 0;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];

    }
    else if(!hide&&self.heightExtra.constant==0)
    {
        self.heightExtra.constant = 100;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];

    }
    
}

#pragma mark -
#pragma mark - XLPagerDatasourec
-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    [self initialiseVCs];
    return @[self.feedVC,self.safetyVC,self.infoVC];
}

#pragma mark -
#pragma mark - button actions
- (IBAction)actionEmergencyContact:(id)sender {
}

- (IBAction)actionAlarm:(id)sender {
    
    [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"r_u_sure", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"no", nil) otherButtonTitles:NSLocalizedString(@"yes", nil), nil] show];
    
}


#pragma mark -
#pragma mark - Alert View Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        NSString *type;
        if(self.currentTab==FIRE)
        {
           type = @"1";
        }
        else if (self.currentTab == GUN)
        {
            type = @"2";
        }
        else
        {
            type = @"3";
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"alarmOff" object:nil userInfo:@{@"type": type}];
    }
}

@end
