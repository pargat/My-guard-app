//
//  FeedViewController.m
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()



@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 0;
    [self setUpLoaderView1];
    [self getFeed:YES];
    [self.tableViewFeeds setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addRefreshAndInfinite];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.delegate delChangeNavButton:NO];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeLoaderView];
}

#pragma mark -
#pragma mark - api related and helper function
-(void)addRefreshAndInfinite
{
    [self.tableViewFeeds addPullToRefreshWithActionHandler:^{
        self.pageIndex = 0;
        [self getFeed:YES];
    }];
    
    [self.tableViewFeeds addInfiniteScrollingWithActionHandler:^{
        self.pageIndex++;
        [self getFeed:NO];
    }];
    
}
-(void)getFeed : (BOOL)refresh
{
 
    
    Profile *profileD = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    NSString *strUrl = [NSString stringWithFormat:KGetAlarms,KbaseUrl,profileD.profileUserId,self.feedType,self.pageIndex,TIMEOFFSET];
    
    [FeedModal callAPIForFeed:strUrl Params:nil success:^(NSMutableArray *feedArr) {
        
        if(refresh)
        {
            self.arrayFeeds = [[NSMutableArray alloc] initWithArray:feedArr];
            [self.tableViewFeeds.pullToRefreshView stopAnimating];
        }
        else
        {
            [self.arrayFeeds addObjectsFromArray:feedArr];
            [self.tableViewFeeds.infiniteScrollingView stopAnimating];
        }
        [self.tableViewFeeds reloadData];

        [self removeLoaderView];
    } failure:^(NSString *errorStr) {
        [self removeLoaderView];
    }];
   
}


#pragma mark -
#pragma mark - XlChild

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{

    return NSLocalizedString(@"feed", nil);
}

#pragma mark -
#pragma mark - Scroll View Delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    if(velocity.y<0&&targetContentOffset->y==0)
    {
        [self.delegate delHideShowHeader:NO];
    }
    else
    {
        [self.delegate delHideShowHeader:YES];
    }
    
}

#pragma mark -
#pragma mark - Feed main cell delegate
-(void)delImageCellClicked:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath;
    [self performSegueWithIdentifier:KImageVideoSegue sender:self];
}
-(void)delCameraClicked:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo",@"Choose photo from gallery",@"Take Video",@"Choose Video from gallery",nil];
    [actionSheet showInView:self.view];

}

