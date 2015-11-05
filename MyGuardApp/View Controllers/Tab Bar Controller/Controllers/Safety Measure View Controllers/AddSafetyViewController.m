//
//  AddSafetyViewController.m
//  MyGuardApp
//
//  Created by vishnu on 07/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "AddSafetyViewController.h"

@interface AddSafetyViewController ()
{
    JTMaterialSpinner *loaderObj ;

}
@end

@implementation AddSafetyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self loader];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeLoaderView];
}
-(void)loader
{
    self.textViewDescription.placeholder = NSLocalizedString(@"type_here", nil);
    [self.labelAddTo setText:NSLocalizedString(@"add_to", nil)];
    NSArray *arrayBtnTitles = @[NSLocalizedString(@"safety_fire", nil),NSLocalizedString(@"safety_gun", nil),NSLocalizedString(@"safety_co", nil)];
    for (UIButton *btn in self.btnCollection) {
        [btn setTitle:[arrayBtnTitles objectAtIndex:[self.btnCollection indexOfObject:btn]] forState:UIControlStateNormal];
    }
}
- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}
-(void)setNavBar
{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if(self.currentTab==FIRE)
    {
        [self.navigationController.navigationBar setBarTintColor:KOrangeColor];
        [[self.btnCollection objectAtIndex:0] setSelected:YES];
    }
    else if (self.currentTab==GUN)
    {
        [self.navigationController.navigationBar setBarTintColor:KRedColor];
        [[self.btnCollection objectAtIndex:1] setSelected:YES];
    }
    else
    {
        [self.navigationController.navigationBar setBarTintColor:KGreenColor];
        [[self.btnCollection objectAtIndex:2] setSelected:YES];
    }
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(actionDone)];
    [btnDone setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = btnDone;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - 
#pragma mark - Button Actions
-(void)actionDone
{
    if([self.textViewDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0)
    {
    [self setUpLoaderView];
    NSString *type;
    if(self.currentTab== FIRE)
    {
        type = @"1";
    }
    else if (self.currentTab==GUN)
    {
        type = @"3";
    }
    else
    {
        type = @"2";
    }
    
    [iOSRequest getJsonResponse:[NSString stringWithFormat:KAddSafetyMeasureApi,KbaseUrl,[Profile getCurrentProfileUserId],type,[self.textViewDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] success:^(NSDictionary *responseDict) {
        [self removeLoaderView];
        [self showStaticAlert:@"Success" message:@"Safety measure added successfully"];
        [self.textViewDescription setText:@""];

    } failure:^(NSString *errorString) {
        [self removeLoaderView];

    }];
    }
    else
    {
        [self showStaticAlert:nil message:@"Description can't be empty"];
    }
}
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionType:(UIButton *)sender {
    
    if(sender.tag==0)
    {
        self.currentTab = FIRE;
        [self.navigationController.navigationBar setBarTintColor:KOrangeColor];
    }
    else if (sender.tag==1)
    {
        self.currentTab = GUN;
        [self.navigationController.navigationBar setBarTintColor:KRedColor];
    }
    else
    {
        self.currentTab = CO;
        [self.navigationController.navigationBar setBarTintColor:KGreenColor];
    }
    
    for (UIButton *btn in self.btnCollection) {
        int index = (int)[self.btnCollection indexOfObject:btn];
        if(index==sender.tag)
        {
            [btn setSelected:YES];
        }
        else
        {
            [btn setSelected:NO];
        }
    }

}


#pragma mark - Hide Unhide Loader View

-(void)setUpLoaderView
{
    [loaderObj removeFromSuperview];
    loaderObj = [[JTMaterialSpinner alloc] init];
    loaderObj.frame = CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-20, 40, 40);
    loaderObj.circleLayer.lineWidth = 2.0;
    
    
    
    if(self.currentTab==FIRE)
    {
        loaderObj.circleLayer.strokeColor = KOrangeColor.CGColor;
    }
    else if (self.currentTab==GUN)
    {
        loaderObj.circleLayer.strokeColor = KRedColor.CGColor;
    }
    else
    {
        loaderObj.circleLayer.strokeColor = KGreenColor.CGColor;
    }

    [self.view addSubview:loaderObj];
    [loaderObj beginRefreshing];
}

-(void)removeLoaderView
{
    [loaderObj removeFromSuperview];
    [loaderObj endRefreshing];
}



@end
