//
//  SearchFeedViewController.m
//  MyGuardApp
//
//  Created by vishnu on 02/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SearchFeedViewController.h"

@interface SearchFeedViewController ()

@end

@implementation SearchFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewHelper];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableViewSearch reloadData];
    [self.tableViewSearch setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    if(self.stringToSearch!=nil)
//    {
//        [self apiSearch:self.stringToSearch];
//    }
}
#pragma mark -
#pragma mark -  View helpers
-(void)viewHelper
{
    self.stringUserID = [Profile getCurrentProfileUserId];
    [self.tableViewSearch setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableViewSearch setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
}
-(void)apiSearch:(NSString *)str
{
    NSString * stringSearchSafety = [NSString stringWithFormat:KSearchNewApi,KbaseUrl,[Profile getCurrentProfileUserId],str,@"1"];
    
    [iOSRequest getJsonResponse:stringSearchSafety success:^(NSDictionary *responseDict) {
        self.arraySearch = [FeedModal parseDictToFeed:[responseDict valueForKey:@"data"]];
        if(self.tableViewSearch.delegate == nil)
        {
            [self.tableViewSearch setDelegate:self];
            [self.tableViewSearch setDataSource:self];
        }

        [self.tableViewSearch reloadData];
        if([[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] isKindOfClass:[JTMaterialSpinner class]])
        {
            [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
            
        }
    } failure:^(NSString *errorString) {
        if([[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] isKindOfClass:[JTMaterialSpinner class]])
        {
            [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
            
        }

    }];
}


#pragma mark -
#pragma mark - XlChild

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return NSLocalizedString(@"feed", nil);
}
#pragma mark -
#pragma mark - Feed main cell delegate
-(void)delImageCellClicked:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:KImageVideoSegue sender:[self.arraySearch objectAtIndex:indexPath.row]];
}
-(void)delCameraClicked:(NSIndexPath *)indexPath
{
    [self.parentViewController.view endEditing:YES];
    self.selectedIndex = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo",@"Choose photo from gallery",@"Take Video",@"Choose Video from gallery",nil];
    [actionSheet showInView:self.view];
    
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
#pragma mark - Table View Datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedModal *modal = [self.arraySearch objectAtIndex:indexPath.row];
    self.selectedIndex = indexPath;
    
    if([modal.feed_is_fake isEqualToString:@"1"])
    {
        [self performSegueWithIdentifier:KImageVideoSegue sender:modal];
    }
    else
    {
        [self performSegueWithIdentifier:KMapFeedSegue sender:modal];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedModal *modal = [self.arraySearch objectAtIndex:indexPath.row];
    
    if([modal.feed_is_fake isEqualToString:@"0"])
    {
        static FeedMainCell *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"FeedMainCell"];
        });
        
        [self configureMapCell:sizingCell atIndexPath:indexPath];
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    }
    else
    {
        static FeedFakeCell *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"FeedFakeCell"];
        });
        
        [self configureFakeCell:sizingCell atIndexPath:indexPath];
        [sizingCell setNeedsLayout];
        [sizingCell layoutIfNeeded];
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arraySearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedModal *modal = [self.arraySearch objectAtIndex:indexPath.row];
    
    if([modal.feed_is_fake isEqualToString:@"0"])
    {
        
        FeedMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedMainCell"];
        
        [self configureMapCell:cell atIndexPath:indexPath];
        cell.selectedPath = indexPath;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setDelegate:self];
        FeedModal *modal = [self.arraySearch objectAtIndex:indexPath.row];
        
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
    else
    {
        FeedFakeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedFakeCell"];
        
        [self configureFakeCell:cell atIndexPath:indexPath];
        cell.selectedPath = indexPath;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setDelegate:self];
        FeedModal *modal = [self.arraySearch objectAtIndex:indexPath.row];
        
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
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(FeedMainCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedModal *modal = [self.arraySearch objectAtIndex:indexPath.row];
    
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    
    
    
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
    FeedModal *modal = [self.arraySearch objectAtIndex:indexPath.row];
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:modal.feed_imageName]];
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
    
        NSString *markerUrl;
    if([modal.feed_type isEqualToString:@"1"])
    {
        markerUrl = KFireIcon;
        
    }
    else if ([modal.feed_type isEqualToString:@"3"])
    {
        markerUrl = KGunIcon;
    }
    else
    {
        markerUrl = KCOIcon;
        
    }
    
    if ([self.stringUserID isEqualToString:modal.feed_userid]) {
        [cell.btnCamera setHidden:NO];
    }
    else
    {
        [cell.btnCamera setHidden:YES];
    }

    
    
    
    [cell.imageViewMap sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&zoom=14&size=%dx%d&markers=icon:%@|label:C|size=mid|%@,%@",modal.feed_lat,modal.feed_lng,(int)(cell.imageViewMap.frame.size.width*DisplayScale),(int)(cell.imageViewMap.frame.size.height*DisplayScale),markerUrl,modal.feed_lat,modal.feed_lng] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
}
-(void)configureFakeCell:(FeedFakeCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FeedModal *modal = [self.arraySearch objectAtIndex:indexPath.row];
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:modal.feed_imageName]];

    [cell.labelName setText:modal.feed_fullname];
    [cell.labelTimeSince setText:modal.feed_time_passed];
    [cell.labelDescription setText:modal.feed_description];
    if(modal.feed_description.length==0)
    {
        cell.layoutBottomDescription.constant = 0;
    }
    else
    {
        cell.layoutBottomDescription.constant = 16;
    }
    [cell.labelDescription setPreferredMaxLayoutWidth:self.view.frame.size.width-48];
    if(modal.feed_files.count<2)
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
        [cell.arrayFiles removeObjectAtIndex:0];
    }
    
    
    [cell.heightMap setConstant:12*[[UIScreen mainScreen] bounds].size.width/16-44];
    FileModal *fileModal = [modal.feed_files firstObject];
    if(fileModal.fileType)
    {
        [cell.btnDuration setHidden:NO];
        [cell.btnDuration setTitle:[NSString stringWithFormat:@" %@",fileModal.fileDuration] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnDuration setHidden:YES];
    }
    [cell.btnCommentCount setTitle:[NSString stringWithFormat:@" %@",fileModal.fileNumberOfComments] forState:UIControlStateNormal];
    [cell.imageViewMap sd_setImageWithURL:[NSURL URLWithString:fileModal.fileThumbCumImageLink]];
    
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
    
    
    FeedModal *feed = [self.arraySearch objectAtIndex:self.selectedIndex.row];
    
    [self setUpLoaderView];
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
            [self.tableViewSearch reloadRowsAtIndexPaths:@[self.selectedIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self removeLoaderView];
            
        } failure:^(NSError *error) {
            [self removeLoaderView];
        }];
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
                        thumbImage = [thumbImage imageByScalingAndCroppingForSize:thumbImage.size];
                        NSData *thumbData = UIImageJPEGRepresentation(thumbImage, 1);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [iOSRequest postVideoAlarm:[NSString stringWithFormat:KUpdateAlarm,KbaseUrl] parameters:dict videoData:videoData thumbData:thumbData success:^(NSDictionary *responseStr) {
                                
                                NSMutableArray *arrayMut = [NSMutableArray arrayWithArray:feed.feed_files];
                                [arrayMut insertObject:[[FileModal alloc] initWithAttributes:[[responseStr valueForKey:@"data"] objectAtIndex:0] ]  atIndex:0];
                                
                                feed.feed_files = [NSArray arrayWithArray:arrayMut];
                                [self.tableViewSearch reloadRowsAtIndexPaths:@[self.selectedIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:KMapFeedSegue])
    {
        MapViewController *mapVC = (MapViewController *)segue.destinationViewController;
        mapVC.feed = (FeedModal *)sender;
    }
    else
    {
        ImageVideoViewController *imageVc = (ImageVideoViewController *)segue.destinationViewController;
        imageVc.feedModal = (FeedModal *)sender;
        FeedModal *modal = (FeedModal *)sender;
        if([modal.feed_type isEqualToString:@"1"])
        {
            imageVc.currentTab = 1;

        }
        else if([modal.feed_type isEqualToString:@"1"])
        {
            imageVc.currentTab = 3;
        }
        else
        {
            imageVc.currentTab = 2;
        }
}

    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
