//
//  NotificationRequestCell.m
//  MyGuardApp
//
//  Created by vishnu on 28/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "NotificationRequestCell.h"

@implementation NotificationRequestCell

- (void)awakeFromNib {
    // Initialization code
    self.imageViewDp.layer.cornerRadius = self.imageViewDp.frame.size.width/2;
    self.imageViewDp.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionReject:(id)sender {
    [self.delegate delAcceptOrReject:false atIndexPath:self.selectedIndex];
}

- (IBAction)actionAccept:(id)sender {
    [self.delegate delAcceptOrReject:true atIndexPath:self.selectedIndex];
}
@end
