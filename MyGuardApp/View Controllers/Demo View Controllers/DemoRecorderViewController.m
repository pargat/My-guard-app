//
//  DemoRecorderViewController.m
//  MyGuardApp
//
//  Created by vishnu on 06/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "DemoRecorderViewController.h"

@interface DemoRecorderViewController ()

@end

@implementation DemoRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self viewHelper];
    [self setNavBar];
    //[self showPostButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - View Helper and observers
-(void)addTap
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.view addGestureRecognizer:tapGesture];
}
-(void)tapped
{
    [self.view endEditing:YES];
}

-(void)showPostButton
{
    UIBarButtonItem *btnPost = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"post", nil) style:UIBarButtonItemStylePlain target:self action:@selector(actionPost)];
    [btnPost setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = btnPost;

}
-(void)postFile
{
    if ([MFMailComposeViewController canSendMail])
    {
    MFMailComposeViewController *picker =[[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"Audio file of smoke detector"];
    [picker setToRecipients:@[@"support@firesonar.com"]];

    NSData   *data = [NSData dataWithContentsOfFile:self.recorderFilePath];
    [picker addAttachmentData:data mimeType:@"audio/aac"
                     fileName:@"Audio"];
    NSString *emailBody = self.textFieldSmoke.text;
    [picker setMessageBody:emailBody isHTML:YES];
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please set up an email account." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show] ;
    }

}
-(void)initialiseRecorder
{
    self.recordView = [[RecordView alloc] init];
    [self.recordView setFrame: CGRectMake(0, 0, self.viewRecorder.frame.size.width, self.viewRecorder.frame.size.height*2/3)];
    [self.recordView.btnRecordPlay setHidden:YES];
    [self.recordView.labelCount setHidden:YES];
    self.recordView.delegate = self;
    [self.viewRecorder addSubview:self.recordView];
}
-(void)setNavBar
{
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    [self.navigationItem setTitle:NSLocalizedString(@"demo_recorder_title", nil)];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    [navigationBar setBackgroundColor:KPurpleColorNav];
    
    [navigationBar setBarTintColor:KPurpleColorNav];
    [navigationBar setBarStyle:UIBarStyleBlack];
    [navigationBar setTranslucent:NO];
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
-(void) countMethod
{
    self.count++;
    
    if(self.count==60)
    {
        self.hrs++;
        self.count=0;
    }
    self.recordView.labelCount.text = [NSString stringWithFormat:@"%.2d:%.2d",self.hrs,self.count];
}
-(void)handleTimer
{
    self.alarmCount ++;
    float duration = self.audioPlayer.duration;
    float valueChange = self.alarmCount*0.2/duration;
    [self.audioPlayeView.sliderViewTime setValue:valueChange animated:YES];
    
}
-(void)viewHelper
{
    [self initialiseRecorder];
    self.textFieldSmoke.delegate = self;
    self.textFieldSmoke.layer.borderColor = [UIColor colorWithWhite:0.2 alpha:0.2].CGColor;
    self.textFieldSmoke.layer.borderWidth = 1.0;
//    [self.textFieldSmoke drawTextInRect:CGRectMake(8, 0, self.textFieldSmoke.frame.size.width, self.textFieldSmoke.frame.size.height)];
//    [self.textFieldSmoke editingRectForBounds:CGRectMake(8, 0, self.textFieldSmoke.frame.size.width, self.textFieldSmoke.frame.size.height)];
//    [self.textFieldSmoke textRectForBounds:CGRectMake(8, 0, self.textFieldSmoke.frame.size.width, self.textFieldSmoke.frame.size.height)];
    [self.labelRecorder setText:NSLocalizedString(@"demo_recorder", nil)];
    [self addTap];
}

-(void)DoneAction
{
    
    [self.audioPlayeView removeFromSuperview];
    self.audioPlayer = nil;
    [self.timerObj invalidate];
}
-(void)PlayorPause
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
        [self.audioPlayer play];
        if(self.audioPlayeView.sliderViewTime.value==1.0)
        {
            [self.audioPlayeView.sliderViewTime setValue:0];
            self.count=0;
        }

        self.timerObj = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    }
}


