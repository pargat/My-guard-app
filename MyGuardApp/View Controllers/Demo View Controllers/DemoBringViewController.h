//
//  DemoBringViewController.h
//  MyGuardApp
//
//  Created by vishnu on 26/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoBringViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelDemoString;

- (IBAction)actionCloseDemo:(id)sender;
- (IBAction)actionNext:(id)sender;

@end
