//
//  WalkThroughView.m
//  MyGuardApp
//
//  Created by vishnu on 14/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "WalkThroughView.h"

@implementation WalkThroughView

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"WalkThroughView" owner:self options:nil] lastObject];
        [self setFrame:frame];
        //[self initializeUI];
    }
    
    
    return self;
    
}
-(void)setUpWalk:(NSString *)title desc:(NSString *)description imageName:(NSString *)name
{
    [self.labelDescription setText:description];
    [self.labelTitle setText:title];
    [self.imageViewWalk setImage:[UIImage imageNamed:name]];
}
//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    [self setFrame:self.frame];
//}
@end
