//
//  ImageBigView.m
//  FushApp
//
//  Created by CB Labs_1 on 11/04/15.
//  Copyright (c) 2015 CB Labs_1. All rights reserved.
//

#import "ImageBigView.h"

@implementation ImageBigView

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ImageBigView" owner:self options:nil] lastObject];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle)];
        [self addGestureRecognizer:tapGesture];
        
        self.scrolviewMain.minimumZoomScale=1.0;
        self.scrolviewMain.maximumZoomScale=6.0;
        [self.scrolviewMain setDelegate:self];
    }
    
    return self;
    
}
- (IBAction)actionBack:(id)sender {
    [self removeFromSuperview];
}

-(void)setImage:(NSURL *)url
{
     [self.imageViewBig setImageWithURL:url usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}
-(void)tapHandle
{
    [self removeFromSuperview];
}

#pragma mark -
#pragma mark - Scroll view delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageViewBig;
}
@end
