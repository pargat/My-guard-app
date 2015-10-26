//
//  RegisterStep2ViewController.m
//  MyGuardApp
//
//  Created by vishnu on 16/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "RegisterStep2ViewController.h"

@interface RegisterStep2ViewController ()
{
    UITextField *activeField;

}
@end

@implementation RegisterStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self viewHelper];
    [self registerForKeyboardNotifications];
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+30, 0.0);
    self.scrollViewObj.contentInset = contentInsets;
    self.scrollViewObj.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= (kbSize.height);
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) )
    {
        [self.scrollViewObj scrollRectToVisible:CGRectMake(activeField.frame.origin.x, activeField.frame.origin.y - 30 , activeField.frame.size.width, activeField.frame.size.height)  animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollViewObj.contentInset = contentInsets;
    self.scrollViewObj.scrollIndicatorInsets = contentInsets;
}

#pragma mark -
#pragma mark - Helpers
-(void)hitSignUp
{
    [self setUpLoaderView];
    NSData *imageData;
    if(self.isImageSelected)
        imageData = UIImageJPEGRepresentation(self.imageViewDp.image, 0.5);
    
    [iOSRequest uploadData:[NSString stringWithFormat:KSignUpScreen,KbaseUrl] parameters:[self formatDataBeforeSending] imageData:imageData success:^(NSDictionary *responseStr) {
        
        if ([[NSString stringWithFormat:@"%@" , [responseStr valueForKey:@"success"]] isEqualToString:@"1"])
        {
            Profile *selfProfile = [[Profile alloc] initWithAttributes:[responseStr valueForKey:@"profile"]];
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:selfProfile forKey:@"profile"];
            [self performSegueWithIdentifier:KtabSegue sender:self];
        }
        [self removeLoaderView];

    } failure:^(NSError *error) {
        [self removeLoaderView];
    }];
}
-(NSDictionary *)formatDataBeforeSending
{
    
    NSMutableDictionary *formattedDict = [NSMutableDictionary new];
    [formattedDict setObject:self.stringEmail forKey:@"email"];
    [formattedDict setObject:self.textFieldUser.text forKey:@"username"];
    [formattedDict setObject:self.stringPassword forKey:@"password"];
    
    [formattedDict setObject:[self.textFieldFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"firstname"];
    [formattedDict setObject:self.textFieldLastName.text forKey:@"lastname"];
    if([self.textFieldTypeOFDisability.text isEqualToString:@""])
        [formattedDict setObject:[self.textFieldTypeOFDisability.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]  forKey:@"disability"];
    else
        [formattedDict setObject:@"none" forKey:@"disability"];
    [formattedDict setObject:self.textFieldCode.text forKey:@"code"];
    [formattedDict setObject:(self.segmentedControlGender.selectedSegmentIndex == 0? @"male" : @"female") forKey:@"gender"];
    [formattedDict setObject:self.stringDob forKey:@"dob"];

    LOcationUpdater *locMan = [LOcationUpdater sharedManager];
    CLLocation *cords = locMan.currentLoc;
    [formattedDict setObject:[NSString stringWithFormat:@"%f",cords.coordinate.latitude] forKey:@"latitude"];
    [formattedDict setObject:[NSString stringWithFormat:@"%f",cords.coordinate.longitude] forKey:@"longitude"];
    
    
    
    return formattedDict;
}
#pragma mark -
#pragma mark - Validation
-(NSString *)validateUsername:(NSString *)userName
{
    NSString *usernameString=@"";
    
    
    NSString *userNameRegex = @"[A-Za-z]+[A-Za-z0-9]{3,39}";
    NSPredicate *userTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userNameRegex];
    BOOL isValidUsername = [userTest  evaluateWithObject:userName];
    if(!isValidUsername)
    {
        usernameString = @"Please enter a valid username";
    }
    return usernameString;
}

