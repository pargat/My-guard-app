//
//  CommunityNoCell.m
//  MyGuardApp
//
//  Created by vishnu on 21/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "CommunityNoCell.h"

@implementation CommunityNoCell

- (void)awakeFromNib {
    // Initialization code
    [self.labelNoUsers setFont:[UIFont boldSystemFontOfSize:14]];
    [self.labelNoUsers setTextColor:[UIColor lightGrayColor]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
