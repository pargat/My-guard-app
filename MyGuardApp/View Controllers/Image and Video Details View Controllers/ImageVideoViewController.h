//
//  ImageVideoViewController.h
//  MyGuardApp
//
//  Created by vishnu on 15/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAndVideoCell.h"
#import "FeedModal.h"
#import "FileModal.h"
#import "ApiConstants.h"
#import <UIImageView+WebCache.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "BaseViewController.h"
#import "UIImage+Extras.h"
#import "Profile.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageVideoDetailViewController.h"
@interface ImageVideoViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>

@property int currentTab;
@property BOOL isEditing;
@property (nonatomic,strong) FeedModal *feedModal;
@property (nonatomic,strong) NSMutableArray *arrayFiles;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMain;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;

- (IBAction)actionCamera:(id)sender;

@end
