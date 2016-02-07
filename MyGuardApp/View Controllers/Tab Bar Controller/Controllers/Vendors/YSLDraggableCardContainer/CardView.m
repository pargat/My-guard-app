//
//  CardView.m
//  MyGuardApp
//
//  Created by vishnu on 17/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import "CardView.h"

@implementation CardView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"CardView" owner:self options:nil] lastObject];
    }
    [self setFrame:frame];
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
