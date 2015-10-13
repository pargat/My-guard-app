//
//  UIButtonCenter.m
//  BubblegumLane
//
//  Created by CB Labs_1 on 27/05/15.
//  Copyright (c) 2015 Savita. All rights reserved.
//

#import "UIButtonCenter.h"
@implementation UIButtonCenter


- (void)drawRect:(CGRect)rect {

    CGFloat spacing = 32;
    CGSize imageSize = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(-16.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(
                                                       - (titleSize.height), 0.0, 0.0, - titleSize.width);
    
}


@end
