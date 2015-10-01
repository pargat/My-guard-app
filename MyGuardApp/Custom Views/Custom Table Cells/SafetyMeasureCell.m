//
//  SafetyMeasureCell.m
//  MyGuardApp
//
//  Created by vishnu on 18/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "SafetyMeasureCell.h"

@implementation SafetyMeasureCell

- (void)awakeFromNib {
    // Initialization code
    self.imageViewDp.layer.cornerRadius = self.imageViewDp.frame.size.width/2;
    self.imageViewDp.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
