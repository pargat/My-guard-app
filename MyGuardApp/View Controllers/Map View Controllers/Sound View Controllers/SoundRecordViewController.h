//
//  SoundRecordViewController.h
//  MyGuardApp
//
//  Created by vishnu on 15/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EZAudioPlotGL.h>
#import <EZMicrophone.h>
#import "WaveformView.h"
#import "ApiConstants.h"
#import <ZLHistogramAudioPlot.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayerView.h"
#import "CommonFunctions.h"
#import "BaseViewController.h"

@interface SoundRecordViewController : BaseViewController<EZMicrophoneDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,AudioPlayerProtocol,UIAlertViewDelegate>


@property (nonatomic,strong) NSTimer *timerObj;
@property NSInteger alarmCount;
@property (nonatomic,retain) AudioPlayerView *audioPlayeView;
@property (strong,nonatomic) AVAudioRecorder * recorder;
@property int soundFlag;
@property (nonatomic, strong) EZMicrophone *microphone;
@property (nonatomic,strong) NSString *stringType;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet ZLHistogramAudioPlot *viewPlot;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet UIView *viewTimer;
@property (nonatomic,strong) NSTimer *counter;
@property int count;
@property (strong,nonatomic)AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnRecordAgain;

- (IBAction)actionRecordAgain:(id)sender;

- (IBAction)actionRecord:(id)sender;
- (IBAction)actionSave:(id)sender;

@end
