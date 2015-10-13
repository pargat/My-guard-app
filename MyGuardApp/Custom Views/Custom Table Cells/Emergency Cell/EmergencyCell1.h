//
//  EmergencyCell1.h
//  MyGuardApp
//
//  Created by vishnu on 13/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButtonCenter.h"

@interface EmergencyCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButtonCenter *btnSms;
- (IBAction)actionSms:(id)sender;
@property (weak, nonatomic) IBOutlet UIButtonCenter *btnCall911;
- (IBAction)actionCall911:(id)sender;

@end
