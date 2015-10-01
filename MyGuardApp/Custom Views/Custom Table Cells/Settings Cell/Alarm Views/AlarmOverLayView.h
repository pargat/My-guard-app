//
//  AlarmOverLayView.h
//  FireSonar
//
//  Created by Gagan on 13/01/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol alarmOverlayDelegate

-(void)emergencyContactClicked ;
-(void)disarmClicked ;
-(void)delegateSendImmediate;
@end

@interface AlarmOverLayView : UIView


@property(nonatomic,assign)id<alarmOverlayDelegate>delegate ;

#pragma mark - Outlets
@property (strong, nonatomic) IBOutlet UIImageView *overlay_timerImg;
@property (strong, nonatomic) IBOutlet UILabel *overlay_timerLabel;
@property (strong, nonatomic) IBOutlet UIView *overlay_backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *labelRaisingAlarm;
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonNotifyEmergency;
@property (weak, nonatomic) IBOutlet UILabel *labelHelp;


#pragma mark - Actions
- (IBAction)actionSendImmidiate:(id)sender;
- (IBAction)cancelAct:(id)sender;
- (IBAction)notifyEmergencyContacts:(id)sender;

@end
