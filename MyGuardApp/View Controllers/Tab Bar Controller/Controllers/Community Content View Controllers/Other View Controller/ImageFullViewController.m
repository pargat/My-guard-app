//
//  ImageFullViewController.m
//  MyGuardApp
//
//  Created by vishnu on 05/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "ImageFullViewController.h"

@interface ImageFullViewController ()

@end

@implementation ImageFullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarAndTab];
    [self viewHelper];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark - View helper
-(void)setNavBarAndTab
{
    
    [self.navigationItem setTitle:self.username];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    
}
-(void)viewHelper
{
    [self.imageViewMain sd_setImageWithURL:[NSURL URLWithString:self.imageLink]];
    [self.scrollViewMain setMinimumZoomScale:1];
    [self.scrollViewMain setMaximumZoomScale:6];
    [self.scrollViewMain setDelegate:self];
}
#pragma mark -
#pragma mark - Scroll view delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageViewMain;
}


#pragma mark -
#pragma mark - Button Actions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
