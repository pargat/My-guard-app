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

@protocol ProfileMyDelegate <NSObject>

-(void)delBigView;

@end

@interface ProfileHeaderMyCell : UITableViewCell

@property (nonatomic,strong) id<ProfileMyDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDp;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UIView *viewBottomLine;
@property (weak, nonatomic) IBOutlet UIButton *btnNotif;

- (IBAction)actionDpFull:(id)sender;
- (IBAction)actionSettings:(id)sender;

@end
