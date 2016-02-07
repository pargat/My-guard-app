//
//  AddMissingViewController.m
//  MyGuardApp
//
//  Created by vishnu on 13/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import "AddMissingViewController.h"
#import <RMDateSelectionViewController.h>
#import <RMPickerViewController.h>

@interface AddMissingViewController ()

@end

@implementation AddMissingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setNavBar];
    [self viewHelper];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeLoaderView];
}
#pragma mark -
#pragma mark - View helper functions and date picker related functions
-(NSString *)validation
{
    NSString *stringVal;
    if(self.imageSelected==NO)
    {
        stringVal = @"Please select image";
    }
    else if ([self.tfname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0)
    {
        stringVal = @"Please enter name of the person";
    }
    else if ([self.tfAge.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0)
    {
        stringVal = @"Please enter age of the person";
    }
    else if ([self.tfHeight.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0)
    {
        stringVal = @"Please enter height of the person";
    }
    else if ([self.tfHairColor.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0)
    {
        stringVal = @"Please enter hair color of the person";
    }
    else if ([self.tfEyeColor.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0)
    {
        stringVal = @"Please enter eye color of the person";
    }
    else if ([self.tfLastSeen.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0)
    {
        stringVal = @"Please enter where you last seen this person";
    }
    else if ([self.tfMissingSince.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0)
    {
        stringVal = @"Please enter date and time when you last seen him";
    }
    
    
    return stringVal;
    
}
-(void)viewHelper
{
    self.btnAddPicture.layer.cornerRadius = self.btnAddPicture.frame.size.width/2;
    self.btnAddPicture.clipsToBounds = YES;
    
    [self.labelTapToadd setText:NSLocalizedString(@"tap_to_add", nil)];
    [self.tfContact setPlaceholder:NSLocalizedString(@"contact_missing", nil)];
    [self.tfLastSeen setPlaceholder:NSLocalizedString(@"last_seen_at", nil)];
    [self.tfMissingSince setPlaceholder:NSLocalizedString(@"missing_since", nil)];
    [self.tfname setPlaceholder:NSLocalizedString(@"full_name", nil)];
    [self.tvDescription setPlaceholder:NSLocalizedString(@"description_missing", nil)];
    [self.tfAge setPlaceholder:NSLocalizedString(@"missing_age", nil)];
    [self.tfHairColor setPlaceholder:NSLocalizedString(@"missing_hair_color", nil)];
    [self.tfHeight setPlaceholder:NSLocalizedString(@"missing_height", nil)];
    [self.tfEyeColor setPlaceholder:NSLocalizedString(@"missing_eye_color", nil)];
    self.tvDescription.delegate = self;
    
}
-(void)setNavBar
{
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    self.navigationItem.title = NSLocalizedString(@"post_a_missing", nil);
    
    
    UIBarButtonItem *btnPost = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"post", nil) style:UIBarButtonItemStylePlain target:self action:@selector(actionPost)];
    [btnPost setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = btnPost;
    
}
- (void)openDateSelectionController
{
    [self.view endEditing:YES];
    //Create select action
    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        
        
        NSLog(@"Successfully selected date: %@", ((UIDatePicker *)controller.contentView).date);
        NSDate *date = ((UIDatePicker *)controller.contentView).date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM dd, YYYY hh:mm a"];
        [self.tfMissingSince setText:[dateFormatter stringFromDate:date]];
        self.dateM = date;
        
        NSDateFormatter *formatterDate1 = [[NSDateFormatter alloc] init];
        formatterDate1.dateFormat = @"yyyy-MM-dd";
        self.strDate = [formatterDate1 stringFromDate:date];

    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    //Create date selection view controller
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleDefault selectAction:selectAction andCancelAction:cancelAction];
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    
    NSDate *today = [NSDate date];
    dateSelectionController.datePicker.maximumDate = today;
    
    if(self.dateM!=nil)
        dateSelectionController.datePicker.date = self.dateM;
    
    
    
    
    dateSelectionController.title =  NSLocalizedString(@"missing_since", nil);
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}
#pragma mark -
#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageSelected = YES;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self.btnAddPicture setImage:[chosenImage imageByScalingAndCroppingForSize:chosenImage.size] forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
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
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    }
    else if (buttonIndex==1)
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    }
    
    
    
}

#pragma mark -
#pragma mark - text view delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(self.tvDescription.text.length>=300)
    {
        return NO;
    }
    return YES;
}
#pragma mark -
#pragma mark - Button Actions
-(void)actionPost
{
    NSString *valString = [self validation];
    
    if(valString==nil)
    {
        Profile *profile = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
        LOcationUpdater *loc = [LOcationUpdater sharedManager];
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self setUpLoaderView];
        
        NSData *data = UIImageJPEGRepresentation([self.btnAddPicture imageForState:UIControlStateNormal], 0.5);
        [iOSRequest uploadData:[NSString stringWithFormat:KAddMissing,KbaseUrl] parameters:@{@"user_id":profile.profileUserId,@"name":[self.tfname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@"location":[self.tfLastSeen.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@"description":[self.tvDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@"latitude":[NSString stringWithFormat: @"%f",loc.currentLoc.coordinate.latitude ],@"longitude":[NSString stringWithFormat: @"%f",loc.currentLoc.coordinate.longitude],@"date":self.strDate,@"phone":self.tfContact.text,@"last_seen_on":self.tfMissingSince.text,@"age":[self.tfAge.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@"height":[self.tfHeight.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@"hair":[self.tfHairColor.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@"eye":[self.tfEyeColor.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]} imageData:data success:^(NSDictionary *responseStr) {
            [self removeLoaderView];
            [self.navigationController popViewControllerAnimated:YES];
            [self showStaticAlert:@"Success" message:@"Missing person is added !"];

        } failure:^(NSError *error) {
            [self removeLoaderView];
            [self showStaticAlert:@"Error" message:error.localizedDescription];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }];
    }
    else
    {
        [self showStaticAlert:@"Error" message:valString];
    }
    
    
}
- (IBAction)actionAddPicture:(id)sender {
    [self.view endEditing:YES];
    UIActionSheet *Sheet = [[UIActionSheet alloc] initWithTitle:@"Select Picture from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera" , @"Photo Library", nil];
    [Sheet showInView:self.view];
    
}

- (IBAction)actionDatePicker:(id)sender {
    [self openDateSelectionController];
}
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