#pragma mark -
#pragma mark - Table View Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayFeeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedMainCell"];
    
    [self configureMapCell:cell atIndexPath:indexPath];
    cell.selectedPath = indexPath;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    FeedModal *modal = [self.arrayFeeds objectAtIndex:indexPath.row];
    
    if(modal.feed_files.count==0)
    {
        [cell setDataAndDelegateNil];
    }
    else
    {
        [cell setDelegateAndData];
        
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(FeedMainCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    

    
    UIBezierPath *shadowPath  = [UIBezierPath bezierPathWithRect:cell.viewOverlay.bounds];
    cell.viewOverlay.layer.masksToBounds = NO;
    cell.viewOverlay.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.viewOverlay.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    cell.viewOverlay.layer.shadowOpacity = 0.75f;
    cell.viewOverlay.layer.shadowPath = shadowPath.CGPath;
    
    UIBezierPath *shadowPath1 = [UIBezierPath bezierPathWithRect:cell.viewShadow.bounds];
    cell.viewShadow.layer.masksToBounds = NO;
    cell.viewShadow.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.viewShadow.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell.viewShadow.layer.shadowOpacity = 0.75f;
    cell.viewShadow.layer.shadowPath = shadowPath1.CGPath;
}
#pragma mark -
#pragma mark - Table view helpers
-(void)configureMapCell:(FeedMainCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FeedModal *modal = [self.arrayFeeds objectAtIndex:indexPath.row];
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:KBaseTimbthumbUrl,modal.feed_imageName,cell.imageViewDp.frame.size.width*DisplayScale,cell.imageViewDp.frame.size.width*DisplayScale]]];
    [cell.labelName setText:modal.feed_fullname];
    [cell.labelDistance setText:[NSString stringWithFormat:@"%@ away",modal.feed_distance]];
    [cell.labelTimeSince setText:modal.feed_time_passed];

    
    if(modal.feed_files.count==0)
    {
        cell.heightCollctionView.constant = 0;
        [cell.collectionViewImages setHidden:YES];
        cell.arrayFiles = [[NSMutableArray alloc] init];
    }
    else
    {
        cell.heightCollctionView.constant = 100;
        [cell.collectionViewImages setHidden:NO];
        cell.arrayFiles = [modal.feed_files mutableCopy];
    }
    
    
    [cell.heightMap setConstant:12*[[UIScreen mainScreen] bounds].size.width/16];

    if([modal.feed_address isEqualToString:@""]||modal.feed_address==nil)
    {
        [cell.labelAddress setText:@"N.A."];
    }
    else
        [cell.labelAddress setText:modal.feed_address];
    [cell.labelTimeDetail setText:modal.feed_full_time];
    if(self.feedType==1)
    {
        [cell.labelEmergencyName setText:@"Fire"];
        [cell.labelEmergencyName setTextColor:KOrangeColor];

    }
    else if (self.feedType==3)
    {
        [cell.labelEmergencyName setText:@"Gun"];
        [cell.labelEmergencyName setTextColor:KRedColor];
    }
    else
    {
        [cell.labelEmergencyName setText:@"CO Emergency"];
        [cell.labelEmergencyName setTextColor:KGreenColor];
 
    }
    [cell.labelAddress setPreferredMaxLayoutWidth:self.view.frame.size.width - 192];
    

    
    [cell.imageViewMap sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&zoom=14&size=%dx%d&markers=icon:%@|label:C|size=mid|%@,%@",modal.feed_lat,modal.feed_lng,(int)(cell.imageViewMap.frame.size.width*DisplayScale),(int)(cell.imageViewMap.frame.size.height*DisplayScale),self.markerUrl,modal.feed_lat,modal.feed_lng] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

}

#pragma mark - 
#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    [pickerController setDelegate:self];

    if(buttonIndex==0)
    {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

        pickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
        
    }
    
    if(buttonIndex==1)
    {
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary|UIImagePickerControllerSourceTypeSavedPhotosAlbum;

        pickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    }
    if(buttonIndex==2)
    {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
        pickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
    }
    if(buttonIndex==3)
    {

        pickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary|UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
        
    }
    if(buttonIndex==4)
    {
        return;
    }
    [self presentViewController:pickerController animated:YES completion:^{
        
    }];

}

