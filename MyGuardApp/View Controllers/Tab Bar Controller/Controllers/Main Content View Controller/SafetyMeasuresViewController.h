//
//  SafetyMeasuresViewController.h
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"
#import "SafetyMeasure.h"
#import "SafetyMeasureCell.h"
#import "ApiConstants.h"
#import <UIImageView+WebCache.h>

@protocol SafetyDelegate

-(void)delHideShowHeader:(BOOL)hide;
-(void)delChangeNavButton:(BOOL)showOptional;

@end


@interface SafetyMeasuresViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) id<SafetyDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *arraySafetyMeasures;
@property (nonatomic, strong) NSString *feedType;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSafety;


@end
