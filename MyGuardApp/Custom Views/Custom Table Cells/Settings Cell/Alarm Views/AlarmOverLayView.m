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
        [self localizeUI];
    }
    
    
    return self;

}
-(void)localizeUI
{
    [self.buttonCancel setTitle:NSLocalizedString(@"cancel_alert_now",nil ) forState:UIControlStateNormal];
    [self.buttonSend setTitle:NSLocalizedString(@"send_alert_now",nil ) forState:UIControlStateNormal];
    [self.buttonNotifyEmergency setTitle:NSLocalizedString(@"countdown_notify", nil) forState:UIControlStateNormal];
    [self.labelHelp setText:NSLocalizedString(@"help_danger", nil)];
    
    [self.buttonNotifyEmergency setHidden:YES];
    
}

- (IBAction)actionSendImmidiate:(id)sender {
    [self.delegate delegateSendImmediate];
}

- (IBAction)cancelAct:(id)sender
{
    [self.delegate disarmClicked];
}

- (IBAction)notifyEmergencyContacts:(id)sender
{
    [self.delegate emergencyContactClicked];
}
@end
