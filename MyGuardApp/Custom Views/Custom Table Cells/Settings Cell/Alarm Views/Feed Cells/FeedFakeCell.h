//
//  FeedFakeCell.h
//  MyGuardApp
//
//  Created by vishnu on 03/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedImageCell.h"
#import "ApiConstants.h"
#import <UIImageView+WebCache.h>
#import "FileModal.h"

@protocol FeedFakeDelegate <NSObject>

-(void)delCameraClicked:(NSIndexPath *)indexPath;
-(void)delImageCellClicked:(NSIndexPath *)indexPath;

@end


@interface FeedFakeCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegate>


@property (nonatomic,strong) id<FeedFakeDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *selectedPath;
@property (nonatomic,strong) NSMutableArray *arrayFiles;


@property (weak, nonatomic) IBOutlet UIImageView *imageViewMap;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewImages;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCollctionView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDp;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeSince;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnVideo;

@property (weak, nonatomic) IBOutlet UIView *viewGradient;
@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightMap;

@property (weak, nonatomic) IBOutlet UIButton *btnCamera;

-(void)setDataAndDelegateNil;
-(void)setDelegateAndData;
- (IBAction)actionCamera:(id)sender;


@end
