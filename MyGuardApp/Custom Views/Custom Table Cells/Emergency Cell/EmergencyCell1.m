//
//  EmergencyCell1.m
//  MyGuardApp
//
//  Created by vishnu on 13/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "EmergencyCell1.h"

@implementation EmergencyCell1

- (void)awakeFromNib {
    // Initialization code
    [self.btnCall911 setTitle:NSLocalizedString(@"call_911", nil) forState:UIControlStateNormal];
    [self.btnSms setTitle:NSLocalizedString(@"sms", nil) forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionSms:(id)sender {
    [self.delegate delSms];
}
- (IBAction)actionCall911:(id)sender {
    [self.delegate delCall911];
}
@end
