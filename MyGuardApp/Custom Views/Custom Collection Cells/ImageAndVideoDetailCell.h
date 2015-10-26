//
//  ImageAndVideoDetailCell.h
//  MyGuardApp
//
//  Created by vishnu on 25/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAndVideoDetailCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewMain;
@property (weak, nonatomic) IBOutlet UIButton *btnCommentsText;

@property (weak, nonatomic) IBOutlet UIButton *btnComments;

@end
