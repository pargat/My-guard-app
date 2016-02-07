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
    [self.textViewDescription setText:@""];
    // Do any additional setup after loading the view.
    if(self.stringFeedId!= nil)
    {
        [self getPushAlarm];
        [self setUpLoaderView];
    }
    //    [self.collectionViewMain reloadData];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [self tapDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Text view tap handler
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
    [tap setCancelsTouchesInView:NO];
    [self.textViewDescription addGestureRecognizer:tap];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionViewMain reloadData];
    self.isLoaded = true;
    //self.textViewDescription.textContainer.maximumNumberOfLines = 2;
    
    
    
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if(self.stringFeedId== nil&&!self.isLoaded)
    {
        [self.collectionViewMain reloadData];
        [self.collectionViewMain scrollToItemAtIndexPath:self.indexToScroll atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    }
    
}
#pragma mark -
#pragma mark - View helpers
-(void)tapDetail
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapper)];
    [self.viewDetails addGestureRecognizer:tapGesture];
}
-(void)tapper
{
    self.isViewingDescription = false;
    self.layoutHeight.constant = 128;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        [self.viewOverlay setAlpha:0.0];
        
    } completion:^(BOOL finished) {
        self.textViewDescription.scrollEnabled = NO;
        [self.viewOverlay setHidden:YES];
        
        
    }];
    
    
}
-(void)textTapped:(UITapGestureRecognizer *)tapGesture
{
    if(self.textViewDescription.contentSize.height/self.textViewDescription.font.lineHeight>2)
    {
        if(self.isViewingDescription)
        {
            [self.viewOverlay setHidden:YES];
            self.layoutHeight.constant = 128;
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
                [self.viewOverlay setAlpha:0.0];
                
            } completion:^(BOOL finished) {
                self.textViewDescription.scrollEnabled = NO;
                
            }];
        }
        else
        {
            [self.viewOverlay setHidden:NO];
            // self.textViewDescription.textContainer.maximumNumberOfLines = 0;
            self.layoutHeight.constant = self.view.frame.size.height;
            
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
                [self.viewOverlay setAlpha:0.5];
                
            } completion:^(BOOL finished) {
                self.textViewDescription.scrollEnabled = YES;
                
            }];
            
            
        }
        self.isViewingDescription = !self.isViewingDescription;
    }
}
-(void)getPushAlarm
{
    NSString *stringAlarmUrl = [NSString stringWithFormat:KViewMediaApi,KbaseUrl,self.stringFeedId,self.stringPostId];
    
    
    [iOSRequest getJsonResponse:stringAlarmUrl success:^(NSDictionary *responseDict) {
        
        if([[responseDict valueForKey:@"success"] isEqualToString:@"1"])
        {
        self.arrayFiles = [FileModal parseDictToFeed:[responseDict valueForKeyPath:@"data.files"]];
        if(self.isCommentShow==false)
            [self delCommentClicked:YES indexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        FileModal *modal = [self.arrayFiles objectAtIndex:0];
        [self.btnComment1 setTitle:[NSString stringWithFormat:@"%@ comments",modal.fileNumberOfComments] forState:UIControlStateNormal];
        [self.textViewDescription setText:modal.fileDescription];
        [self.collectionViewMain reloadData];
        }
        [self removeLoaderView];
    } failure:^(NSString *errorString) {
        [self removeLoaderView];
    }];
}

-(void)setNavBar
{
    [self.navigationItem setTitle:@"GunShot"];
    if(self.stringAddress.length>0)
    {
        if(self.currentTab==1)
        {
            [self.navigationItem setTitle:[NSString stringWithFormat:@"Fire Alarm at %@",self.stringAddress]];
        }
        else if (self.currentTab==3)
        {
            [self.navigationItem setTitle:[NSString stringWithFormat:@"Gunshot at %@",self.stringAddress]];
            
        }
        else
        {
            [self.navigationItem setTitle:[NSString stringWithFormat:@"Co Alarm at %@",self.stringAddress]];
        }
    }
    else
    {
        if(self.currentTab==1)
        {
            [self.navigationItem setTitle:[NSString stringWithFormat:@"Fire Alarm"]];
        }
        else if (self.currentTab==3)
        {
            [self.navigationItem setTitle:[NSString stringWithFormat:@"Gunshot"]];
            
        }
        else
        {
            [self.navigationItem setTitle:[NSString stringWithFormat:@"Co Alarm"]];
        }
        
    }
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
-(void)delChange
{
    self.isCommentShowing = false;
    self.commentView.delegate = nil;
    
}
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
            CGRect rec = CGRectMake(32, [[UIScreen mainScreen] bounds].size.height-self.btnComment1.frame.size.height-32, 0, 0);
            [self.commentView setFrame:rec];
            self.commentView.rectToDisappear = rec;
            [self.commentView.imageViewRight setHidden:YES];
            [self.commentView.imageViewLeft setHidden:NO];
            [UIView animateWithDuration:0.25 animations:^{
                [self.commentView setFrame:CGRectMake(0, 20,[[UIScreen mainScreen] bounds].size.width , [[UIScreen mainScreen] bounds].size.height-self.btnComment1.frame.size.height-32)];
                
                
            }];
            
        }
        else
        {
            CGRect rec = CGRectMake([[UIScreen mainScreen] bounds].size.width-32, [[UIScreen mainScreen] bounds].size.height-self.btnComment2.frame.size.height-32, 0, 0);
            [self.commentView setFrame:rec];
            self.commentView.rectToDisappear = rec;
            [self.commentView.imageViewRight setHidden:NO];
            [self.commentView.imageViewLeft setHidden:YES];
            
            [UIView animateWithDuration:0.25 animations:^{
                [self.commentView setFrame:CGRectMake(0, 20,[[UIScreen mainScreen] bounds].size.width , [[UIScreen mainScreen] bounds].size.height-self.btnComment2.frame.size.height-32)];
                
                
            }];
            
            
        }
        NSLog(@"Comment View height %f",self.btnComment1.frame.origin.y);
        self.commentView.delegate = self;
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.commentView];
        [self.commentView setter];
    }
    
}


