//
//  MissingCommunityCell.m
//  MyGuardApp
//
//  Created by vishnu on 13/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import "MissingCommunityCell.h"

@implementation MissingCommunityCell

- (void)awakeFromNib {
    // Initialization code
    
    self.labelNameP.text = NSLocalizedString(@"full_name", nil);
    self.labelMissingSInceP.text = NSLocalizedString(@"missing_since", nil);
    self.labelLastP.text = NSLocalizedString(@"last_seen_at", nil);
    self.labelAgeP.text = NSLocalizedString(@"missing_age", nil);

    self.labelHeightP.text = NSLocalizedString(@"missing_height", nil);

    self.labelHairP.text = NSLocalizedString(@"missing_hair_color", nil);

    self.labelEyeP.text = NSLocalizedString(@"missing_eye_color", nil);

    self.btnCall.layer.cornerRadius = 4.0;
    self.btnCall.layer.borderColor = KPurpleColor.CGColor;
    self.btnCall.layer.borderWidth = 1;

    self.imageViewPerson.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionCall:(id)sender {
    [self callContact:self.stringPhone];
}

-(void)callContact : (NSString *)phoneNo
{
    
    
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phoneNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        [self showAlert:@"Call facility is not available"];
    }
    
    
}
-(void) showAlert:(NSString *)message
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    
}


@end
