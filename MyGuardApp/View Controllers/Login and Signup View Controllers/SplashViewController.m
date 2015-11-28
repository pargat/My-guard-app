//
//  SplashViewController.m
//  MyGuardApp
//
//  Created by vishnu on 05/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "SplashViewController.h"
#import "LoaderView.h"
@interface SplashViewController ()
{
    JTMaterialSpinner *loaderObj ;
}

@end

@implementation SplashViewController

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
    [self.navigationController.navigationBar setHidden:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        [self.navigationController.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    [self locationInitialiser];
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"c"]!=nil)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"c"];
    }
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

#pragma mark - Show Static Alert
-(void)showStaticAlert : (NSString *)title message : (NSString *)message
{
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
    [Alert show];
}



#pragma mark - Location related functions
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self showStaticAlert:@"Error" message:@"Please reset your location settings."];
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];

        NSInteger secondsFromGMT = [[NSTimeZone localTimeZone] secondsFromGMT];
        [iOSRequest getJsonResponse:[NSString stringWithFormat:KFbRegister,KbaseUrl,[self.dictFB valueForKey:@"email"],currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,(long)secondsFromGMT] success:^(NSDictionary *responseDict) {
            [self removeLoaderView];
            if([[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"success"]] isEqualToString:@"0"])
            {
                [self performSegueWithIdentifier:KRegister1Segue sender:self];
            }
            else
            {
                if ([[NSString stringWithFormat:@"%@" , [responseDict valueForKey:@"success"]] isEqualToString:@"1"])
                {
                    Profile *selfProfile = [[Profile alloc] initWithAttributes:[responseDict valueForKey:@"profile"]];
                    [[NSUserDefaults standardUserDefaults] rm_setCustomObject:selfProfile forKey:@"profile"];
                    [self performSegueWithIdentifier:KtabSegue sender:self];
                }
            }
            
        } failure:^(NSString *errorString) {
            
        }];
}

-(void)locationInitialiser
{
    self.locationManager = [[CLLocationManager alloc] init];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

#pragma mark - Hide Unhide Loader View

-(void)setUpLoaderView
{
    [loaderObj removeFromSuperview];
    loaderObj = [[JTMaterialSpinner alloc] init];
    loaderObj.frame = CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-20, 40, 40);
    loaderObj.circleLayer.lineWidth = 2.0;
    loaderObj.circleLayer.strokeColor = KOrangeColor.CGColor;
    [self.view addSubview:loaderObj];
    [loaderObj beginRefreshing];
}

-(void)removeLoaderView
{
    [loaderObj removeFromSuperview];
    [loaderObj endRefreshing];
}

#pragma mark - Functions
- (IBAction)actionLogin:(id)sender {
    [self performSegueWithIdentifier:KLoginSegue sender:self];
}

- (IBAction)actionFB:(id)sender {
    [self setUpLoaderView];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    //[login logOut];
    [login logInWithReadPermissions:@[@"public_profile",@"user_birthday",@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if(error)
        {
            NSLog(@"fb error:%@",error);
            [self showStaticAlert:@"Error" message:error.description];
        }
        else if (result.isCancelled)
        {
            
        }
        else
        {
            if([FBSDKAccessToken currentAccessToken])
            {
                [self setUpLoaderView];
                NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                [parameters setValue:@"id,name,first_name,email,birthday,last_name,gender" forKey:@"fields"];
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters: parameters]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if(!error)
                     {
                         self.dictFB = result;
                         [self.locationManager setDelegate:self];
                         [self.locationManager startUpdatingLocation];
                     }
                 }];
            }
        }
    }];

}

- (IBAction)actionRegister:(id)sender {
    [self performSegueWithIdentifier:KRegister1Segue sender:self];
}


#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:KRegister1Segue])
    {
        
        Register1ViewController *regStep1VC = (Register1ViewController *)segue.destinationViewController;
        regStep1VC.dictFb = self.dictFB;
    }
    else if([segue.identifier isEqualToString:KtabSegue])
    {
        MainTabBarController *mainVC = (MainTabBarController *)segue.destinationViewController;
        mainVC.isFirstTime = true;
    }

}

@end