#pragma mark -
#pragma mark - file handling
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
#pragma mark -
#pragma mark - delegate audio player
-(void)delegateDone
{
    [self.view endEditing:YES];
    [self DoneAction];
}
-(void)delegatePlayOrPaused
{
    [self.view endEditing:YES];
    [self PlayorPause];
}



#pragma mark -
#pragma mark - record view delegate

-(void)delegateDelete1
{
    [self.view endEditing:YES];
    [self.recordView removeFromSuperview];
    [self initialiseRecorder];
    self.navigationItem.rightBarButtonItem = nil;
}
-(void)delegatePlay1
{
    [self.view endEditing:YES];
    [CommonFunctions videoPlay];
    self.audioPlayeView = [[AudioPlayerView alloc] init];
    
    [self.audioPlayeView setFrame: CGRectMake(0, 0, [[UIApplication sharedApplication] keyWindow].frame.size.width, [[UIApplication sharedApplication] keyWindow].frame.size.height )];
    
    
    self.audioPlayeView.delegate = self;
    self.alarmCount = 0;
    self.timerObj = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    
    NSError *error = nil;
    // Play it
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.recorderFilePath] error:&error];
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    
    [self.audioPlayer play];
    [[[UIApplication sharedApplication] keyWindow]addSubview:self.audioPlayeView];
    
}
-(void)delegateRecord1
{
    [self.view endEditing:YES];
    [self deleteFile:[NSString stringWithFormat:@"%@temp.aac",DOCUMENTS_FOLDER]];
    [self.recordView removeFromSuperview];
    [self initialiseRecorder];
    
}
-(void)delegateRecord
{
    [self.view endEditing:YES];
    self.recordView.isRecording = !self.recordView.isRecording;
    if(self.recordView.isRecording)
    {
        self.counter = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                        target:self
                                                      selector:@selector(countMethod)
                                                      userInfo:nil
                                                       repeats:YES];
        self.count=0;
        
        [self.recordView.btnRecord setHidden:YES];
        [self.recordView.btnRecordPlay setHidden:NO];
        [self.recordView.labelClickToRecord setHidden:YES];
        [self.recordView.labelCount setHidden:NO];
        [self.recordView.viewRecordHolder1 setHidden:YES];
        [self.recordView.viewRecordHolder setHidden:NO];
        
        
        
        [CommonFunctions recordAudio];
        
        
        
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        
        
        
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        
        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        
        
        // Create a new dated file
        [self deleteFile:[NSString stringWithFormat:@"%@temp.aac",DOCUMENTS_FOLDER]];
        
        self.recorderFilePath = [NSString stringWithFormat:@"%@/temp.aac", DOCUMENTS_FOLDER];
        
        
        NSURL *url = [NSURL fileURLWithPath:self.recorderFilePath];
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
        
        
    }
    else
    {
        [self.recordView.viewRecordHolder1 setHidden:NO];
        [self.recordView.viewRecordHolder setHidden:YES];
        
        
    }
    
}
-(void)delegateRecordPlay
{
    [self.view endEditing:YES];
    if(self.recordView.isRecording)
    {
        self.recordView.isRecording = false;
        self.recordView.btnRecordPlay.selected = YES;
        [self.recordView.viewRecordHolder1 setHidden:NO];
        [self.recordView.viewRecordHolder setHidden:YES];
        [self.counter invalidate];
        [self.recorder pause];
        [self showPostButton];
        
    }
    else
    {
        
    }
}


#pragma mark -
#pragma mark - Text Field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textFieldSmoke resignFirstResponder];
    return YES;
}
#pragma mark - 
#pragma mark - MFmail composer delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error
{
    [self.textFieldSmoke setText:nil];
    [self delegateDelete1];
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-4] animated:YES];
}

#pragma mark - 
#pragma mark - Button Action
-(void)actionPost
{
    [self postFile];
}
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
