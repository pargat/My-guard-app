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
#import "BaseViewController.h"
#import "MyGuardInAppHelper.h"

@interface SexOffenderViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong) NSMutableArray *arraySearch;
@property (nonatomic,strong) NSMutableArray *arraySexOffender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOffenders;
@property (nonatomic,strong) SexOffender *sexOffenderModal;
@property (strong, nonatomic)  UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIView *viewInpp;
@property (weak, nonatomic) IBOutlet UILabel *labelPremium;
@property (weak, nonatomic) IBOutlet UILabel *labelPrimiumDes;
@property (weak, nonatomic) IBOutlet UIButton *btnRestore;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;
- (IBAction)actionBuy:(id)sender;
- (IBAction)actionRestore:(id)sender;



@end

