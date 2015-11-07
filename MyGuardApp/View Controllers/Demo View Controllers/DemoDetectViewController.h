//
//  DemoDetectViewController.h
//  MyGuardApp
//
//  Created by vishnu on 26/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EZAudio.h>
#import "MainTabBarController.h"
#import <ZLHistogramAudioPlot.h>
#import "DemoHushViewController.h"

@interface DemoDetectViewController : UIViewController<EZMicrophoneDelegate>

@property (nonatomic,strong) EZMicrophone *microphone;
@property (weak, nonatomic) IBOutlet UILabel *labrlTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnClickhere;
@property (weak, nonatomic) IBOutlet UIButton *btnCLoseDemo;
@property (weak, nonatomic) IBOutlet ZLHistogramAudioPlot *audioPlot;

- (IBAction)actionClickHer:(id)sender;
- (IBAction)actionCloseDemo:(id)sender;

@end
