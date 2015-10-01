//
//  WalkThroughViewController.h
//  MyGuardApp
//
//  Created by vishnu on 14/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalkThroughView.h"
#import "WalkThroughLastView.h"
#import "ApiConstants.h"
@interface WalkThroughViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnSkipWalkThrough;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnStartDemo;

@end
