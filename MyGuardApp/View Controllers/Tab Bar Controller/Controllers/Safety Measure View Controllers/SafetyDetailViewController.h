//
//  SafetyDetailViewController.h
//  MyGuardApp
//
//  Created by vishnu on 20/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"

@interface SafetyDetailViewController : UIViewController

@property (nonatomic,strong) NSString *currentTab;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (nonatomic,strong) NSString *stringSafety;

@end
