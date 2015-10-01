//
//  AlarmOverLayView.h
//  FireSonar
//
//  Created by Gagan on 13/01/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"

@protocol alarmOverlayDelegate

-(void)disarmClicked ;
-(void)delegateSendImmediate;

@end

@interface AlarmOverLayView : UIView


@property(nonatomic,assign)id<alarmOverlayDelegate>delegate ;

#pragma mark - Outlets

@property MAINTAB currentTab;
@property (weak, nonatomic) IBOutlet UILabel *labelRaining;
@property (strong, nonatomic) IBOutlet UIImageView *overlay_timerImg;
@property (strong, nonatomic) IBOutlet UILabel *overlay_timerLabel;
@property (strong, nonatomic) IBOutlet UIView *overlay_backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *labelRaisingAlarm;
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;


#pragma mark - Actions
-(void)viewColorSetter;
- (IBAction)actionSendImmidiate:(id)sender;
- (IBAction)cancelAct:(id)sender;


@end
