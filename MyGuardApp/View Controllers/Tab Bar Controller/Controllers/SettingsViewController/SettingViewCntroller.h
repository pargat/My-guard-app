//
//  SettingViewCntroller.h
//  MyGuardApp
//
//  Created by vishnu on 28/09/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingCell.h"
#import "SettingCellDescriptionCell.h"
#import <MessageUI/MessageUI.h>
#import "ApiConstants.h"
#import "Profile.h"
#import <JTMaterialSpinner.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
@interface SettingViewCntroller : UIViewController<UITableViewDataSource,UITableViewDelegate,FBSDKAppInviteDialogDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSArray *arraySettings;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSettings;

@end
