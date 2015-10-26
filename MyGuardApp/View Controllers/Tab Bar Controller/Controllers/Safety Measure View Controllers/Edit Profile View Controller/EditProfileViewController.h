//
//  EditProfileViewController.h
//  MyGuardApp
//
//  Created by vishnu on 20/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "Profile.h"
#import <UIImageView+WebCache.h>
#import <RMDateSelectionViewController.h>
#import "BaseViewController.h"
#import "LOcationUpdater.h"


@interface EditProfileViewController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property int isImageChanged;
@property (nonatomic,strong) NSString *stringDob;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewObj;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDp;
@property (weak, nonatomic) IBOutlet UILabel *labelTapToEdit;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlGender;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDisability;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnDonb;

- (IBAction)actionUpdateInfo:(id)sender;
- (IBAction)actionDob:(id)sender;
- (IBAction)actionDpChange:(id)sender;

@end
