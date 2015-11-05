//
//  EmergencyCell1.h
//  MyGuardApp
//
//  Created by vishnu on 13/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButtonCenter.h"

@protocol EmergencyCell1Delegate <NSObject>

-(void)delCall911;
-(void)delSms;

@end


@interface EmergencyCell1 : UITableViewCell

@property (nonatomic,assign) id<EmergencyCell1Delegate> delegate;
@property (weak, nonatomic) IBOutlet UIButtonCenter *btnSms;
@property (weak, nonatomic) IBOutlet UIButtonCenter *btnCall911;

- (IBAction)actionCall911:(id)sender;
- (IBAction)actionSms:(id)sender;

@end
