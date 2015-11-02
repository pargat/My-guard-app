//
//  YoutubeViewController.m
//  FireSonar
//
//  Created by CB Labs_1 on 11/03/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import "YoutubeViewController.h"
@interface YoutubeViewController ()
@end

@implementation YoutubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.stringLink]];
    [self.webViewVideo loadRequest:request];
    [self.webViewVideo setDelegate:self];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeLoaderView];
    
}
#pragma  mark - 
#pragma mark - Helper
- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

-(void)setNavBar
{
    [self.navigationItem setTitle:NSLocalizedString(@"video", nil)];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    
}

#pragma mark - Show Static Alert
-(void)showStaticAlert : (NSString *)title message : (NSString *)message
{
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
    [Alert show];
}
#pragma mark -
#pragma mark - web view delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&setCategoryError]) {
        // handle error
    }
    [self removeLoaderView];
    [self setUpLoaderView:self.colorLoader];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self removeLoaderView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self removeLoaderView];
    [self showStaticAlert:@"Error" message:KInternetNotAvailable];
    
}

#pragma mark -
#pragma mark - Button actions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
