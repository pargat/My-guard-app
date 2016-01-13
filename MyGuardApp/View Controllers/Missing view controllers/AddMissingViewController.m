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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - View helper functions and date picker related functions

- (void)openDateSelectionController
{
    [self.view endEditing:YES];
    //Create select action
    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        
        
        NSLog(@"Successfully selected date: %@", ((UIDatePicker *)controller.contentView).date);
        NSDate *date = ((UIDatePicker *)controller.contentView).date;
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
    
    
    
    
    
    
    dateSelectionController.title =  NSLocalizedString(@"missing_since", nil);
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}
#pragma mark -
#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [self.btnAddPicture setImage:[chosenImage imageByScalingAndCroppingForSize:chosenImage.size] forState:UIControlStateNormal];
 
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

#pragma mark -
#pragma mark - Button Actions
- (IBAction)actionAddPicture:(id)sender {
    UIActionSheet *Sheet = [[UIActionSheet alloc] initWithTitle:@"Select Picture from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera" , @"Photo Library", nil];
    [Sheet showInView:self.view];

}

- (IBAction)actionDatePicker:(id)sender {
}
@end
