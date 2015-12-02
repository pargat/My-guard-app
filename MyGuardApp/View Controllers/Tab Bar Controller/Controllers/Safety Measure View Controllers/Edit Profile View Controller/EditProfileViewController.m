//
//  EditProfileViewController.m
//  MyGuardApp
//
//  Created by vishnu on 20/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()
{
    
    UITextField *activeField;
}
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self setDefaultValues];
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
    [self removeLoaderView];
}
#pragma mark -
#pragma mark - View Helper
-(void)viewHelper
{
    [self.btnDonb setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    tapgesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapgesture];
}
-(void)tapped
{
    [self.view endEditing:YES];
}
-(void)setNavBar
{
    [self.navigationItem setTitle:NSLocalizedString(@"edit_profile", nil)];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    
}

-(void)setDefaultValues
{
    
    [self.segmentedControlGender setTitle:NSLocalizedString(@"male", nil) forSegmentAtIndex:0];
    [self.segmentedControlGender setTitle:NSLocalizedString(@"female", nil) forSegmentAtIndex:1];
    
    [self.textFieldDisability setPlaceholder:NSLocalizedString(@"disability", nil)];
    [self.textFieldFirstName setPlaceholder:NSLocalizedString(@"first_name", nil)];
    [self.textFieldLastName setPlaceholder:NSLocalizedString(@"last_name", nil)];
    
    self.imageViewDp.layer.cornerRadius = self.imageViewDp.frame.size.width/2;
    self.imageViewDp.clipsToBounds = YES;
    self.isImageChanged = 0;
    [self.textFieldEmail setEnabled:NO];
    [self.textFieldUsername setEnabled:NO];
    Profile *modal = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    [self.textFieldEmail setText:modal.profileEmail];
    [self.textFieldFirstName setText:modal.profileFirstName];
    [self.textFieldLastName setText:modal.profileLastName];
    [self.textFieldUsername setText:modal.profileUserName];
    [self.textFieldDisability setText:modal.profileDisability];
    [self.textFieldCode setText:modal.profileCode];
    [self.btnDonb setTitle:modal.profileDOB forState:UIControlStateNormal];
    
    [self.imageViewDp sd_setImageWithURL:[NSURL URLWithString:modal.profileImageFullLink]];
    if([modal.profileGender isEqualToString:@"male"])
    {
        [self.segmentedControlGender setSelectedSegmentIndex:0];
    }
    else
    {
        [self.segmentedControlGender setSelectedSegmentIndex:1];
    }
    
    
    //Setting deleagte
    [self.textFieldEmail setDelegate:self];
    [self.textFieldFirstName setDelegate:self];
    [self.textFieldLastName setDelegate:self];
    [self.textFieldUsername setDelegate:self];
    [self.textFieldDisability setDelegate:self];
    
    self.stringDob = modal.profileDOB;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-mm-dd"];
    NSDate *date = [dateFormatter dateFromString:modal.profileDOB];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"mm/dd/yyyy"];
    NSString *strDob = [dateFormatter1 stringFromDate:date];
    [self.btnDonb setTitle:strDob forState:UIControlStateNormal];
    
}

