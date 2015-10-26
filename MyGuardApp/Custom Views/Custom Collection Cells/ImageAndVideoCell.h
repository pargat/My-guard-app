//
//  ImageAndVideoCell.h
//  MyGuardApp
//
//  Created by vishnu on 15/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAndVideoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewMain;
@property (weak, nonatomic) IBOutlet UIButton *btnVideo;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelected;

@end
