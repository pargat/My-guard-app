//
//  ImageAndVideoDetailCell.h
//  MyGuardApp
//
//  Created by vishnu on 25/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageVideoDetailDelegate <NSObject>

-(void)delCommentClicked:(BOOL)leftOrRight indexPath:(NSIndexPath *)indexPath;

@end

@interface ImageAndVideoDetailCell : UICollectionViewCell <UIScrollViewDelegate>

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (assign, nonatomic) id<ImageVideoDetailDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewMain;
@property (weak, nonatomic) IBOutlet UIButton *btnCommentsText;

@property (weak, nonatomic) IBOutlet UIButton *btnComments;
- (IBAction)actionCommentRight:(id)sender;
- (IBAction)actionCommentLeft:(id)sender;

@end
