//
//  SafetyDetailViewController.h
//  MyGuardApp
//
//  Created by vishnu on 20/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "SafetyMeasure.h"
#import "BaseViewController.h"

@interface SafetyDetailViewController : BaseViewController

@property (nonatomic,strong) SafetyMeasure *safetyModal;
@property (nonatomic,strong) NSString *stringId;
@property (nonatomic,strong) NSString *currentTab;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (nonatomic,strong) NSString *stringSafety;

@end
