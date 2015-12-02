//
//  WaveAnimationView.m
//  FireSonar
//
//  Created by Gagan on 22/01/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import "WaveAnimationView.h"

@implementation WaveAnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
        self = [[[NSBundle mainBundle] loadNibNamed:@"WaveAnimationView" owner:self options:nil] lastObject];
        self.overlay_background.layer.cornerRadius = 8.0;
        self.overlay_background.clipsToBounds = YES;
    }
    [self localizeFun];
    return self;
}

-(void)startOverlayAnimation
{
    if(self.currentTab==FIRE)
    {
        [self.overlay_background setBackgroundColor:KOrangeColor];
        [self.btnHush setTitleColor:KOrangeColor forState:UIControlStateNormal];
    }
    else if (self.currentTab==GUN)
    {
        [self.overlay_background setBackgroundColor:KRedColor];
          [self.btnHush setTitleColor:KRedColor forState:UIControlStateNormal];
    }
    else
    {
         [self.btnHush setTitleColor:KGreenColor forState:UIControlStateNormal];
        [self.overlay_background setBackgroundColor:KGreenColor];
    }
    NSArray *animationArray=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"alarm_ringing_01.png"],
                             [UIImage imageNamed:@"alarm_ringing_02.png"],
                             [UIImage imageNamed:@"alarm_ringing_03.png"],
                             nil];
    self.overlay_AnimationImg.animationImages=animationArray;
    self.overlay_AnimationImg.animationDuration=0.16;
    self.overlay_AnimationImg.animationRepeatCount=0;
    [self.overlay_AnimationImg startAnimating];
}
-(void)localizeFun
{
    [self.labelAlarmRaised setText:NSLocalizedString(@"alarm_raised", nil)];
    [self.btnNotify setTitle:NSLocalizedString(@"countdown_notify", nil) forState:UIControlStateNormal];
    [self.btnFalseAlarm setTitle:NSLocalizedString(@"false_alarm", nil) forState:UIControlStateNormal];
}
-(void)stopOverlayAnimation
{
    
    [self.overlay_AnimationImg stopAnimating];
    self.overlay_AnimationImg = nil ;
}


#pragma mark - Actions
- (IBAction)cancelAct:(id)sender
{
    [self.delegate waveAnimationTurnOff];
}

- (IBAction)actionFalseAlarm:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"False Alarm" message:@"Are you sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertView show];
}

#pragma mark -
#pragma mark - alert view delegate functions
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [self.delegate waveAnimationTurnOff];


        NSString *stringFalseAlarm = [NSString stringWithFormat:@"%@cancel_last_alarm.php?user_id=%@",KbaseUrl,[Profile getCurrentProfileUserId]];
        
        [iOSRequest getJsonResponse:stringFalseAlarm success:^(NSDictionary *responseDict) {
            
            
        } failure:^(NSString *errorString) {
            
        }];
        
    }
}
@end
