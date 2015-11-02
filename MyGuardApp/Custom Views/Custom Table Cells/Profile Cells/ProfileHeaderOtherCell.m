//
//  ProfileHeaderOtherCell.m
//  MyGuardApp
//
//  Created by vishnu on 15/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "ProfileHeaderOtherCell.h"

@implementation ProfileHeaderOtherCell

- (void)awakeFromNib {
    // Initialization code
    self.imageViewDp.layer.cornerRadius = self.imageViewDp.frame.size.width/2;
    self.imageViewDp.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionDpBig:(id)sender {
    ImageBigView *img = [[ImageBigView alloc] init];
    [img setFrame:[[UIScreen mainScreen] bounds]];
    [img setImage:[NSURL URLWithString:self.stringUrl]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:img];

}
@end
