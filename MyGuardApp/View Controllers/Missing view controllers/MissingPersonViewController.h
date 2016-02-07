//
//  MissingPersonViewController.h
//  MyGuardApp
//
//  Created by vishnu on 13/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Colors.h"
#import "ApiConstants.h"
#import "iOSRequest.h"
#import "BaseViewController.h"
#import "MissingModal.h"
#import <UIImageView+WebCache.h>

@interface MissingPersonViewController : BaseViewController


@property (nonatomic,strong) MissingModal *missingModal;
@property (nonatomic,strong) NSString *missingId;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPerson;
@property (weak, nonatomic) IBOutlet UILabel *labelNameP;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelMissingSInceP;
@property (weak, nonatomic) IBOutlet UILabel *labelMissingSince;
@property (weak, nonatomic) IBOutlet UILabel *labelLastP;
@property (weak, nonatomic) IBOutlet UILabel *labelLast;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelAgeP;
@property (weak, nonatomic) IBOutlet UILabel *labelAge;
@property (weak, nonatomic) IBOutlet UILabel *labelHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelHeightP;
@property (weak, nonatomic) IBOutlet UILabel *labelEye;
@property (weak, nonatomic) IBOutlet UILabel *labelHair;
@property (weak, nonatomic) IBOutlet UILabel *labelHairP;
@property (weak, nonatomic) IBOutlet UILabel *labelEyeP;

- (IBAction)actionCall:(id)sender;

@end
