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
    }
    [self localizeFun];
    return self;
}

-(void)startOverlayAnimation
{
    NSArray *animationArray=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"animate_00.png"],
                             [UIImage imageNamed:@"animate_01.png"],
                             [UIImage imageNamed:@"animate_02.png"],
                             [UIImage imageNamed:@"animate_03.png"],
                             [UIImage imageNamed:@"animate_04.png"],
                             nil];
    self.overlay_AnimationImg.animationImages=animationArray;
    self.overlay_AnimationImg.animationDuration=1.5;
    self.overlay_AnimationImg.animationRepeatCount=0;
    [self.overlay_AnimationImg startAnimating];
}
-(void)localizeFun
{
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
    NSLog(@"cool");
}

#pragma mark -
#pragma mark - alert view delegate functions
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [self.delegate waveAnimationTurnOff];

        NSDictionary *userDetails = [[NSUserDefaults standardUserDefaults] valueForKey:@"userDetails"];
        NSString *stringFalseAlarm = [NSString stringWithFormat:@"%@cancel_last_alarm.php?user_id=%@",KbaseUrl,[userDetails valueForKey:@"id"]];
        
        [iOSRequest getJsonResponse:stringFalseAlarm success:^(NSDictionary *responseDict) {
            
            
        } failure:^(NSString *errorString) {
            
        }];
        
    }
}
@end
