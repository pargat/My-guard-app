//
//  ImageBigView.h
//  FushApp
//
//  Created by CB Labs_1 on 11/04/15.
//  Copyright (c) 2015 CB Labs_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
@interface ImageBigView : UIView<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBig;
@property (weak, nonatomic) IBOutlet UIScrollView *scrolviewMain;
- (IBAction)actionBack:(id)sender;

-(void)setImage:(NSURL *)url;
@end
