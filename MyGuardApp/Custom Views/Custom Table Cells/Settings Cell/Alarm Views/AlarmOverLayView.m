//
//  AlarmOverLayView.m
//  FireSonar
//
//  Created by Gagan on 13/01/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import "AlarmOverLayView.h"

@implementation AlarmOverLayView


-(void)layoutSubviews
{
      self.frame = CGRectMake(0, 0, [[UIApplication sharedApplication] keyWindow].frame.size.width, [[UIApplication sharedApplication] keyWindow].frame.size.height );
    
    [super layoutSubviews];
}

-(instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AlarmOverLayView" owner:self options:nil] lastObject];
        //[self initializeUI];
        self.overlay_backgroundView.layer.cornerRadius = 8.0;
        [self.overlay_backgroundView setClipsToBounds:YES];
        [self localizeUI];
    }
    
    
    return self;

}
-(void)localizeUI
{
    [self.labelRaining setText:NSLocalizedString(@"raising", nil)];
    [self.buttonCancel setTitle:NSLocalizedString(@"cancel_alert_now",nil ) forState:UIControlStateNormal];
    [self.buttonSend setTitle:NSLocalizedString(@"send_alert_now",nil ) forState:UIControlStateNormal];
    
    
    CALayer *layer = self.overlay_backgroundView.layer;
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = -1.0;
    layer.transform = rotationAndPerspectiveTransform;

}

-(void)viewColorSetter
{
    if(self.currentTab==FIRE)
    {
        [self.overlay_backgroundView setBackgroundColor:KOrangeColor];
        [self.buttonSend setTitleColor:KOrangeColor forState:UIControlStateNormal];
        [self.labelRaisingAlarm setText:NSLocalizedString(@"fire_alarm", nil)];
    }
    else if (self.currentTab == GUN)
    {
        [self.overlay_backgroundView setBackgroundColor:KRedColor];
        [self.buttonSend setTitleColor:KRedColor forState:UIControlStateNormal];
        [self.labelRaisingAlarm setText:NSLocalizedString(@"gun_alarm", nil)];
    }
    else
    {
        [self.overlay_backgroundView setBackgroundColor:KGreenColor];
        [self.buttonSend setTitleColor:KGreenColor forState:UIControlStateNormal];
        [self.labelRaisingAlarm setText:NSLocalizedString(@"co_alarm", nil)];
    }

}
- (IBAction)actionSendImmidiate:(id)sender {
    [self.delegate delegateSendImmediate:self.currentTab];
}

- (IBAction)cancelAct:(id)sender
{
    [self.delegate disarmClicked];
}


@end
