//
//  CommunityCell.m
//  MyGuardApp
//
//  Created by vishnu on 21/09/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "CommunityCell.h"

@implementation CommunityCell

- (void)awakeFromNib {
    // Initialization code
    self.imageViewDp.layer.cornerRadius = self.imageViewDp.frame.size.width/2;
    self.imageViewDp.clipsToBounds = YES;
}

@end
