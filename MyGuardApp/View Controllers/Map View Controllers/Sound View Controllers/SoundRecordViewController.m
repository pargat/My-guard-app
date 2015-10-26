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
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    [self.microphone startFetchingAudio];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)    microphone:(EZMicrophone *)microphone
//         hasBufferList:(AudioBufferList *)bufferList
//        withBufferSize:(UInt32)bufferSize
//  withNumberOfChannels:(UInt32)numberOfChannels
//{
//    __weak SoundRecordViewController *weakSelf = self;
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf.viewGraph updateBuffer:bufferList withBufferSize:bufferSize];
//        
//    });
//
//}

- (void)   microphone:(EZMicrophone *)microphone
     hasAudioReceived:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
{
    
    NSLog(@"bufffer[0] %lf",buffer);
    __weak SoundRecordViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.viewGraph updateBuffer:buffer[0] withBufferSize:bufferSize];

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

@end
