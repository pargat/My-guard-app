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


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionCall:(id)sender {
}
@end
