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


- (IBAction)actionForgotPassword:(id)sender {
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:nil message:@"Enter your email id" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [dialog show];
    
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
//    [self showStaticAlert:@"Error" message:@"Please reset your location settings."];
//    [self removeLoaderView];
    
    [self setUpLoaderView];
    NSInteger secondsFromGMT = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSString *urlStr = [NSString stringWithFormat:KLoginApi , KbaseUrl , self.tfEmail.text ,self.tfPassword.text,30.0f,76.0f,(long)secondsFromGMT];
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

#pragma mark - 
#pragma mark - validation
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


#pragma mark -
#pragma mark -  Alert View Delegates
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (![self validateEmailWithString:textField.text]||[textField.text length]==0){
        return NO;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Ok"])
    {
        UITextField *tfEmail = [alertView textFieldAtIndex:0];
        
        
        [self setUpLoaderView];
        NSString *stringForgotPassword = [NSString stringWithFormat:@"%@forgot_password.php?email=%@",KbaseUrl,tfEmail.text];
        [iOSRequest getJsonResponse:stringForgotPassword success:^(NSDictionary *responseDict) {
            if([[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"success"]] isEqualToString:@"1"])
            [self showStaticAlert:@"Success" message:@"Password instructions sent to email id"];

            else
                [self showStaticAlert:@"Error" message:@"Email doesn't exist"];

            [loaderObj removeFromSuperview];
        } failure:^(NSString *errorString) {
            [loaderObj removeFromSuperview];
                    }];
        
        //}
    }
    
    
}


@end
