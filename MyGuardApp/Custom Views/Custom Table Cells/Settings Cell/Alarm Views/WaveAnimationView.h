//
//  WaveAnimationView.h
//  FireSonar
//
//  Created by Gagan on 22/01/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"
#import "constants.h"
@protocol waveAnimationDelegate

-(void)waveAnimationTurnOff;

@end

@interface WaveAnimationView : UIView<UIAlertViewDelegate>

@property(nonatomic,assign)id<waveAnimationDelegate>delegate ;

#pragma mark - Outlets

@property (strong, nonatomic) IBOutlet UIImageView *overlay_AnimationImg;
@property (strong, nonatomic) IBOutlet UIView *overlay_background;
@property (weak, nonatomic) IBOutlet UIButton *btnFalseAlarm;

@property (weak, nonatomic) IBOutlet UIButton *btnNotify;

#pragma mark - Actions
- (IBAction)cancelAct:(id)sender;
- (IBAction)actionFalseAlarm:(id)sender;


#pragma mark - Methods
-(void)startOverlayAnimation ;
-(void)stopOverlayAnimation ;
@end
