//
//  ProfileHeaderOtherCell.h
//  MyGuardApp
//
//  Created by vishnu on 15/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageBigView.h"

@protocol ProfileOtherDelegate <NSObject>

-(void)delBigView;

@end


@interface ProfileHeaderOtherCell : UITableViewCell

@property (nonatomic,strong) id<ProfileOtherDelegate> delegate;
@property (nonatomic,strong) NSString *stringUrl;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDp;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UIView *viewBottomLine;
- (IBAction)actionDpBig:(id)sender;

@end
