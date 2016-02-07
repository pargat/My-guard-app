//
//  ProfileSelectionCell.m
//  MyGuardApp
//
//  Created by vishnu on 25/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import "ProfileSelectionCell.h"

@implementation ProfileSelectionCell

- (void)awakeFromNib {
    // Initialization code
    [self.segmentedControl setTitle:NSLocalizedString(@"safety_measures", nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedString(@"missing_people", nil) forSegmentAtIndex:1];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionSegmented:(id)sender {
    if(self.segmentedControl.selectedSegmentIndex ==0)
        [self.delegate delSelected:YES];
    else
        [self.delegate delSelected:NO];
}
@end
