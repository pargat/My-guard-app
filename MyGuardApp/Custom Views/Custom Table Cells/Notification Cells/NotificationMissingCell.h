//
//  NotificationMissingCell.h
//  MyGuardApp
//
//  Created by vishnu on 16/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationMissingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDp;
@property (weak, nonatomic) IBOutlet UILabel *labelMissing;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelLastSeen;
@property (weak, nonatomic) IBOutlet UIView *viewOverlay;

@end
