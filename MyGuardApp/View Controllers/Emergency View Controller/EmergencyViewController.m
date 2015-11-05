//
//  EmergencyViewController.m
//  MyGuardApp
//
//  Created by vishnu on 13/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "EmergencyViewController.h"

@interface EmergencyViewController ()

@end

@implementation EmergencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self viewHelper];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Helpers

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

-(void)setNavBar
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBarTintColor:KPurpleColorNav];
    [navigationBar setBarStyle:UIBarStyleBlack];
    [navigationBar setTranslucent:NO];

    [self.navigationItem setTitle:NSLocalizedString(@"emergency_screen_title", nil)];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    
}
-(void)viewHelper
{
    
    [self.tableViewEmergency setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.arrayEmergencyContacts = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:EmergencyDefaultKey];
    [self.tableViewEmergency setDelegate:self];
    [self.tableViewEmergency setDataSource:self];
}

#pragma mark -
#pragma mark - Table View Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayEmergencyContacts.count+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        EmergencyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"EmergencyCell1"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.row==1)
    {
        EmergencyCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"EmergencyCell2"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        EmergencyCellContact *cell = [tableView dequeueReusableCellWithIdentifier:@"EmergencyCellContact"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self configureCellEmergency:cell atIndexPath:indexPath];
        return cell;
    }
}

-(void)configureCellEmergency:(EmergencyCellContact *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ContactsData *modal = [self.arrayEmergencyContacts objectAtIndex:indexPath.row-2];
    
    cell.imageViewDp.image =  (modal.contact_image == nil ? [UIImage imageNamed:@"ic_dp_small"] : modal.contact_image );
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",modal.contact_fname] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
    
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:modal.contact_phone_number attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:14]}]];
    
    [cell.labelPhoneNumberAndName setAttributedText:attString];
}


#pragma mark - 
#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        static EmergencyCell1 *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"EmergencyCell1"];
        });
        
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    }
    else if(indexPath.row==1)
    {
        static EmergencyCell2 *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"EmergencyCell2"];
        });
        
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    }
    else
    {
        static EmergencyCellContact *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"EmergencyCellContact"];
        });
        [self configureCellEmergency:sizingCell atIndexPath:indexPath];
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;

    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1)
    {
        _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
        [_addressBookController setPeoplePickerDelegate:self];
        [self presentViewController:_addressBookController animated:YES completion:^{
        }];
    }
    else if (indexPath.row>1)
    {
        self.selectedIndex =indexPath;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call",@"Message",@"Delete", nil];
        [actionSheet showInView:self.view];
    }

}

#pragma mark -
#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            [self callHelper];
            break;
            
        case 1:
            [self messageSend];
            break;
        case 2:
            [self deleteContact];
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark - MFMessage delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark -
#pragma mark - action sheet helpers
-(NSArray *)getContactNos
{
    NSMutableArray *phoneNos = [[NSMutableArray alloc] init];
    
    for (ContactsData *contact in self.arrayEmergencyContacts)
        (contact.contact_phone_number == nil || contact.contact_phone_number.length == 0) ? @"" : [phoneNos addObject:contact.contact_phone_number];
    
    return phoneNos ;
}

-(void)deleteContact{
    
    [self.arrayEmergencyContacts removeObjectAtIndex:self.selectedIndex.row-2];
    [[NSUserDefaults standardUserDefaults] rm_setCustomObject:self.arrayEmergencyContacts forKey:EmergencyDefaultKey];
    //[[NSUserDefaults standardUserDefaults] setObject:self.contactArray forKey:@"emergencyContacts"];
    [self.tableViewEmergency reloadData];
}
-(void)messageSend{
    
    ContactsData *tempContact = [[ContactsData alloc] init];
    tempContact = (ContactsData *)[self.arrayEmergencyContacts objectAtIndex:self.selectedIndex.row-2];
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"Help! I'm in danger";
        controller.recipients = [self getContactNos];
        controller.messageComposeDelegate = self;
        
        [self presentViewController:controller animated:NO completion:nil];
    }
    
}
-(void)callHelper
{
    
    
    ContactsData *tempContact = [[ContactsData alloc] init];
    tempContact = (ContactsData *)[self.arrayEmergencyContacts objectAtIndex:self.selectedIndex.row-2];
    
    NSString *phNo = tempContact.contact_phone_number;
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        [self showAlert:@"Call facility is not available"];
    }
}

#pragma mark - 
#pragma mark - Contacts helper
-(void)callContact : (NSString *)phoneNo
{
    
    
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phoneNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        [self showAlert:@"Call facility is not available"];
    }
    
    
}

-(void)saveContact : (ABRecordRef)person
{
    
    ContactsData *tempContact = [[ContactsData alloc] init];
    
    CFTypeRef generalCFObject = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    if (generalCFObject) {
        tempContact.contact_fname = (__bridge NSString *)generalCFObject ;
        CFRelease(generalCFObject);
    }
    
    generalCFObject = ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (generalCFObject) {
        tempContact.contact_lname = (__bridge NSString *)generalCFObject ;
        CFRelease(generalCFObject);
    }
    
    
    ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    if(phonesRef != nil)
    {
        for (int i=0; i<ABMultiValueGetCount(phonesRef); i++)
        {
            CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
            CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
            
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                tempContact.contact_phone_number = (__bridge NSString *)currentPhoneValue ;
            }
            
            if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo)
            {
                tempContact.contact_phone_number = (__bridge NSString *)currentPhoneValue ;
            }
            
            CFRelease(currentPhoneLabel);
            CFRelease(currentPhoneValue);
        }
        CFRelease(phonesRef);
        
        
        
        if (ABPersonHasImageData(person))
        {
            NSData *contactImageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
            tempContact.contact_image =  [UIImage imageWithData:contactImageData];
        }
        
        if(!(tempContact.contact_phone_number==nil))
        {
            if (self.arrayEmergencyContacts == nil)
            {
                self.arrayEmergencyContacts = [[NSMutableArray alloc] init];
            }
            
            BOOL contactExist = false;
            for (ContactsData *contact in self.arrayEmergencyContacts) {
                if([contact.contact_phone_number isEqualToString:tempContact.contact_phone_number])
                {
                    contactExist = true;
                }
            }
            
            if(contactExist)
            {
                [self showAlert:@"Contact already exist"];
            }
            else
            {
                [self.arrayEmergencyContacts addObject:tempContact];
                
                [[NSUserDefaults standardUserDefaults] rm_setCustomObject:self.arrayEmergencyContacts forKey:EmergencyDefaultKey];
                [self.tableViewEmergency reloadData];
            }
        }
    }
    else
    {
        [self showAlert:@"Please add a valid phone number"];
        
    }
    
    
    
    
}


#pragma mark -
#pragma mark - ABpeople picker delegate
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
 
}



- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self saveContact:person];
}
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    //[_addressBookController dismissViewControllerAnimated:NO completion:nil];
    
    return NO;
}

#pragma mark - 
#pragma mark - Emergency cell delegate
-(void)delCall911
{
    [self callContact:@"911"];
}
-(void)delSms
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"Help! I'm in danger";
        controller.recipients = [self getContactNos];
        controller.messageComposeDelegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
    }

}

#pragma mark -
#pragma mark - Button Actions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark - Alert View Helpers
-(void) showAlert:(NSString *)message
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
