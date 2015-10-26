//
//  StartViewController.m
//  MyGuardApp
//
//  Created by vishnu on 17/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

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
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"profile"]==nil)
    {
        [self performSegueWithIdentifier:KWalkSegue sender:nil];
    }
    else
    {
        [self performSegueWithIdentifier:KtabSegue sender:self];
        
    }

    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
- (IBAction)unwindToStartViewController:(UIStoryboardSegue *)unwindSegue
{
    
    
    
}


@end
