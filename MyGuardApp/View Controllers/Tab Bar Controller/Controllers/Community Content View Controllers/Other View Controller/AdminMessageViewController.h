//
//  AdminMessageViewController.h
//  MyGuardApp
//
//  Created by vishnu on 05/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "BaseViewController.h"

@interface AdminMessageViewController : BaseViewController

@property (nonatomic,strong) NSString *messageId;
@property (nonatomic,strong) NSString *messageString;
@property (weak, nonatomic) IBOutlet UITextView *textViewAdmin;

@end
