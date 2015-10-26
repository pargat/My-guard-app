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

@interface SoundRecordViewController : UIViewController<EZMicrophoneDelegate>

@property (nonatomic, strong) EZMicrophone *microphone;
@property (weak, nonatomic) IBOutlet WaveformView *viewGraph;

@end
