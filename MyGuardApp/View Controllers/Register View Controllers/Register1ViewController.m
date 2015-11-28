//
//  Register1ViewController.m
//  MyGuardApp
//
//  Created by vishnu on 16/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "Register1ViewController.h"

@interface Register1ViewController ()

@end

@implementation Register1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self viewHelper];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObservers];
    
}
#pragma mark - 
#pragma mark - View Helpers
-(void)setUpNavBar
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBarTintColor:KPurpleColorNav];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationItem setTitle:NSLocalizedString(@"register", nil)];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    self.navigationItem.leftBarButtonItem = btnBack;
    
}

-(void)viewHelper
{
    [self.textFieldEmail setDelegate:self];
    [self.textFieldPassword setDelegate:self];
    
    
    //Text view tap handler
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
    [tap setCancelsTouchesInView:NO];
    [self.textViewTC addGestureRecognizer:tap];
    
    //Normal view tap
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [tapGesture setCancelsTouchesInView:YES];
    [self.view addGestureRecognizer:tapGesture];
    
    NSMutableAttributedString *attributString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"already_member", nil) attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [attributString appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"sign_in", nil) attributes:@{NSForegroundColorAttributeName:KPurpleColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}]];
    [self.btnAlreadyMember setAttributedTitle:attributString forState:UIControlStateNormal];
    
    
    NSMutableAttributedString *attTc = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"I have read and agreed to" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0 alpha:0.4],NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}]];
    [attTc appendAttributedString:[[NSAttributedString alloc] initWithString:@" Terms & Conditions." attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0 alpha:0.6],NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}]];
    
   
    [self.textViewTC setAttributedText:attTc];
     [self.textViewTC setTextAlignment:NSTextAlignmentCenter];
    if(self.dictFb!=nil)
    {
        [self.textFieldEmail setText:[self.dictFb valueForKey:@"email"]];
    }
}
-(void)tapped
{
    [self.view endEditing:YES];
}
-(void)checkValidEmail
{
    [self setUpLoaderView];
    self.btnContinue.enabled = NO;

    NSString *stringEmail = [NSString stringWithFormat:KIsEmailAvailable,KbaseUrl,[self.textFieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [iOSRequest getJsonResponse:stringEmail success:^(NSDictionary *responseDict) {
        [self removeLoaderView];
        if([[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"success"]] isEqualToString:@"1"])
        {
            [self performSegueWithIdentifier:KRegisterStep2 sender:self];
        }
        else
        {
            [self showStaticAlert:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"email_not_available", nil)];
        }
        self.btnContinue.enabled = YES;
    } failure:^(NSString *errorString) {
         [self removeLoaderView];
        self.btnContinue.enabled = YES;
    }];
}

#pragma mark -
#pragma mark - UITextfield Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.textFieldEmail) {
        [self.textFieldPassword becomeFirstResponder];
    }
    else
    {
        [self.view endEditing:YES];
    }
    return TRUE;
}

#pragma mark - 
#pragma mark - Validations
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(NSString *)isValidDetails
{
    NSString *stringError;
    if([self.textFieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0)
    {
        stringError = @"Email field can't be empty";
    }
    else if (![self validateEmailWithString:self.textFieldEmail.text])
    {
        stringError = @"Please enter a valid email";
    }
    else if ([self.textFieldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0)
    {
        stringError = @"Password field can't be empty";
    }
    else if([self.textFieldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length<6)
    {
        stringError = @"Password should be atleast 6 characters long.";
    }
    else if(!self.btnCheckBox.isSelected)
    {
        stringError = @"Please agree to our terms and conditions.";
    }

    return stringError;
}


#pragma mark - 
#pragma mark - Button Actions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionContinue:(id)sender {
    NSString *stringError = [self isValidDetails];
    if(stringError==nil)
    {
        [self checkValidEmail];
    }
    else
    {
        [self showStaticAlert:@"Error" message:stringError];
    }
}

#pragma mark - Show Static Alert
-(void)showStaticAlert : (NSString *)title message : (NSString *)message
{
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [Alert show];
}


#pragma mark - 
#pragma mark - Text View helpers
- (void)textTapped:(UITapGestureRecognizer *)recognizer
{
    UITextView *textView = (UITextView *)recognizer.view;
    
    NSLayoutManager *layoutManager = textView.layoutManager;
    CGPoint location = [recognizer locationInView:textView];
    location.x -= textView.textContainerInset.left;
    location.y -= textView.textContainerInset.top;
    NSUInteger characterIndex;
    characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:textView.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    if(characterIndex>24&&characterIndex<=self.textViewTC.text.length)
    {
        [self performSegueWithIdentifier:KTCSegue sender:self];
    }
    
}

#pragma mark - Keyboard Notifications
-(void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.bottomSpace.constant = kbSize.height;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];

}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.bottomSpace.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}



#pragma mark -
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if([segue.identifier isEqualToString:KRegisterStep2])
     {
         RegisterStep2ViewController *regStep2 = (RegisterStep2ViewController *)segue.destinationViewController;
         regStep2.stringEmail = self.textFieldEmail.text;
         regStep2.stringPassword = self.textFieldPassword.text;
         regStep2.dictFb = self.dictFb;
     }
 }



#pragma mark -
#pragma mark - Button Actions
- (IBAction)actionTerms:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
}

- (IBAction)actionAlreadyMember:(id)sender {
}
@end