#pragma mark-
#pragma mark- collection view delegate and datasource

//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if([[[collectionView visibleCells] lastObject] isKindOfClass:[ImageAndVideoDetailCell class]])
//    {
//        ImageAndVideoDetailCell *cell1 = (ImageAndVideoDetailCell *)[[collectionView visibleCells] lastObject];
//    }
//
//
//}
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
    return sizeMake;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *indexPath1 = [[self.collectionViewMain indexPathsForVisibleItems] lastObject];
    FileModal *modal = [self.arrayFiles objectAtIndex:indexPath1.row];
    [self.btnComment1 setTitle:[NSString stringWithFormat:@"%@ comments",modal.fileNumberOfComments] forState:UIControlStateNormal];
    [self.textViewDescription setText:modal.fileDescription];
}

#pragma mark -
#pragma mark -  Sharing
- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    //[sharingItems addObject:[NSURL URLWithString:@"http://www.google.com"]];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark -
#pragma mark - Action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    NSIndexPath *indexPath = [[self.collectionViewMain indexPathsForVisibleItems] lastObject];
    FileModal *modal = [self.arrayFiles objectAtIndex:indexPath.row];

    if(buttonIndex==0)
    {
        [iOSRequest getJsonResponse:[NSString stringWithFormat:KReportImageApi,KbaseUrl,[Profile getCurrentProfileUserId],modal.fileId] success:^(NSDictionary *responseDict) {
            [self showStaticAlert:@"Success" message:@"Reported successfully"];
        } failure:^(NSString *errorString) {
            
        }];
    }
    
    else if (buttonIndex==1&&actionSheet.tag==11)
    {
        [self shareText:nil andImage:nil andUrl:[NSURL URLWithString:[NSString stringWithFormat:@"http://firesonar.com/Image.php?img=%@",modal.fileImageName]]];
    }
}

#pragma mark -
#pragma mark - Button actions
-(void)actionMore
{

        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Report this post",@"Share", nil];
        actionSheet.tag = 11;
        [actionSheet showInView:self.view];
        
}
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)actionComment2:(id)sender {
    if(!self.isCommentShowing)
        [self delCommentClicked:NO indexPath:[[self.collectionViewMain indexPathsForVisibleItems] lastObject]];
}
- (IBAction)actionComment1:(id)sender {
    if(!self.isCommentShowing)
        [self delCommentClicked:YES indexPath:[[self.collectionViewMain indexPathsForVisibleItems] lastObject]];
}
@end
