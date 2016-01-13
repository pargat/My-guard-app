//
//  DemoHushViewController.m
//  MyGuardApp
//
//  Created by vishnu on 06/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "DemoHushViewController.h"

@interface DemoHushViewController ()

{
    AVAudioPlayer *audioPlayer;
    
}
@end

@implementation DemoHushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startOverlayAnimation];
    self.navigationController.navigationBarHidden = YES;
    [self playAlarm];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self disarmClicked];
}

#pragma mark - 
#pragma mark - Audio handling
-(void)playAlarm
{
    NSURL *yourMusicFile;
    if([self.type isEqualToString:@"1"])
    {
        NSString *stringType = [[NSUserDefaults standardUserDefaults] valueForKey:@"FireSound"];
        if([stringType isEqualToString:@"FireDefault.mp3"]||[[NSUserDefaults standardUserDefaults] valueForKey:@"FireSound"]==nil)
        {
            yourMusicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"FireDefault" ofType:@"mp3"]];
        }
        else
        {
            yourMusicFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Fire/%@",DOCUMENTS_FOLDER,stringType]];
        }
        
    }
    else if ([self.type isEqualToString:@"3"])
    {
        NSString *stringType = [[NSUserDefaults standardUserDefaults] valueForKey:@"GunSound"];
        if([stringType isEqualToString:@"GunDefault.mp3"]||[[NSUserDefaults standardUserDefaults] valueForKey:@"GunSound"]==nil)
        {
            yourMusicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"GunDefault" ofType:@"mp3"]];
        }
        else
        {
            yourMusicFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Gun/%@",DOCUMENTS_FOLDER,stringType]];
        }
    }
    else
    {
        NSString *stringType = [[NSUserDefaults standardUserDefaults] valueForKey:@"COSound"];
        if([stringType isEqualToString:@"CODefault.mp3"]||[[NSUserDefaults standardUserDefaults] valueForKey:@"COSound"]==nil)
        {
            yourMusicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CODefault" ofType:@"mp3"]];
        }
        else
        {
            yourMusicFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/CO/%@",DOCUMENTS_FOLDER,stringType]];
        }
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&setCategoryError]) {
        // handle error
    }
    
    
    
    
    NSError *error = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:yourMusicFile error:&error];
    
    audioPlayer.numberOfLoops = -1;
    audioPlayer.volume = 1.0;
    [audioPlayer play];
    
}

-(void)disarmClicked
{
    
    
    [audioPlayer pause];
    audioPlayer = nil;
}


#pragma mark - 
#pragma mark - View Helpers

-(void)startOverlayAnimation
{
    NSArray *animationArray=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"alarm_ringing_01.png"],
                             [UIImage imageNamed:@"alarm_ringing_02.png"],
                             [UIImage imageNamed:@"alarm_ringing_03.png"],
                             nil];
    self.imageViewAnim.animationImages=animationArray;
    self.imageViewAnim.animationDuration=0.16;
    self.imageViewAnim.animationRepeatCount=0;
    [self.imageViewAnim startAnimating];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionHush:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-3] animated:YES];
    [self.navigationController.navigationBar setHidden:NO];
}
@end
