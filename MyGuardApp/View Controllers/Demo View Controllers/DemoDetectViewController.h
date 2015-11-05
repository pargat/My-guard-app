//
//  DemoDetectViewController.h
//  MyGuardApp
//
//  Created by vishnu on 26/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoDetectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labrlTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnClickhere;
@property (weak, nonatomic) IBOutlet UIButton *btnCLoseDemo;
- (IBAction)actionClickHer:(id)sender;
- (IBAction)actionCloseDemo:(id)sender;

@end
