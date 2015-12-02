//
//  SettingSwitchCell.h
//  MyGuardApp
//
//  Created by vishnu on 24/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"

@interface SettingSwitchCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UISwitch *switchVideo;
- (IBAction)actionVideoPermissionChanged:(id)sender;

@end
