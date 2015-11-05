//
//  SexOffenderViewController.h
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "UIImage+Extras.h"
#import <math.h>
#import "SexOffenderCell.h"
#import "SexOffender.h"
#import <UIImageView+WebCache.h>
#import "SexOffenderDetailViewController.h"
#import <JTMaterialSpinner.h>
#import "LOcationUpdater.h"

@interface SexOffenderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) NSMutableArray *arraySexOffender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOffenders;
@property (nonatomic,strong) SexOffender *sexOffenderModal;


@end

