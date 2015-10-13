//
//  EmergencyCell2.h
//  MyGuardApp
//
//  Created by vishnu on 13/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmergencyCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelEmergencyContactTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnAddContacts;
- (IBAction)actionAddContacts:(id)sender;

@end