-(NSString *)validateForm
{
    NSString *msg ;
    if (![[self validateUsername:self.textFieldUser.text] isEqualToString:@""])
    {
        msg = [self validateUsername:self.textFieldUser.text] ;
    }
    else if ([[self.textFieldFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]  == 0)
        msg = @"Please enter first name" ;
    else if ([[self.textFieldLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]  == 0)
        msg = @"Please enter last  name" ;

    
    else if (self.stringDob==nil)
        msg = @"Please enter your date of birth" ;
    
    else if (self.textFieldCode.text.length == 0)
        msg = @"Please enter your code" ;
    
    return msg;
}

#pragma mark -
#pragma mark - UITextfield Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *nextTf = (UITextField *)[self.view viewWithTag:textField.tag+1];
    (nextTf == nil ) ?  [textField resignFirstResponder] : [nextTf becomeFirstResponder]  ;
    return TRUE;
}
#pragma mark -
#pragma mark - Helpers
-(void)setUpNavBar
{
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    [self.navigationItem setTitle:NSLocalizedString(@"details", nil)];
    
}
-(void)viewHelper
{
    self.imageViewDp.layer.cornerRadius = self.imageViewDp.frame.size.width/2;
    self.imageViewDp.clipsToBounds = YES;
    [self.segmentedControlGender setTitle:NSLocalizedString(@"male", nil) forSegmentAtIndex:0];
    [self.segmentedControlGender setTitle:NSLocalizedString(@"female", nil) forSegmentAtIndex:1];
    
    [self.textFieldTypeOFDisability setPlaceholder:NSLocalizedString(@"disability", nil)];
    [self.textFieldFirstName setPlaceholder:NSLocalizedString(@"first_name", nil)];
    [self.textFieldLastName setPlaceholder:NSLocalizedString(@"last_name", nil)];
    [self.textFieldCode setPlaceholder:NSLocalizedString(@"code", nil)];

    [self.textFieldUser setPlaceholder:NSLocalizedString(@"user", nil)];
    
    [self.textFieldUser setDelegate:self];
    [self.textFieldCode setDelegate:self];
    [self.textFieldFirstName setDelegate:self];
    [self.textFieldLastName setDelegate:self];
    [self.textFieldTypeOFDisability setDelegate:self];
    
    //Normal view tap
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [tapGesture setCancelsTouchesInView:YES];
    [self.view addGestureRecognizer:tapGesture];
    
    
    if(self.dictFb!=nil)
    {
        if([[self.dictFb valueForKey:@"gender"] isEqualToString:@"male"])
        {
            [self.segmentedControlGender setSelectedSegmentIndex:0];
        }
        else
        {
            [self.segmentedControlGender setSelectedSegmentIndex:1];
        }
        [self.textFieldFirstName setText:[self.dictFb valueForKey:@"first_name"]];
        [self.textFieldLastName setText:[self.dictFb valueForKey:@"last_name"]];
        NSString *imageString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",[self.dictFb valueForKey:@"id"]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *tmpdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]];
            UIImage *image = [UIImage imageWithData:tmpdata];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.isImageSelected = true;
                self.imageViewDp.image = image;
            });
            
        });

        
    }

}

-(void)tapped
{
    [self.view endEditing:YES];
}





#pragma mark -
#pragma mark - Action Sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;

    if(buttonIndex==0)
    {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];

    }
    else if (buttonIndex==1)
    {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];

    }
    else if (buttonIndex==2)
    {
        self.isImageSelected = false;
        [self.imageViewDp setImage:[UIImage imageNamed:@"ic_dp_small"]];
    }
    
    

}
#pragma mark -
#pragma mark - Button Actions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionDp:(id)sender {
    UIActionSheet *Sheet = [[UIActionSheet alloc] initWithTitle:@"Select Picture from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera" , @"Photo Library",@"Remove Photo", nil];
    [Sheet showInView:self.view];
}
- (IBAction)actionDob:(id)sender {
    [self openDateSelectionController];
}

- (IBAction)actionSignup:(id)sender {
    NSString *stringValidation = [self validateForm];
    if(stringValidation==nil)
    {
        [self hitSignUp];
    }
    else
    {
        [self showStaticAlert:@"Error" message:stringValidation];
    }
}

#pragma mark -
#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageViewDp.image = chosenImage;
    self.isImageSelected = true;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma mark - Date-Time Selection Methods

- (void)openDateSelectionController
{
    [self.view endEditing:YES];
    //Create select action
    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        
        
        NSLog(@"Successfully selected date: %@", ((UIDatePicker *)controller.contentView).date);
        NSDate *date = ((UIDatePicker *)controller.contentView).date;
        
        NSDateFormatter *formatterDate = [[NSDateFormatter alloc] init];
        formatterDate.dateFormat = @"MM/dd/yyyy";
        NSString *dateString = [formatterDate stringFromDate:date];
        [self.btnDob setTitle:dateString forState:UIControlStateNormal];
        
        NSDateFormatter *formatterDate1 = [[NSDateFormatter alloc] init];
        formatterDate1.dateFormat = @"yyyy-MM-dd";
        self.stringDob = [formatterDate1 stringFromDate:date];
        
        
    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    //Create date selection view controller
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleDefault selectAction:selectAction andCancelAction:cancelAction];
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    
    
    NSDate *today = [NSDate date];
    dateSelectionController.datePicker.maximumDate = today;
    
 
    
    
    
    
    dateSelectionController.title =  NSLocalizedString(@"select_dob", nil);
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
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
