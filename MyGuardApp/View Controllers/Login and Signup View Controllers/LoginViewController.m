//
//  LoginViewController.m
//  MyGuardApp
//
//  Created by vishnu on 15/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
{
    JTMaterialSpinner *loaderObj ;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addTapGesture];
    [self locationInitialiser];
}

#pragma mark - View Helpers
-(void)addTapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}
-(void)tapHandler
{
    [self.view endEditing:YES];
}
-(void)setUpNavBar
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBarTintColor:KPurpleColorNav];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationItem setTitle:NSLocalizedString(@"login", nil)];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    UIBarButtonItem *btnLogin = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(actionLogin)];
    self.navigationItem.rightBarButtonItem = btnLogin;
}

#pragma mark - Show Static Alert
-(void)showStaticAlert : (NSString *)title message : (NSString *)message
{
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Done" otherButtonTitles: nil];
    [Alert show];
}


#pragma mark - Button Actions
-(void)actionLogin
{
    if([[self.tfEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        
    }
    else if ([[self.tfEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        
    }
    else
    {
        [self.locationManager setDelegate:self];
        [self.locationManager startUpdatingLocation];
    }
}
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Hide Unhide Loader View

-(void)setUpLoaderView
{
    [loaderObj removeFromSuperview];
    loaderObj = [[JTMaterialSpinner alloc] init];
    loaderObj.frame = CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-20, 40, 40);
    loaderObj.circleLayer.lineWidth = 2.0;
    loaderObj.circleLayer.strokeColor = KPurpleColor.CGColor;
    [self.view addSubview:loaderObj];
    [loaderObj beginRefreshing];
}

-(void)removeLoaderView
{
    [loaderObj removeFromSuperview];
    [loaderObj endRefreshing];
}


#pragma mark - Location related functions
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self showStaticAlert:@"Error" message:@"Please reset your location settings."];
    [self removeLoaderView];
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];
    
    [self setUpLoaderView];
    NSInteger secondsFromGMT = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSString *urlStr = [NSString stringWithFormat:KLoginApi , KbaseUrl , self.tfEmail.text ,self.tfPassword.text,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,(long)secondsFromGMT];
    [iOSRequest getJsonResponse:urlStr success:^(NSDictionary *responseDict)
     {
         NSLog(@"%@" ,responseDict);
         
         if ([[NSString stringWithFormat:@"%@" , [responseDict valueForKey:@"success"]] isEqualToString:@"1"])
         {
             Profile *selfProfile = [[Profile alloc] initWithAttributes:[responseDict valueForKey:@"profile"]];
             [[NSUserDefaults standardUserDefaults] rm_setCustomObject:selfProfile forKey:@"profile"];
             [self performSegueWithIdentifier:KtabSegue sender:self];
         }
         else
         {
             [self showStaticAlert:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"invalid_email_password", nil)];
         }
         [self removeLoaderView];
         

     } failure:^(NSString  *errorString) {
                [self showStaticAlert:NSLocalizedString(@"error", nil) message:errorString];
         [self removeLoaderView];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
