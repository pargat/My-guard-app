//
//  MainTabBarController.h
//  MyGuardApp
//
//  Created by vishnu on 15/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "LOcationUpdater.h"
#import <Accelerate/Accelerate.h>
#import <EZAudio.h>
#import "AlarmOverLayView.h"
#import "WaveAnimationView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoStreamViewController.h"
#import "OtherProfileViewController.h"
#import "SafetyDetailViewController.h"

@interface MainTabBarController : UITabBarController<CLLocationManagerDelegate,alarmOverlayDelegate,waveAnimationDelegate,EZMicrophoneDelegate,UIAlertViewDelegate>

@property BOOL isFirstTime;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong) EZMicrophone *microphone;
@property (nonatomic,strong) CLLocationManager *locationManager;



@end
