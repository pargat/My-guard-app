//
//  SafetyMeasureCell.h
//  MyGuardApp
//
//  Created by vishnu on 18/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SafetyMeasureCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDp;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@end
