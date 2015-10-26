//
//  SexOffenderDetailViewController.h
//  MyGuardApp
//
//  Created by vishnu on 12/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SexOffenderDetailCell.h"
#import "SexOffender.h"
#import "ApiConstants.h"
#import <UIImageView+WebCache.h>
#import <JTMaterialSpinner.h>


@interface SexOffenderDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) SexOffender *sexOffenderModal;
@property (nonatomic,strong) NSMutableArray *arrayTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOffender;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPic;
@property (weak, nonatomic) IBOutlet UILabel *labelId;

@property (weak, nonatomic) IBOutlet UILabel *labelFullName;

@end
