//
//  BaseViewController.m
//  MyGuardApp
//
//  Created by vishnu on 19/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    JTMaterialSpinner *loaderObj ;
    IQKeyboardReturnKeyHandler *returnKeyHandler;

}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];

    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
-(void)dealloc
{
    returnKeyHandler = nil;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - Show Static Alert
-(void)showStaticAlert : (NSString *)title message : (NSString *)message
{
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [Alert show];
}

#pragma mark - Hide Unhide Loader View
-(void)setUpLoaderView:(UIColor *)colorLoader
{
    
    [self.view setUserInteractionEnabled:NO];
    [loaderObj removeFromSuperview];
    loaderObj = [[JTMaterialSpinner alloc] init];
    CGRect rect = [[UIScreen mainScreen] bounds];
    loaderObj.frame = CGRectMake(rect.size.width/2-20, rect.size.height/2-20, 40, 40);
    loaderObj.circleLayer.lineWidth = 2.0;
    
    loaderObj.circleLayer.strokeColor = colorLoader.CGColor;
    [[UIApplication sharedApplication].keyWindow addSubview:loaderObj];
    [loaderObj beginRefreshing];
}

-(void)setUpLoaderView
{
    [loaderObj removeFromSuperview];
    loaderObj = [[JTMaterialSpinner alloc] init];
    loaderObj.frame = CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-20, 40, 40);
    loaderObj.circleLayer.lineWidth = 2.0;
    
    loaderObj.circleLayer.strokeColor = KPurpleColor.CGColor;
    [[UIApplication sharedApplication].keyWindow addSubview:loaderObj];
    [loaderObj beginRefreshing];
}

-(void)removeLoaderView
{
    [self.view setUserInteractionEnabled:YES];
    [loaderObj removeFromSuperview];
    [loaderObj endRefreshing];
}


#pragma mark - 
#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}


@end
