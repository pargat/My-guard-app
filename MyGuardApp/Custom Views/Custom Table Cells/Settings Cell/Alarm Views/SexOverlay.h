//
//  SexOverlay.h
//  MyGuardApp
//
//  Created by vishnu on 29/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SexOverlay : UIView
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSex;
@property (weak, nonatomic) IBOutlet UILabel *labelSexOff;
@property (weak, nonatomic) IBOutlet UIButton *btnHush;
- (IBAction)actionHush:(id)sender;

@end
