//
//  AddMissingViewController.h
//  MyGuardApp
//
//  Created by vishnu on 13/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Extras.h"

@interface AddMissingViewController : UIViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelTapToadd;
@property (weak, nonatomic) IBOutlet UITextField *tfname;
@property (weak, nonatomic) IBOutlet UITextField *tfLastSeen;
@property (weak, nonatomic) IBOutlet UITextField *tfContact;
@property (weak, nonatomic) IBOutlet UITextField *tfMissingSince;

@property (weak, nonatomic) IBOutlet UITextView *tvDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnAddPicture;
- (IBAction)actionAddPicture:(id)sender;
- (IBAction)actionDatePicker:(id)sender;

@end
