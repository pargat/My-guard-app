//
//  SettingSwitchCell.m
//  MyGuardApp
//
//  Created by vishnu on 24/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SettingSwitchCell.h"

@implementation SettingSwitchCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionVideoPermissionChanged:(UISwitch *)sender {
        [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"video_permission"];
}
@end
