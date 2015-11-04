//
//  WalkThroughLastView.h
//  MyGuardApp
//
//  Created by vishnu on 15/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"

@interface WalkThroughLastView : UIView

@property (weak, nonatomic) IBOutlet UILabel *labelWTEmergencyTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelWTEmergencyDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelWTAlarmTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelWTAlarmDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelWTQuickTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelWTQuickDescription;

-(void)setterText;

@end
