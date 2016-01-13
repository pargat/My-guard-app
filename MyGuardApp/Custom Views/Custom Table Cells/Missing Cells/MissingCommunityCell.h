//
//  MissingCommunityCell.h
//  MyGuardApp
//
//  Created by vishnu on 13/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissingCommunityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPerson;
@property (weak, nonatomic) IBOutlet UILabel *labelNameP;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelMissingSInceP;
@property (weak, nonatomic) IBOutlet UILabel *labelMissingSince;
@property (weak, nonatomic) IBOutlet UILabel *labelLastP;
@property (weak, nonatomic) IBOutlet UILabel *labelLast;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
- (IBAction)actionCall:(id)sender;

@end
