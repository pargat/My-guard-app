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
    [self getFeed:YES];
    [self.tableViewFeeds setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}


#pragma mark -
#pragma mark - api related and helper function
-(void)getFeed : (BOOL)refresh
{
 
    
    Profile *profileD = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    NSString *strUrl = [NSString stringWithFormat:KGetAlarms,KbaseUrl,profileD.profileUserId,self.feedType,self.pageIndex,TIMEOFFSET];
    
    [FeedModal callAPIForFeed:strUrl Params:nil success:^(NSMutableArray *feedArr) {
        
        if(refresh)
        {
            self.arrayFeeds = [[NSMutableArray alloc] initWithArray:feedArr];
            [self.tableViewFeeds reloadData];
        }
        
    } failure:^(NSString *errorStr) {
        
    }];
    //self.arrayFeeds =
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
#pragma mark - Table View Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayFeeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedMainCell"];
    
    [self configureMapCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(FeedMainCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    
    UIBezierPath *shadowPath1 = [UIBezierPath bezierPathWithRect:cell.viewShadow.bounds];
    
    UIBezierPath *shadowPath  = [UIBezierPath bezierPathWithRect:cell.viewOverlay.bounds];
    cell.viewOverlay.layer.masksToBounds = NO;
    cell.viewOverlay.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.viewOverlay.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    cell.viewOverlay.layer.shadowOpacity = 0.75f;
    cell.viewOverlay.layer.shadowPath = shadowPath.CGPath;
    
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
    [cell.imageViewMap sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&zoom=14&size=%dx%d&markers=icon:%@|label:C|size=mid|%@,%@",modal.feed_lat,modal.feed_lng,(int)(self.view.frame.size.width*DisplayScale),(int)(161*DisplayScale),self.markerUrl,modal.feed_lat,modal.feed_lng] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:KBaseTimbthumbUrl,modal.feed_imageName,cell.imageViewDp.frame.size.width*DisplayScale,cell.imageViewDp.frame.size.width*DisplayScale]]];
    [cell.labelName setText:modal.feed_fullname];
    [cell.labelDistance setText:@"1.5 mi away"];
    [cell.labelTimeSince setText:@"2 m"];
    cell.arrayFiles = [modal.feed_files copy];
    
    
    
    
    
    UIBezierPath *shadowPath1;
    
    
    if(modal.feed_files.count==0)
    {
        cell.heightCollctionView.constant = 0;
        [cell.collectionViewImages setHidden:YES];
    }
    else
    {
        cell.heightCollctionView.constant = 100;
        [cell.collectionViewImages setHidden:NO];
        [cell setDelegateAndData];

    }
    

    

    [cell.labelAddress setText:modal.feed_address];
    [cell.labelTimeDetail setText:modal.feed_time_passed];
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
    

    //Gradient
//    [cell.viewGradient setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.08]];
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = CGRectMake(0, 0, cell.viewGradient.frame.size.width, cell.viewGradient.frame.size.height/2);
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0 alpha:0.33]CGColor],(id)[[UIColor colorWithWhite:0 alpha:0.08]CGColor], nil];
//    [cell.viewGradient.layer addSublayer:gradient];
//    cell.viewGradient.clipsToBounds = YES;
    
    
    


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
    
    [self presentViewController:pickerController animated:YES completion:^{
        
    }];

}
#pragma mark - image picker delegate

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    
//
//    
//    
//   // [self setUpLoaderView];
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    
//    NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
//    
//    
//    if([mediaType isEqualToString:(NSString *)kUTTypeImage])
//    {
//        
//        CGSize size = CGSizeMake(600, 800);
//        
//        UIImage *imageOriginal = [info valueForKey:UIImagePickerControllerOriginalImage];
//        imageOriginal = [imageOriginal imageByScalingAndCroppingForSize:size];
//        NSData *imageData = UIImageJPEGRepresentation(imageOriginal, 0.5);
//        
//        NSDictionary *dict = @{@"id":feed.feed_id};
//        [iOSRequest postImageAlarm:[NSString stringWithFormat:KUpdateAlarm,KbaseUrl] parameters:dict imageData:imageData success:^(NSDictionary *responseStr) {
//            
//            NSInteger indexPath = self.selectedCell;
//            feedModal *feed = [self.feedsArr objectAtIndex:indexPath];
//            NSMutableArray *arrayMut = [NSMutableArray arrayWithArray:feed.feed_files];
//            [arrayMut insertObject:[[responseStr valueForKey:@"data"] objectAtIndex:0] atIndex:0];
//            feed.feed_files = [NSArray arrayWithArray:arrayMut];
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [loaderObj removeFromSuperview];
//            
//        } failure:^(NSError *error) {
//            [loaderObj removeFromSuperview];
//        }];
//    }
//    
//    else
//    {
//        NSURL *url1 = [info objectForKey:
//                       UIImagePickerControllerMediaURL] ;
//        
//        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url1 options:nil];
//        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
//        
//        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetLowQuality];
//        
//        
//        NSString *tmpDirectory = NSTemporaryDirectory();
//        
//        NSString *tmpFile = [tmpDirectory stringByAppendingPathComponent:@"crazy11"];
//        [[NSFileManager defaultManager] removeItemAtPath:tmpFile error:nil];
//        
//        exportSession.outputURL = [NSURL fileURLWithPath:tmpFile];
//        //set the output file format if you want to make it in other file format (ex .3gp)
//        exportSession.outputFileType = AVFileTypeMPEG4;
//        exportSession.shouldOptimizeForNetworkUse = YES;
//        
//        [exportSession exportAsynchronouslyWithCompletionHandler:^{
//            switch ([exportSession status])
//            {
//                case AVAssetExportSessionStatusFailed:
//                    NSLog(@"Export session failed");
//                    break;
//                case AVAssetExportSessionStatusCancelled:
//                    NSLog(@"Export canceled");
//                    break;
//                case AVAssetExportSessionStatusCompleted:
//                {
//                    //Video conversion finished
//                    NSLog(@"Successful!");
//                    
//                    NSData *videoData = [NSData dataWithContentsOfFile:tmpFile];
//                    NSDictionary *dict = @{@"id":feed.feed_id};
//                    [[NSFileManager defaultManager] removeItemAtPath:tmpFile error:nil];
//                    
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//                        UIImage *thumbImage = [self generateThumbImage:[info objectForKey:
//                                                                        UIImagePickerControllerMediaURL]];
//                        NSData *thumbData = UIImageJPEGRepresentation(thumbImage, 1);
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            
//                            [iOSRequest postVideoAlarm:[NSString stringWithFormat:KUpdateAlarm,KbaseUrl] parameters:dict videoData:videoData thumbData:thumbData success:^(NSDictionary *responseStr) {
//                                
//                                NSInteger indexPath = self.selectedCell;
//                                feedModal *feed = [self.feedsArr objectAtIndex:indexPath];
//                                NSMutableArray *arrayMut = [NSMutableArray arrayWithArray:feed.feed_files];
//                                [arrayMut insertObject:[[responseStr valueForKey:@"data"] objectAtIndex:0] atIndex:0];
//                                feed.feed_files = [NSArray arrayWithArray:arrayMut];
//                                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//                                [loaderObj removeFromSuperview];
//                            } failure:^(NSError *error) {
//                                [loaderObj removeFromSuperview];
//                            }];
//                            
//                            
//                        });
//                    });
//                    
//                }
//                    break;
//                default:
//                    break;
//            }
//        }];
//        
//        
//        
//        
//        
//    }
//    
//    
//    
//}
//
//

#pragma mark -
#pragma mark -  Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedModal *modal = [self.arrayFeeds objectAtIndex:indexPath.row];
    if(modal.feed_files.count==0)
    {
        return 293;
    }
    else
    {
        return 393;
    }
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
