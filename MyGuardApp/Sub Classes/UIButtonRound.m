//
//  UIButtonRound.m
//  MyGuardApp
//
//  Created by vishnu on 05/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "UIButtonRound.h"

@implementation UIButtonRound

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.cornerRadius = self.frame.size.height/2;
    self.clipsToBounds = YES;
}


@end
