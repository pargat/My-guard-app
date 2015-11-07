//
//  AudioPlayerView.h
//  FireSonar
//
//  Created by CB Labs_1 on 24/02/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class AudioPlayerView;
@protocol AudioPlayerProtocol

-(void)delegateDone;
-(void)delegatePlayOrPaused;

@end


@interface AudioPlayerView : UIView
@property (nonatomic,assign) id<AudioPlayerProtocol> delegate;
@property (weak, nonatomic) IBOutlet UISlider *sliderViewTime;
@property (weak, nonatomic) IBOutlet UIButton *btnRecordOrPlay;
@property (weak, nonatomic) IBOutlet UIView *viewAudioHolder;

- (IBAction)actionPlayOrPause:(id)sender;
- (IBAction)actionDone:(id)sender;



@end
