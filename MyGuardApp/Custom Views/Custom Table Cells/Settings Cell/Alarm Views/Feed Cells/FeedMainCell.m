//
//  FeedMainCell.m
//  MyGuardApp
//
//  Created by vishnu on 01/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "FeedMainCell.h"

@implementation FeedMainCell


- (void)awakeFromNib {
    // Initialization code
    self.imageViewDp.layer.cornerRadius = self.imageViewDp.frame.size.width/2;
    self.imageViewDp.clipsToBounds = YES;
    self.viewOverlay.layer.cornerRadius = 2.0;
    self.viewOverlay.clipsToBounds = YES;
    
    

}
-(void)layoutSubviews
{
     [super layoutSubviews];
    
    
//        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.viewOverlay.bounds];
//        self.viewOverlay.layer.masksToBounds = NO;
//        self.viewOverlay.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//        self.viewOverlay.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//        self.viewOverlay.layer.shadowOpacity = 0.75f;
//        self.viewOverlay.layer.shadowPath = shadowPath.CGPath;
//    
//        UIBezierPath *shadowPath1 = [UIBezierPath bezierPathWithRect:self.viewShadow.bounds];
//        self.viewShadow.layer.masksToBounds = NO;
//        self.viewShadow.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//        self.viewShadow.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//        self.viewShadow.layer.shadowOpacity = 0.75f;
//        self.viewShadow.layer.shadowPath = shadowPath1.CGPath;

}
#pragma mark -
#pragma mark - Helpers
-(void)setDataAndDelegateNil
{
    [self.collectionViewImages setDelegate:nil];
    [self.collectionViewImages setDataSource:nil];
}
-(void)setDelegateAndData
{
    [self.collectionViewImages setDelegate:self];
    [self.collectionViewImages setDataSource:self];
    [self.collectionViewImages reloadData];
}

#pragma mark - 
#pragma mark - Collection View Datasource functions
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate delImageCellClicked:self.selectedPath];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayFiles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeedImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedImageCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return CGSizeMake(100, 100);

}
-(void)configureCell:(FeedImageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FileModal *modal = [self.arrayFiles objectAtIndex:indexPath.row];
    if(modal.fileType)
    {
        [cell.imageViewM sd_setImageWithURL:[NSURL URLWithString:modal.fileThumbCumImageLink] placeholderImage:[UIImage imageNamed:@"video.png"]];
        [cell.btnVideo setHidden:NO];
        [cell.btnVideo setTitle:modal.fileDuration forState:UIControlStateNormal];
    
    }
    else
    {
        [cell.imageViewM sd_setImageWithURL:[NSURL URLWithString:modal.fileThumbCumImageLink] placeholderImage:[UIImage imageNamed:@"defaultImg80.png"]];
        [cell.btnVideo setHidden:YES];

    }
    [cell.btnComments setTitle:modal.fileNumberOfComments forState:UIControlStateNormal];

    
}


#pragma mark -
#pragma mark - Button Actions
- (IBAction)actionCamera:(id)sender {
    
    [self.delegate delCameraClicked:self.selectedPath];
}
@end
