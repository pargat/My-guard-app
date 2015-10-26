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

@interface ImageVideoDetailViewController : UIViewController

@property (nonatomic,strong) NSString *feed_id;
@property (nonatomic,strong) NSMutableArray *arrayFiles;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMain;

@end
