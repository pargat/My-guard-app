//
//  SexOverlay.m
//  MyGuardApp
//
//  Created by vishnu on 29/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SexOverlay.h"

@implementation SexOverlay

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SexOverlay" owner:self options:nil] lastObject];
    }
    
    
    return self;
    
}

- (IBAction)actionHush:(id)sender {
}
@end
