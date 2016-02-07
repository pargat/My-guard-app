//
//  MissingPersonViewController.m
//  MyGuardApp
//
//  Created by vishnu on 13/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import "MissingPersonViewController.h"

@interface MissingPersonViewController ()

@end

@implementation MissingPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self viewHelper];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 
#pragma mark - Helper function
-(void)showData
{
    [self.labelLast setText:self.missingModal.missingLocation];
    [self.labelMissingSince setText:self.missingModal.missingDate];
    [self.labelDescription setText:self.missingModal.missingDescription];
    [self.labelName setText:self.missingModal.missingName];
    [self.labelAge setText:self.missingModal.missingAge];
    [self.labelHeight setText:self.missingModal.missingHeight];
    [self.labelHair setText:self.missingModal.missingHair];
    [self.labelEye setText:self.missingModal.missingEye];
    [self.imageViewPerson sd_setImageWithURL:[NSURL URLWithString:self.missingModal.missingImage]];
    [self.labelDescription setPreferredMaxLayoutWidth:self.view.frame.size.width - 112];

}
-(void)fetchMissingPerson
{
    [self setUpLoaderView];
    
    [iOSRequest postNormalData:nil :[NSString stringWithFormat:KFetchMissingApi,KbaseUrl,self.missingId] success:^(NSDictionary *responseDict) {
        self.missingModal = [[MissingModal alloc] initWithAttributes:[responseDict valueForKey:@"data"]];
        [self showData];
        [self removeLoaderView];
    } failure:^(NSError *error) {
        [self showStaticAlert:@"Error" message:KInternetNotAvailable];
        [self removeLoaderView];
    }];
}
-(void)viewHelper
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    [navigationBar setBackgroundColor:KPurpleColorNav];
    
    [navigationBar setBarTintColor:KPurpleColorNav];
    [navigationBar setBarStyle:UIBarStyleBlack];
    [navigationBar setTranslucent:NO];
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [navigationBar setShadowImage:[UIImage new]];

    
    
    self.labelNameP.text = NSLocalizedString(@"full_name", nil);
    self.labelMissingSInceP.text = NSLocalizedString(@"missing_since", nil);
    self.labelLastP.text = NSLocalizedString(@"last_seen_at", nil);
    self.labelAgeP.text = NSLocalizedString(@"missing_age", nil);
    self.labelHeightP.text = NSLocalizedString(@"missing_height", nil);
    self.labelHairP.text = NSLocalizedString(@"missing_hair_color", nil);
    self.labelEyeP.text = NSLocalizedString(@"missing_eye_color", nil);

    
    self.btnCall.layer.cornerRadius = 4.0;
    self.btnCall.layer.borderColor = KPurpleColor.CGColor;
    self.btnCall.layer.borderWidth = 1;
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    self.navigationItem.title = NSLocalizedString(@"missing_person", nil);
    
    
    if(self.missingId.length==0)
    {
        [self showData];
    }
    else
    {
        [self fetchMissingPerson];

    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)callContact : (NSString *)phoneNo
{
    
    
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phoneNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        [self showAlert:@"Call facility is not available"];
    }
    
    
}
-(void) showAlert:(NSString *)message
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    
}

#pragma mark - 
#pragma mark - Button Actions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionCall:(id)sender {
    [self callContact:self.missingModal.missingPhone];
}
@end
