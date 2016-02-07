//
//  Register1ViewController.h
//  MyGuardApp
//
//  Created by vishnu on 16/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "BaseViewController.h"
#import "RegisterStep2ViewController.h"


@interface Register1ViewController : BaseViewController

@property (nonatomic,strong) NSDictionary *dictFb;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelWelcome;
@property (weak, nonatomic) IBOutlet UILabel *labelFillInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UITextView *textViewTC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UIButton *btnAlreadyMember;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;


- (IBAction)actionTerms:(id)sender;
- (IBAction)actionAlreadyMember:(id)sender;
- (IBAction)actionContinue:(id)sender;


@end
