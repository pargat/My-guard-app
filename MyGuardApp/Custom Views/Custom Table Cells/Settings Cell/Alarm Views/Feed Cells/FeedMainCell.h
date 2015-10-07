//
//  FeedMainCell.h
//  MyGuardApp
//
//  Created by vishnu on 01/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedImageCell.h"
#import <UIImageView+WebCache.h>
#import "ApiConstants.h"


@protocol FeedMainDelegate <NSObject>

-(void)delCameraClicked:(NSIndexPath *)indexPath;

@end

@interface FeedMainCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) id<FeedMainDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *selectedPath;
@property (nonatomic,strong) NSMutableArray *arrayFiles;


@property (weak, nonatomic) IBOutlet UIImageView *imageViewMap;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewImages;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCollctionView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDp;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeSince;

@property (weak, nonatomic) IBOutlet UIView *viewOverlay;
@property (weak, nonatomic) IBOutlet UILabel *labelEmergencyName;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeDetail;
@property (weak, nonatomic) IBOutlet UIView *viewGradient;
@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightMap;

-(void)setDelegateAndData;
- (IBAction)actionCamera:(id)sender;



@end
