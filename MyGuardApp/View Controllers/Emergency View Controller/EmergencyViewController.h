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
#import <AddressBookUI/AddressBookUI.h>
#import "ContactsData.h"
#import <MessageUI/MessageUI.h>

@interface EmergencyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ABPeoplePickerNavigationControllerDelegate,MFMessageComposeViewControllerDelegate,UIActionSheetDelegate,EmergencyCell1Delegate>

@property (nonatomic,strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
@property(nonatomic, strong) NSMutableArray *arrayEmergencyContacts;
@property (weak, nonatomic) IBOutlet UITableView *tableViewEmergency;

@end
