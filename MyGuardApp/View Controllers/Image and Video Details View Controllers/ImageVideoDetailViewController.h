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

@property BOOL isViewingDescription;
@property int currentTab;
@property (nonatomic,strong) NSString *stringAddress;
@property BOOL isCommentShowing;
@property BOOL isCommentShow;
@property (nonatomic,strong) NSString *stringPostId;
@property (nonatomic,strong) NSString *stringFeedId;
@property (weak, nonatomic) IBOutlet UIView *viewDetails;
@property (nonatomic,strong) NSIndexPath *indexToScroll;
@property (nonatomic,strong) CommentView *commentView;
@property (nonatomic,strong) NSString *feed_id;
@property (nonatomic,strong) NSMutableArray *arrayFiles;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMain;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnComment1;
@property (weak, nonatomic) IBOutlet UIButton *btnComment2;

- (IBAction)actionComment2:(id)sender;
- (IBAction)actionComment1:(id)sender;

@end