#pragma mark -
#pragma mark - image picker delegate
-(UIImage *)generateThumbImage : (NSURL *)url
{
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = 1;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    

    FeedModal *feed = [self.arrayFeeds objectAtIndex:self.selectedIndex.row];
    
    [self setUpLoaderView1];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    
    
    if([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        
        CGSize size = CGSizeMake(600, 800);
        
        UIImage *imageOriginal = [info valueForKey:UIImagePickerControllerOriginalImage];
        imageOriginal = [imageOriginal imageByScalingAndCroppingForSize:size];
        NSData *imageData = UIImageJPEGRepresentation(imageOriginal, 0.5);
        
        NSDictionary *dict = @{@"id":feed.feed_id,@"user_id":[Profile getCurrentProfileUserId]};
        [iOSRequest postImageAlarm:[NSString stringWithFormat:KUpdateAlarm,KbaseUrl] parameters:dict imageData:imageData success:^(NSDictionary *responseStr) {
            
            NSMutableArray *arrayMut = [NSMutableArray arrayWithArray:feed.feed_files];
            [arrayMut insertObject:[[FileModal alloc] initWithAttributes:[[responseStr valueForKey:@"data"] objectAtIndex:0] ]  atIndex:0];
            feed.feed_files = [NSArray arrayWithArray:arrayMut];
            [self.tableViewFeeds reloadRowsAtIndexPaths:@[self.selectedIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self removeLoaderView];
            
        } failure:^(NSError *error) {
            [self removeLoaderView];        }];
    }
    
    else
    {
        NSURL *url1 = [info objectForKey:
                       UIImagePickerControllerMediaURL] ;
        
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url1 options:nil];
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetLowQuality];
        
        
        NSString *tmpDirectory = NSTemporaryDirectory();
        
        NSString *tmpFile = [tmpDirectory stringByAppendingPathComponent:@"crazy11"];
        [[NSFileManager defaultManager] removeItemAtPath:tmpFile error:nil];
        
        exportSession.outputURL = [NSURL fileURLWithPath:tmpFile];
        //set the output file format if you want to make it in other file format (ex .3gp)
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status])
            {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export session failed");
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    //Video conversion finished
                    NSLog(@"Successful!");
                    
                    NSData *videoData = [NSData dataWithContentsOfFile:tmpFile];
                    NSDictionary *dict = @{@"id":feed.feed_id,@"user_id":[Profile getCurrentProfileUserId],@"duration":[NSString stringWithFormat:@"%f",CMTimeGetSeconds(avAsset.duration)
                                                                                                                        ]};
                    [[NSFileManager defaultManager] removeItemAtPath:tmpFile error:nil];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        UIImage *thumbImage = [self generateThumbImage:[info objectForKey:
                                                                        UIImagePickerControllerMediaURL]];
                        NSData *thumbData = UIImageJPEGRepresentation(thumbImage, 1);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [iOSRequest postVideoAlarm:[NSString stringWithFormat:KUpdateAlarm,KbaseUrl] parameters:dict videoData:videoData thumbData:thumbData success:^(NSDictionary *responseStr) {
                                
                                NSMutableArray *arrayMut = [NSMutableArray arrayWithArray:feed.feed_files];
                                [arrayMut insertObject:[[FileModal alloc] initWithAttributes:[[responseStr valueForKey:@"data"] objectAtIndex:0] ]  atIndex:0];

                                feed.feed_files = [NSArray arrayWithArray:arrayMut];
                                [self.tableViewFeeds reloadRowsAtIndexPaths:@[self.selectedIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                                    [self removeLoaderView];
                            } failure:^(NSError *error) {
                                [self removeLoaderView];
                            }];
                            
                            
                        });
                    });
                    
                }
                    break;
                default:
                    break;
            }
        }];
        
        
        
        
        
    }
    
    
    
}




#pragma mark -
#pragma mark -  Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath;
    [self performSegueWithIdentifier:KMapFeedSegue sender:self];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static FeedMainCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableViewFeeds dequeueReusableCellWithIdentifier:@"FeedMainCell"];
    });
    
    [self configureMapCell:sizingCell atIndexPath:indexPath];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;

}


#pragma mark - Hide Unhide Loader View

-(void)setUpLoaderView1
{
    UIColor *colorProfile;
    if(self.feedType==1)
    {
        colorProfile = KOrangeColor;
    }
    else if (self.feedType==3)
    {
        colorProfile = KRedColor;
    }
    else
    {
        colorProfile = KGreenColor;
    }
    [self setUpLoaderView:colorProfile];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:KMapFeedSegue])
    {
        MapViewController *mapVC = (MapViewController *)segue.destinationViewController;
        mapVC.feed = [self.arrayFeeds objectAtIndex:self.selectedIndex.row];
    }
    else
    {
        ImageVideoViewController *imageVc = (ImageVideoViewController *)segue.destinationViewController;
        imageVc.feedModal = [self.arrayFeeds objectAtIndex:self.selectedIndex.row];
        imageVc.currentTab = self.feedType;
    }
}


@end
