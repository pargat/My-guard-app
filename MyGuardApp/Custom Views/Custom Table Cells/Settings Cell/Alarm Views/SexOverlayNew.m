//
//  SexOverlayNew.m
//  MyGuardApp
//
//  Created by vishnu on 29/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SexOverlayNew.h"

@implementation SexOverlayNew

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SexOverlayNew" owner:self options:nil] lastObject];
        self.viewOverlay.layer.cornerRadius = 8.0;
        self.viewOverlay.clipsToBounds = YES;
    }
    [self localizeFun];
    return self;
}

-(void)startOverlayAnimation
{

    NSArray *animationArray=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"alarm_ringing_01.png"],
                             [UIImage imageNamed:@"alarm_ringing_02.png"],
                             [UIImage imageNamed:@"alarm_ringing_03.png"],
                             nil];
    self.imageViewSex.animationImages=animationArray;
    self.imageViewSex.animationDuration=0.16;
    self.imageViewSex.animationRepeatCount=0;
    [self.imageViewSex startAnimating];
}
-(void)localizeFun
{
    [self.labelSexDesci setText:NSLocalizedString(@"sex_alert_description", nil)];
    [self.btnDontTrack setTitle:NSLocalizedString(@"countdown_notify", nil) forState:UIControlStateNormal];
    [self.btnVieOfender setTitle:NSLocalizedString(@"view_offender", nil) forState:UIControlStateNormal];
    [self.btnDontTrack setTitle:NSLocalizedString(@"dont_track", nil) forState:UIControlStateNormal];
    [self.btnHush setTitle:NSLocalizedString(@"hush", nil) forState:UIControlStateNormal];
    [self startOverlayAnimation];
    [self playAlarm];
}
-(void)stopOverlayAnimation
{
    
    [self.imageViewSex stopAnimating];
    self.imageViewSex = nil ;
}

-(void)playAlarm
{
    NSURL *yourMusicFile;
            yourMusicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"SexOffender" ofType:@"mp3"]];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&setCategoryError]) {
        // handle error
    }
    
    
    
    
    NSError *error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:yourMusicFile error:&error];
    
    self.audioPlayer.numberOfLoops = -1;
    self.audioPlayer.volume = 1.0;
    [self.audioPlayer play];
    
}

#pragma mark - 
#pragma mark - button actions

- (IBAction)actionViewOffender:(id)sender {
    [self shutAudio];
    [self presentSexOffender];
}

- (IBAction)actionHush:(id)sender {
    [self shutAudio];
}

- (IBAction)actionDonttrack:(id)sender {
    [self shutAudio];
     [[NSUserDefaults standardUserDefaults] rm_setCustomObject:nil forKey:@"sex_list"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sex_permission"];
}
-(void)shutAudio
{
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    [self removeFromSuperview];

}
-(void)presentSexOffender
{
    UIViewController *vc = [CommonFunctions currentViewController];
    UIViewController *currentIterated = vc;
    for (int i =0; i>=0; i++) {
        if([currentIterated isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *nav = (UINavigationController *)currentIterated;
            [nav popToRootViewControllerAnimated:YES];
            [nav.tabBarController setSelectedIndex:4];
            [nav.tabBarController.tabBar setHidden:NO];
            return;
        }
        else
        {
            currentIterated = currentIterated.parentViewController;
        }
    }
}
@end
