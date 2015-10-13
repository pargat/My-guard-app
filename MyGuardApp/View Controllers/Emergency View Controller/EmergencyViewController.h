//
//  EmergencyViewController.h
//  MyGuardApp
//
//  Created by vishnu on 13/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "EmergencyCell1.h"
#import "EmergencyCell2.h"
#import "EmergencyCellContact.h"

@interface EmergencyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSMutableArray *arrayEmergencyContacts;
@property (weak, nonatomic) IBOutlet UITableView *tableViewEmergency;

@end
