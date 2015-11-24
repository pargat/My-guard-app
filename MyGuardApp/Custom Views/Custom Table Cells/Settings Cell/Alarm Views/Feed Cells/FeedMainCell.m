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
    self.btnCamera.layer.cornerRadius = 4.0;
    self.btnCamera.clipsToBounds = YES;

    

}
-(void)layoutSubviews
{
     [super layoutSubviews];
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
    [cell.btnComments setTitle:[NSString stringWithFormat:@" %@",modal.fileNumberOfComments] forState:UIControlStateNormal];

    
}


#pragma mark -
#pragma mark - Button Actions
- (IBAction)actionCamera:(id)sender {
    
    [self.delegate delCameraClicked:self.selectedPath];
}
@end
