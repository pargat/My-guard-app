//
//  ProfileHeaderMyCell.h
//  MyGuardApp
//
//  Created by vishnu on 23/09/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageBigView.h"
#import "Profile.h"

@interface ProfileHeaderMyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDp;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UIView *viewBottomLine;

- (IBAction)actionDpFull:(id)sender;
- (IBAction)actionSettings:(id)sender;

@end
