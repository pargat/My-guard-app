//
//  WalkThroughLastView.m
//  MyGuardApp
//
//  Created by vishnu on 15/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "WalkThroughLastView.h"

@implementation WalkThroughLastView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"WalkThroughLastView" owner:self options:nil] lastObject];
        [self setFrame:frame];
        [self setBackgroundColor:KPurpleColor];
        //[self initializeUI];
    }
    
    
    return self;
    
}
-(void)setterText
{
    [self.labelWTAlarmTitle setText:NSLocalizedString(@"wt_alarm_title", nil)];
    [self.labelWTEmergencyTitle setText:NSLocalizedString(@"wt_emergency_title", nil)];
    [self.labelWTQuickTitle setText:NSLocalizedString(@"wt_quick_title", nil)];
    [self.labelWTAlarmDescription setText:NSLocalizedString(@"wt_alarm_desc", nil)];
    [self.labelWTEmergencyDescription setText:NSLocalizedString(@"wt_emergency_desc", nil)];
    [self.labelWTQuickDescription setText:NSLocalizedString(@"wt_quick_desc", nil)];

}

@end
