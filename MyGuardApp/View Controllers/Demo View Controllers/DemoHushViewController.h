//
//  DemoHushViewController.h
//  MyGuardApp
//
//  Created by vishnu on 06/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButtonRound.h"
#import <AVFoundation/AVFoundation.h>
#import "ApiConstants.h"

@interface DemoHushViewController : UIViewController


@property (nonatomic,strong) NSString *type;
@property (weak, nonatomic) IBOutlet UILabel *labelDemoAlarm;
@property (weak, nonatomic) IBOutlet UILabel *labelAlarmRaised;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAnim;
@property (weak, nonatomic) IBOutlet UIButtonRound *btnHush;
- (IBAction)actionHush:(id)sender;

@end
