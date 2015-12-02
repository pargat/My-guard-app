//
//  SexOverlayNew.h
//  MyGuardApp
//
//  Created by vishnu on 29/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButtonRound.h"
#import <AVFoundation/AVFoundation.h>
#import "CommonFunctions.h"

@interface SexOverlayNew : UIView


@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSex;
@property (weak, nonatomic) IBOutlet UIButtonRound *btnDontTrack;
@property (weak, nonatomic) IBOutlet UIButton *btnVieOfender;
@property (weak, nonatomic) IBOutlet UIView *viewOverlay;
@property (weak, nonatomic) IBOutlet UILabel *labelSexDesci;

@property (weak, nonatomic) IBOutlet UIButtonRound *btnHush;
- (IBAction)actionViewOffender:(id)sender;
- (IBAction)actionHush:(id)sender;
- (IBAction)actionDonttrack:(id)sender;

@end
