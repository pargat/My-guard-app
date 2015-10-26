//
//  RegisterStep2ViewController.h
//  MyGuardApp
//
//  Created by vishnu on 16/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RMDateSelectionViewController.h>
#import "BaseViewController.h"
#import "LOcationUpdater.h"

@interface RegisterStep2ViewController : BaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSDictionary *dictFb;
@property BOOL isImageSelected;
@property (nonatomic,strong) NSString *stringDob;
@property(nonatomic,strong) NSString *stringEmail;
@property (nonatomic,strong) NSString *stringPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDp;

@property (weak, nonatomic) IBOutlet UILabel *labelTapToadd;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlGender;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTypeOFDisability;
@property (weak, nonatomic) IBOutlet UIButton *btnDob;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCode;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewObj;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUser;

- (IBAction)actionDob:(id)sender;
- (IBAction)actionDp:(id)sender;
- (IBAction)actionSignup:(id)sender;

@end
