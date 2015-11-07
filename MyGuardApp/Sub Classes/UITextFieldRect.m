//
//  UITextFieldRect.m
//  MyGuardApp
//
//  Created by vishnu on 07/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "UITextFieldRect.h"

@implementation UITextFieldRect

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

@end
