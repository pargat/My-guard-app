//
//  DemoHushViewController.h
//  MyGuardApp
//
//  Created by vishnu on 06/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButtonRound.h"

@interface DemoHushViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labelDemoAlarm;
@property (weak, nonatomic) IBOutlet UILabel *labelAlarmRaised;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAnim;
@property (weak, nonatomic) IBOutlet UIButtonRound *btnHush;
- (IBAction)actionHush:(id)sender;

@end
