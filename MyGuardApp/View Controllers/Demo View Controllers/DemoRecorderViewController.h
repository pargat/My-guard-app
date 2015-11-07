//
//  DemoRecorderViewController.h
//  MyGuardApp
//
//  Created by vishnu on 06/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordView.h"
#import "AudioPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "ApiConstants.h"
#import "CommonFunctions.h"
#import <MessageUI/MessageUI.h>

@interface DemoRecorderViewController : UIViewController<RecordViewProtocol,AudioPlayerProtocol,AVAudioRecorderDelegate,AVAudioPlayerDelegate,MFMailComposeViewControllerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSTimer *timerObj;
@property (strong,nonatomic) NSTimer *counter;

@property int hrs;
@property int count;

@property (strong,nonatomic) NSString *recorderFilePath;
@property NSInteger alarmCount;
@property (strong,nonatomic) AVAudioRecorder * recorder;
@property (strong,nonatomic)AVAudioPlayer *audioPlayer;
@property (nonatomic,retain) AudioPlayerView *audioPlayeView;
@property (strong,nonatomic)RecordView *recordView;





@property (weak, nonatomic) IBOutlet UITextField *textFieldSmoke;
@property (weak, nonatomic) IBOutlet UILabel *labelRecorder;
@property (weak, nonatomic) IBOutlet UIView *viewRecorder;

@end
