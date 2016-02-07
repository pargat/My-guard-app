//
//  AddMissingViewController.h
//  MyGuardApp
//
//  Created by vishnu on 13/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Extras.h"
#import <SZTextView.h>
#import "BaseViewController.h"
#import "Profile.h"
#import "LOcationUpdater.h"

@interface AddMissingViewController : BaseViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@property BOOL imageSelected;
@property (nonatomic,strong) NSDate *dateM;
@property (weak, nonatomic) IBOutlet UILabel *labelTapToadd;
@property (weak, nonatomic) IBOutlet UITextField *tfname;
@property (weak, nonatomic) IBOutlet UITextField *tfLastSeen;
@property (weak, nonatomic) IBOutlet UITextField *tfContact;
@property (weak, nonatomic) IBOutlet UITextField *tfMissingSince;
@property (weak, nonatomic) IBOutlet SZTextView *tvDescription;
@property (weak, nonatomic) IBOutlet UITextField *tfAge;
@property (weak, nonatomic) IBOutlet UITextField *tfHeight;
@property (weak, nonatomic) IBOutlet UITextField *tfHairColor;
@property (weak, nonatomic) IBOutlet UITextField *tfEyeColor;
@property(nonatomic,strong) NSString *strDate;
@property (weak, nonatomic) IBOutlet UIButton *btnAddPicture;
- (IBAction)actionAddPicture:(id)sender;
- (IBAction)actionDatePicker:(id)sender;

@end
