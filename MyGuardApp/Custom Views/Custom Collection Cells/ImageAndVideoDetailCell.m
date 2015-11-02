//
//  ImageAndVideoDetailCell.m
//  MyGuardApp
//
//  Created by vishnu on 25/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "ImageAndVideoDetailCell.h"

@implementation ImageAndVideoDetailCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.scrollViewMain setDelegate:self];
}
- (IBAction)actionCommentRight:(id)sender {
    
    [self.delegate delCommentClicked:NO indexPath:self.indexPath];
}

- (IBAction)actionCommentLeft:(id)sender {
    [self.delegate delCommentClicked:YES indexPath:self.indexPath];
}


#pragma mark -
#pragma mark - Scroll view delegate
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view
{
    
}
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageViewMain;
}
@end
