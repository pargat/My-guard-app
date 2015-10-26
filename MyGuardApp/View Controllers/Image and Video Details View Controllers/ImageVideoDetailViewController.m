//
//  ImageVideoDetailViewController.m
//  MyGuardApp
//
//  Created by vishnu on 25/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "ImageVideoDetailViewController.h"

@interface ImageVideoDetailViewController ()

@end

@implementation ImageVideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - View helpers
-(void)setNavBar
{
    [self.navigationItem setTitle:@"GunShot"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    UIBarButtonItem *btnMore = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_more"] style:UIBarButtonItemStylePlain target:self action:@selector(actionMore)];
    [btnMore setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = btnMore;
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
}

#pragma mark-
#pragma mark- collection view delegate and datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayFiles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageAndVideoDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageAndVideoDetailCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}
-(void)configureCell:(ImageAndVideoDetailCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FileModal *modal = [self.arrayFiles objectAtIndex:indexPath.row];
    [cell.imageViewMain sd_setImageWithURL:[NSURL URLWithString:modal.fileThumbCumImageLink]];
    [cell.btnCommentsText setTitle:[NSString stringWithFormat:@"%@ comments",modal.fileNumberOfComments] forState:UIControlStateNormal];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize sizeMake = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"width %f  height %f",sizeMake.width,sizeMake.height);
    return sizeMake;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark -
#pragma mark - Button actions
-(void)actionMore
{
    
}
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
