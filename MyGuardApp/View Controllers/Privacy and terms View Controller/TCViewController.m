//
//  TCViewController.m
//  FireSonar
//
//  Created by CB Labs_1 on 20/02/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import "TCViewController.h"

@interface TCViewController ()

@end

@implementation TCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBar];
    [self.navigationItem setTitle:NSLocalizedString(@"tc", nil) ];
    [self.webViewMain loadHTMLString:NSLocalizedString(@"terms_string", nil) baseURL:nil];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavBar
{
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    self.navigationItem.leftBarButtonItem = btnBack;

}


#pragma mark - 
#pragma mark - Button Actions
- (void)actionBack {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
