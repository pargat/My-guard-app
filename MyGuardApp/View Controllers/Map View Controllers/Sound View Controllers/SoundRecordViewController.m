//
//  SoundRecordViewController.m
//  MyGuardApp
//
//  Created by vishnu on 15/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SoundRecordViewController.h"

@interface SoundRecordViewController ()

@end

@implementation SoundRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavBar];
    [self viewHelper];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 
#pragma mark - View helpers
-(void)initialiseTimer
{
    self.counter = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(handleTimer)
                                                  userInfo:nil
                                                   repeats:YES];

}
-(void)handleTimer
{
    self.count++;
    [self.labelTime setText:[NSString stringWithFormat:@"%.2d : %.2d",self.count/60,self.count%60]];
    
}
-(void)viewHelper
{
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
 

    
    [self.viewPlot setBackgroundColor:[UIColor whiteColor]];
    [self.viewPlot setColor:KPurpleColor];
    self.viewPlot.gain = 4;
    [self.viewPlot setNumOfBins:100];
    
    self.viewTimer.layer.cornerRadius = 4.0;
    [self.viewTimer setClipsToBounds:YES];
    
    self.soundFlag = 0;
    self.layoutHeight.constant = 0;
    [CommonFunctions recordAudio];

}
-(void)setUpNavBar
{
    
    [self.navigationItem setTitle:NSLocalizedString(@"record", nil)];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    
}
-(void)deleteFile:(NSString *)filePath
{
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:filePath]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
    }
    
}

-(void)initialiseRecorder
{
    self.count = 0;
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    
    // Create a new dated file
    [self deleteFile:[NSString stringWithFormat:@"%@temp.aac",DOCUMENTS_FOLDER]];
    
    NSString *recorderFilePath = [NSString stringWithFormat:@"%@/temp.aac", DOCUMENTS_FOLDER];
    
    
    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
    NSError *err = nil;
    self.recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    if(!self.recorder){
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: [err localizedDescription]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //prepare to record
    [self.recorder setDelegate:self];
    [self.recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    
    
    if (! [[AVAudioSession sharedInstance] isInputAvailable]) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"Audio input hardware not available"
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [cantRecordAlert show];
        return;
    }
    
    
    [self.recorder record];
    [self initialiseTimer];
}
-(void)copyFile :(NSString *) sourcePath toLocation:(NSString *)destPath
{
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *resourcePath = [documentsDirectory stringByAppendingPathComponent:sourcePath];
    
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *storePath = [docDir stringByAppendingPathComponent:destPath];
    
    [fileManager createDirectoryAtPath:[storePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    
    if ([fileManager fileExistsAtPath:storePath] == NO) {
        [fileManager copyItemAtPath:resourcePath toPath:storePath error:&error];
        [[NSUserDefaults standardUserDefaults] setObject:[self.stringAlert stringByAppendingString:@".aac"] forKey:[NSString stringWithFormat:@"%@Sound",self.stringType]];
        [self.view endEditing:YES];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"File already exists" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        Alert.tag = 2;
        [Alert show];

    }
    
    
    
    
}

#pragma mark -
#pragma mark - ezaudio delegate
- (void)   microphone:(EZMicrophone *)microphone
     hasAudioReceived:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
{

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
    });
 }




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 
#pragma mark - button helpers
-(void)playFile
{
    [self.view endEditing:YES];
    [CommonFunctions videoPlay];
    self.audioPlayeView = [[AudioPlayerView alloc] init];
    
    [self.audioPlayeView setFrame: CGRectMake(0, 0, [[UIApplication sharedApplication] keyWindow].frame.size.width, [[UIApplication sharedApplication] keyWindow].frame.size.height )];
    
    
    self.audioPlayeView.delegate = self;
    self.alarmCount = 0;
    self.timerObj = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(handleTimer1) userInfo:nil repeats:YES];
    
    NSError *error = nil;
    // Play it
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/temp.aac", DOCUMENTS_FOLDER]] error:&error];
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    
    [self.audioPlayer play];
    [[[UIApplication sharedApplication] keyWindow]addSubview:self.audioPlayeView];

}
-(void)handleTimer1
{
    self.alarmCount ++;
    float duration = self.audioPlayer.duration;
    float valueChange = self.alarmCount*0.2/duration;
    [self.audioPlayeView.sliderViewTime setValue:valueChange animated:YES];
    
}


#pragma mark - 
#pragma mark - alert view delegate and helper
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if ([textField.text length]==0){
        return NO;
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Save"])
    {
        UITextField *tfEmail = [alertView textFieldAtIndex:0];
        self.stringAlert = tfEmail.text;
        [self copyFile:@"temp.aac" toLocation:[NSString stringWithFormat:@"%@/%@.aac",self.stringType,tfEmail.text]];
    
    }
    if(alertView.tag==2)
    {
        UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:nil message:@"Enter File Name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
        
        dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [dialog textFieldAtIndex:0];
        textField.text = self.stringAlert;
        [dialog show];

    }

    
}

#pragma mark - 
#pragma mark - Delegate audio player
-(void)delegatePlayOrPaused
{
    if(self.audioPlayeView.btnRecordOrPlay.isSelected)
    {
        self.audioPlayeView.btnRecordOrPlay.selected = NO;
    }
    else
    {
        self.audioPlayeView.btnRecordOrPlay.selected = YES;
    }
    // self.audioPlayeView.btnRecordOrPlay.selected = !self.audioPlayeView.btnRecordOrPlay.isSelected;
    if(self.audioPlayeView.btnRecordOrPlay.isSelected)
    {
        [self.audioPlayer pause];
        [self.timerObj invalidate];
    }
    else
    {
        if(self.audioPlayeView.sliderViewTime.value==1.0)
        {
            [self.audioPlayeView.sliderViewTime setValue:0];
            self.alarmCount=0;
        }
        [self.audioPlayer play];
        self.timerObj = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(handleTimer1) userInfo:nil repeats:YES];
    }
}

-(void)delegateDone
{
    [self.audioPlayeView removeFromSuperview];
    self.audioPlayer = nil;
    [self.timerObj invalidate];
}

#pragma mark -
#pragma mark - button actions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionRecordAgain:(id)sender {
    
    [self.viewPlot setup:self.viewPlot.frame];
    [self.viewPlot setBackgroundColor:[UIColor whiteColor]];
    [self.viewPlot setColor:KPurpleColor];
    self.viewPlot.gain = 4;
    [self.viewPlot setNumOfBins:100];
    
    [self.labelTime setText:@"00 : 00"];
    self.layoutHeight.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    self.soundFlag = 0;
    [self.btnRecord setImage:[UIImage imageNamed:@"ic_record_big.png"] forState:UIControlStateNormal];
    [CommonFunctions recordAudio];
   
}

- (IBAction)actionRecord:(id)sender {
    if(self.soundFlag==0)
    {
        [self initialiseRecorder];
        [self.btnRecord setImage:[UIImage imageNamed:@"ic_pause_big.png"] forState:UIControlStateNormal];
        self.soundFlag = 1;
         [self.microphone startFetchingAudio];
    }
    else if (self.soundFlag==1)
    {
        self.soundFlag = 2;
        [self.recorder pause];
        [self.btnRecord setImage:[UIImage imageNamed:@"ic_play_big.png"] forState:UIControlStateNormal];
        self.layoutHeight.constant = 44;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
        [self.counter invalidate];
        [self.microphone stopFetchingAudio];
    }
    else
    {
        [self playFile];
    }
}

- (IBAction)actionSave:(id)sender {
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:nil message:@"Enter File Name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [dialog show];
}
@end
