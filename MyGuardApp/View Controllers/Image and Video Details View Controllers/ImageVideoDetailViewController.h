//
//  ImageVideoDetailViewController.h
//  MyGuardApp
//
//  Created by vishnu on 25/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModal.h"
#import "ImageAndVideoDetailCell.h"
#import "ApiConstants.h"
#import <UIImageView+WebCache.h>
#import "CommentView.h"
#import "BaseViewController.h"
#import "CommonFunctions.h"
#import <MediaPlayer/MediaPlayer.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface ImageVideoDetailViewController : BaseViewController<ImageVideoDetailDelegate,UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate,CommentDelegate>

@property BOOL isCommentShowing;
@property BOOL isCommentShow;
@property (nonatomic,strong) NSString *stringPostId;
@property (nonatomic,strong) NSString *stringFeedId;
@property (nonatomic,strong) NSIndexPath *indexToScroll;
@property (nonatomic,strong) CommentView *commentView;
@property (nonatomic,strong) NSString *feed_id;
@property (nonatomic,strong) NSMutableArray *arrayFiles;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMain;

@end
