//
//  WalkThroughViewController.m
//  MyGuardApp
//
//  Created by vishnu on 14/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "WalkThroughViewController.h"

@interface WalkThroughViewController ()

@end

@implementation WalkThroughViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self walkSetter];
}


#pragma mark - 
#pragma mark - Setup Helper
-(void)walkSetter
{
    CGRect rectScreen =  [[UIScreen mainScreen] bounds];
    WalkThroughView *view1 = [[WalkThroughView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [view1 setFrame:rectScreen];
    [view1 setUpWalk:NSLocalizedString(@"fire_walk_t", nil) desc:NSLocalizedString(@"fire_walk", nil) imageName:@"bg_fire.png"];
    [view1 setBackgroundColor:KOrangeColor];
    
    
    WalkThroughView *view2 = [[WalkThroughView alloc] initWithFrame:CGRectMake(rectScreen.size.width, 0, rectScreen.size.width, rectScreen.size.height)];
    [view2 setUpWalk:NSLocalizedString(@"gun_walk_t", nil) desc:NSLocalizedString(@"gun_walk", nil) imageName:@"bg_gs.png"];
    [view2 setBackgroundColor:KRedColor];
    
    WalkThroughView *view3 = [[WalkThroughView alloc] initWithFrame:CGRectMake(2*rectScreen.size.width, 0, rectScreen.size.width, rectScreen.size.height)];
    [view3 setUpWalk:NSLocalizedString(@"co_walk_t", nil) desc:NSLocalizedString(@"co_walk", nil) imageName:@"bg_co.png"];
    [view3 setBackgroundColor:KGreenColor];
    
    WalkThroughView *view4 = [[WalkThroughView alloc] initWithFrame:CGRectMake(3*rectScreen.size.width, 0, rectScreen.size.width, rectScreen.size.height)];
    [view4 setUpWalk:NSLocalizedString(@"sex_walk_t", nil) desc:NSLocalizedString(@"sex_walk", nil) imageName:@"bg_sex.png"];
    [view4 setBackgroundColor:KPurpleColor];
    
    WalkThroughLastView *view5 = [[WalkThroughLastView alloc] initWithFrame:CGRectMake(rectScreen.size.width*4, 0, rectScreen.size.width, rectScreen.size.height)];
    [view5 setterText];
    
    [self.scrollViewMain setContentSize:CGSizeMake(rectScreen.size.width*5, rectScreen.size.height)];
    [self.scrollViewMain setDelegate:self];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [self.scrollViewMain addSubview:view1];
    [self.scrollViewMain addSubview:view2];
    [self.scrollViewMain addSubview:view3];
    [self.scrollViewMain addSubview:view4];
    [self.scrollViewMain addSubview:view5];

}


#pragma mark - 
#pragma mark - Scroll view delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGRect rectScreen =  [[UIScreen mainScreen] bounds];
    if(targetContentOffset->x>rectScreen.size.width*3)
    {
        [self.btnLoginRegister setHidden:NO];
        [self.btnStartDemo setHidden:NO];
        [self.btnSkipWalkThrough setHidden:YES];
    }
    else
    {
        [self.btnLoginRegister setHidden:YES];
        [self.btnStartDemo setHidden:YES];
        [self.btnSkipWalkThrough setHidden:NO];

    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


#pragma mark -
#pragma mark - Unwind 
- (IBAction)unwindToStartViewController:(UIStoryboardSegue *)unwindSegue
{
    
    
    
}

@end