-(NSDictionary *)formatDataBeforeSending1
{
    // apnid, old_image(old_image is the file name of previous image)
    
    
    NSMutableDictionary *formattedDict = [NSMutableDictionary new];
    //[formattedDict setObject:[dictUser valueForKey:@"id"] forKey:@"apn_id"];
    [formattedDict setObject:[Profile getCurrentProfileUserId] forKey:@"user_id"];
    [formattedDict setObject:[self.textFieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"email"];
    [formattedDict setObject:[self.textFieldUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"username"];
    
    
    [formattedDict setObject:[self.textFieldFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"firstname"];
    [formattedDict setObject:self.textFieldLastName.text forKey:@"lastname"];
    [formattedDict setObject:[self.textFieldDisability.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]  forKey:@"disability"];
    [formattedDict setObject:(self.segmentedControlGender.selectedSegmentIndex == 0? @"m" : @"f") forKey:@"gender"];
    [formattedDict setObject:self.stringDob forKey:@"dob"];
    LOcationUpdater *locMan = [LOcationUpdater sharedManager];
    CLLocation *cords = locMan.currentLoc;
    [formattedDict setObject:[NSString stringWithFormat:@"%f",cords.coordinate.latitude] forKey:@"latitude"];
    [formattedDict setObject:[NSString stringWithFormat:@"%f",cords.coordinate.longitude] forKey:@"longitude"];
    [formattedDict setObject:[self.textFieldCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"code"];
    
    if(self.isImageChanged==0)
    {
        Profile *modal = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
        [formattedDict setObject:modal.profileImageName forKey:@"old_image"];
    }
    
    
    return formattedDict;
}

#pragma mark -
#pragma mark - validation
-(NSString *)validateForm
{
    NSString *msg ;
    if ([[self.textFieldFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]  == 0)
        msg = @"Please enter first name" ;
    
    else if ([[self.textFieldFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]  == 0)
        msg = @"Please enter last name" ;
    
    
    
    return msg;
    
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
        self.isImageChanged = 2;
        [self.imageViewDp setImage:[UIImage imageNamed:@"ic_dp_small"]];
    }
    
    
    
}

#pragma mark -
#pragma mark - ButtonActions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionDpChange:(id)sender {
    UIActionSheet *Sheet = [[UIActionSheet alloc] initWithTitle:@"Select Picture from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera" , @"Photo Library",@"Remove Photo", nil];
    [Sheet showInView:self.view];
    
}
- (IBAction)actionUpdateInfo:(id)sender {
    NSString *stringError = [self validateForm];
    
    if(stringError==nil)
    {
        self.btnUpdateInfo.enabled = NO;
        [self setUpLoaderView];
        NSData *imageData;
        if(self.isImageChanged==1)
        {
            imageData = UIImageJPEGRepresentation(self.imageViewDp.image, 1);
        }
        
        [iOSRequest uploadData:[NSString stringWithFormat:KEditProfile,KbaseUrl] parameters:[self formatDataBeforeSending1] imageData:imageData success:^(NSDictionary *responseStr) {
            LOcationUpdater *loc = [LOcationUpdater sharedManager];
            loc.imageDp = nil;
            Profile *selfProfile = [[Profile alloc] initWithAttributes:[responseStr valueForKey:@"profile"]];
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:selfProfile forKey:@"profile"];
            [self showStaticAlert:@"Success" message:@"User details successfully updated"];
            [self removeLoaderView];
            [self.navigationController popViewControllerAnimated:YES];
            self.btnUpdateInfo.enabled = YES;
        } failure:^(NSError *error) {
            [self removeLoaderView];
            self.btnUpdateInfo.enabled = YES;
        }];
    }
    else
    {
        [self showStaticAlert:@"Error" message:stringError];
    }
}

- (IBAction)actionDob:(id)sender {
    [self openDateSelectionController];
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
        [self.btnDonb setTitle:dateString forState:UIControlStateNormal];
        
        NSDateFormatter *formatterDate1 = [[NSDateFormatter alloc] init];
        formatterDate1.dateFormat = @"yyyy-MM-dd";
        self.stringDob = [formatterDate1 stringFromDate:date];
        [self.btnDonb setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-mm-dd"];
        NSDate *date = [dateFormatter dateFromString:self.stringDob];
        
        
        
        
        //Create date selection view controller
        RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleDefault selectAction:selectAction andCancelAction:cancelAction];
        dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
        dateSelectionController.datePicker.date = date;
        
        NSDate *today = [NSDate date];
        dateSelectionController.datePicker.maximumDate = today;
        dateSelectionController.title =  NSLocalizedString(@"select_dob", nil);
        
        //Now just present the date selection controller using the standard iOS presentation method
        [self presentViewController:dateSelectionController animated:YES completion:nil];
    }
    @catch (NSException *exception) {
        
        //Create date selection view controller
        RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleDefault selectAction:selectAction andCancelAction:cancelAction];
        dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
        
        NSDate *today = [NSDate date];
        dateSelectionController.datePicker.maximumDate = today;
        dateSelectionController.title =  NSLocalizedString(@"select_dob", nil);
        
        //Now just present the date selection controller using the standard iOS presentation method
        [self presentViewController:dateSelectionController animated:YES completion:nil];

    }
    
    
    
    
    
    

}

#pragma mark -
#pragma mark - Image picker controller
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    chosenImage = [chosenImage imageByScalingAndCroppingForSize:chosenImage.size];
    self.imageViewDp.image = chosenImage;
    self.isImageChanged = 1;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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
