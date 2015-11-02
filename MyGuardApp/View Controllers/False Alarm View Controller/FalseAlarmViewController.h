//
//  FalseAlarmViewController.h
//  MyGuardApp
//
//  Created by vishnu on 31/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import <UIImageView+WebCache.h>

@interface FalseAlarmViewController : UIViewController


@property (nonatomic,strong) NSDictionary *dictInfo;


@property (weak, nonatomic) IBOutlet UIImageView *imageViewDp;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;

@end
