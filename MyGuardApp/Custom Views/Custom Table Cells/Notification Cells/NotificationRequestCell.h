//
//  NotificationRequestCell.h
//  MyGuardApp
//
//  Created by vishnu on 28/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDp;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIView *viewOverlauy;
@property (weak, nonatomic) IBOutlet UILabel *labelTimePassed;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;
- (IBAction)actionReject:(id)sender;
- (IBAction)actionAccept:(id)sender;

@end
