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
    if(self.stringFeedId!= nil)
    {
        [self getPushAlarm];
        [self setUpLoaderView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.stringFeedId== nil)
    {
        [self.collectionViewMain scrollToItemAtIndexPath:self.indexToScroll atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        
    }
    
    
}
#pragma mark -
#pragma mark - View helpers
-(void)getPushAlarm
{
    NSString *stringAlarmUrl = [NSString stringWithFormat:KViewMediaApi,KbaseUrl,self.stringFeedId,self.stringPostId];
    
    
    [iOSRequest getJsonResponse:stringAlarmUrl success:^(NSDictionary *responseDict) {
        self.arrayFiles = [FileModal parseDictToFeed:[responseDict valueForKeyPath:@"data.files"]];
        if(self.isCommentShow==false)
            [self delCommentClicked:YES indexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.collectionViewMain reloadData];
        [self removeLoaderView];
    } failure:^(NSString *errorString) {
        [self removeLoaderView];
    }];
}
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

#pragma mark -
#pragma mark - Comment delegate
-(void)delCommentPosted
{
    NSIndexPath *indexPath = [[self.collectionViewMain indexPathsForVisibleItems] lastObject];
    FileModal *modal = [self.arrayFiles objectAtIndex:indexPath.row];
    modal.fileNumberOfComments = [NSString stringWithFormat:@"%d",modal.fileNumberOfComments.intValue+1];
    [self.collectionViewMain reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark -
#pragma mark - ImageVideoDelegate
-(void)delVideo:(NSIndexPath *)indexPath
{
    FileModal *modal = [self.arrayFiles objectAtIndex:indexPath.row];
    if(modal.fileType)
    {
        [CommonFunctions videoPlay];
        MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:modal.fileVideoLink]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self presentViewController:moviePlayer animated:YES completion:^{
                
            }];
        });
        
    }
    
}
-(void)delCommentClicked:(BOOL)leftOrRight indexPath:(NSIndexPath *)indexPath
{
    
    if(self.arrayFiles.count>0)
    {
        self.isCommentShowing = true;
        FileModal *modal = [self.arrayFiles objectAtIndex:indexPath.row];
        self.commentView = [[CommentView alloc] init];
        self.commentView.feed_id = self.feed_id;
        self.commentView.image_id = modal.fileId;
        
        if(leftOrRight)
        {
            [self.commentView setFrame:CGRectMake(32, [[UIScreen mainScreen] bounds].size.height-64, 0, 0)];
            self.commentView.rectToDisappear = CGRectMake(32, [[UIScreen mainScreen] bounds].size.height-64, 0, 0);
            [self.commentView.imageViewRight setHidden:YES];
            [self.commentView.imageViewLeft setHidden:NO];
        }
        else
        {
            [self.commentView setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-32, [[UIScreen mainScreen] bounds].size.height-64, 0, 0)];
            self.commentView.rectToDisappear = CGRectMake([[UIScreen mainScreen] bounds].size.width-32, [[UIScreen mainScreen] bounds].size.height-64, 0, 0);
            [self.commentView.imageViewRight setHidden:NO];
            [self.commentView.imageViewLeft setHidden:YES];
            
        }
        [UIView animateWithDuration:0.25 animations:^{
            [self.commentView setFrame:[[UIScreen mainScreen] bounds]];
            
        }];
        self.commentView.delegate = self;
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.commentView];
        [self.commentView setter];
    }
    
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
    cell.indexPath = indexPath;
    [cell setDelegate:self];
    return cell;
    
}
-(void)configureCell:(ImageAndVideoDetailCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FileModal *modal = [self.arrayFiles objectAtIndex:indexPath.row];
    [cell.imageViewMain setImageWithURL:[NSURL URLWithString:modal.fileThumbCumImageLink] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [cell.btnCommentsText setTitle:[NSString stringWithFormat:@"%@ comments",modal.fileNumberOfComments] forState:UIControlStateNormal];
    cell.scrollViewMain.minimumZoomScale = 1.0;
    cell.scrollViewMain.maximumZoomScale = 6.0;
    
    if(modal.fileType)
    {
        [cell.btnVideo setHidden:NO];
        [cell.scrollViewMain setDelegate:nil];
    }
    else
    {
        [cell.btnVideo setHidden:YES];
        [cell.scrollViewMain setDelegate:cell];
    }
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
#pragma mark - Action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        NSIndexPath *indexPath = [[self.collectionViewMain indexPathsForVisibleItems] lastObject];
        FileModal *modal = [self.arrayFiles objectAtIndex:indexPath.row];
        [iOSRequest getJsonResponse:[NSString stringWithFormat:KReportImageApi,KbaseUrl,[Profile getCurrentProfileUserId],modal.fileId] success:^(NSDictionary *responseDict) {
            [self showStaticAlert:@"Success" message:@"Reported successfully"];
        } failure:^(NSString *errorString) {
            
        }];
    }
}

#pragma mark -
#pragma mark - Button actions
-(void)actionMore
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Report this post", nil];
    [actionSheet showInView:self.view];
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
