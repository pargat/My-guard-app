//
//  AddSafetyViewController.h
//  MyGuardApp
//
//  Created by vishnu on 07/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import <SZTextView.h>

@interface AddSafetyViewController : UIViewController


@property MAINTAB currentTab;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnCollection;
- (IBAction)actionType:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelAddTo;
@property (weak, nonatomic) IBOutlet SZTextView *textViewDescription;

@end
