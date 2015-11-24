//
//  SoundMainViewController.h
//  MyGuardApp
//
//  Created by vishnu on 15/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundMainCell1.h"
#import "SoundMainCell2.h"
#import "ApiConstants.h"
#import "SoundSelectViewController.h"


@interface SoundMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewSound;

@end
