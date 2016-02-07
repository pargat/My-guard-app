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
#import "CommonFunctions.h"
#import "YSLDraggableCardContainer.h"
#import "CardView.h"
#import "CustomBadge.h"


@interface SexOffenderViewController : BaseViewController<UISearchBarDelegate,YSLDraggableCardContainerDataSource,YSLDraggableCardContainerDelegate>
@property (nonatomic,strong) CustomBadge *badgeC;
@property BOOL layoutLaid;
@property (nonatomic,strong) NSArray *arrayInApp;
@property int deleteCount;
@property (nonatomic,strong) NSMutableArray *arraySearch;
@property (nonatomic,strong) NSMutableArray *arraySexOffender;
@property (nonatomic,strong) SexOffender *sexOffenderModal;
@property (weak, nonatomic) IBOutlet YSLDraggableCardContainer *viewContainer;
@property (strong, nonatomic)  UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *viewNoOne;
@property (weak, nonatomic) IBOutlet UILabel *labelCool;
@property (weak, nonatomic) IBOutlet YSLDraggableCardContainer *viewDraggable;
@property (weak, nonatomic) IBOutlet UIView *viewInpp;
@property (weak, nonatomic) IBOutlet UILabel *labelPremium;
@property (weak, nonatomic) IBOutlet UILabel *labelPrimiumDes;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;
- (IBAction)actionBuy:(id)sender;



@end

