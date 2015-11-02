//
//  ImageVideoViewController.m
//  MyGuardApp
//
//  Created by vishnu on 15/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "ImageVideoViewController.h"

@interface ImageVideoViewController ()

@end

@implementation ImageVideoViewController

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
    [self setNavBar];
    [self.collectionViewMain reloadData];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}
#pragma mark-
#pragma mark- view helpers
-(void)deleteMedia
{
    [self setupLoaderView1];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSIndexPath *index in self.collectionViewMain.indexPathsForSelectedItems) {
        FileModal *modal = [self.arrayFiles objectAtIndex:index.row];
        [array addObject:modal.fileId];
    }
    NSString *stringIds = [array componentsJoinedByString:@","];
    [iOSRequest getJsonResponse:[NSString stringWithFormat:KRemoveFilesApi,KbaseUrl,[Profile getCurrentProfileUserId],self.feedModal.feed_id,stringIds] success:^(NSDictionary *responseDict) {
        
        self.arrayFiles = [FileModal parseDictToFeed:[responseDict valueForKey:@"data"]];
        [self removeLoaderView];
        [self.collectionViewMain reloadData];
    } failure:^(NSString *errorString) {
        [self removeLoaderView];
        
    }];
}
- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

-(void)setNavBar
{
    if([[Profile getCurrentProfileUserId] isEqualToString:self.feedModal.feed_userid])
    {
        UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(actionEdit)];
        [btnEdit setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = btnEdit;
    }
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    self.navigationItem.title = NSLocalizedString(@"media", nil);
    
    if(self.currentTab==1)
    {
        [self.navigationController.navigationBar setBarTintColor:KOrangeColor];
    }
    else if (self.currentTab==3)
    {
        [self.navigationController.navigationBar setBarTintColor:KRedColor];
    }
    else
    {
        [self.navigationController.navigationBar setBarTintColor:KGreenColor];
    }

    
}
-(void)setNavDone
{
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(actionDone)];
    [btnDone setTintColor:[UIColor whiteColor]];
    [btnDone setEnabled:NO];
    self.navigationItem.rightBarButtonItem = btnDone;
}
-(void)viewHelper
{
    self.btnCamera.layer.cornerRadius = self.btnCamera.frame.size.width/2;
    self.btnCamera.clipsToBounds = YES;

    self.btnCamera.layer.masksToBounds = YES;
    if(self.currentTab==1)
    {
        self.btnCamera.layer.borderColor = KOrangeColor.CGColor;
    }
    else if (self.currentTab==3)
    {
        self.btnCamera.layer.borderColor = KRedColor.CGColor;
    }
    else
    {
        self.btnCamera.layer.borderColor = KGreenColor.CGColor;
    }
    
    self.btnCamera.layer.borderWidth = 1.0;
    
    self.collectionViewMain.allowsMultipleSelection = true;
    self.arrayFiles = [self.feedModal.feed_files mutableCopy];
    [self.collectionViewMain setDelegate:self];
    [self.collectionViewMain setDataSource:self];
    
    
    
    
    
}

#pragma mark-
#pragma mark- collection view delegate and datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayFiles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageAndVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageAndVideoCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}
-(void)configureCell:(ImageAndVideoCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FileModal *modal = [self.arrayFiles objectAtIndex:indexPath.row];
    [cell.imageViewMain sd_setImageWithURL:[NSURL URLWithString:modal.fileThumbCumImageLink]];
    if(modal.fileType)
    {
        [cell.btnVideo setHidden:NO];
    }
    else
    {
        [cell.btnVideo setHidden:YES];
    }
    if(self.isEditing&&cell.isSelected)
    {
        [cell.imageViewSelected setHidden:NO];
    }
    else
    {
        [cell.imageViewSelected setHidden:YES];
    }
    if(self.currentTab==1)
    {
        [cell.imageViewSelected setImage:[UIImage imageNamed:@"tick_fire.png"]];
    }
    else if (self.currentTab==2)
    {
        [cell.imageViewSelected setImage:[UIImage imageNamed:@"tick_co.png"]];
    }
    else
    {
        [cell.imageViewSelected setImage:[UIImage imageNamed:@"tick_gun.png"]];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize sizeMake = CGSizeMake(self.view.frame.size.width/3, self.view.frame.size.width/3);
    return sizeMake;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ImageAndVideoCell *cell = (ImageAndVideoCell *)[self.collectionViewMain cellForItemAtIndexPath:indexPath];
    [cell.imageViewSelected setHidden:YES];
    if(self.isEditing == NO)
    {
        FileModal *fileModal = [self.arrayFiles objectAtIndex:indexPath.row];
        if(fileModal.fileType)
        {
            MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:fileModal.fileVideoLink]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                [self presentViewController:moviePlayer animated:YES completion:^{
                    
                }];
            });
            
        }
        else
        {
            self.selectedIndex = indexPath;
            [self performSegueWithIdentifier:KImageVideoDetailSegue sender:self];
        }
    }

    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isEditing == NO)
    {
        FileModal *fileModal = [self.arrayFiles objectAtIndex:indexPath.row];
        if(fileModal.fileType)
        {
            MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:fileModal.fileVideoLink]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                [self presentViewController:moviePlayer animated:YES completion:^{
                    
                }];
            });
            
        }
        else
        {
            self.selectedIndex = indexPath;
            [self performSegueWithIdentifier:KImageVideoDetailSegue sender:self];
        }
    }
    else
    {
        
        ImageAndVideoCell *cell = (ImageAndVideoCell *)[self.collectionViewMain cellForItemAtIndexPath:indexPath];
        [cell.imageViewSelected setHidden:NO];
        if([self.collectionViewMain indexPathsForSelectedItems].count>0)
        {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
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
    [self setupLoaderView1];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    
    
    if([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        
        CGSize size = CGSizeMake(600, 800);
        
        UIImage *imageOriginal = [info valueForKey:UIImagePickerControllerOriginalImage];
        imageOriginal = [imageOriginal imageByScalingAndCroppingForSize:size];
        NSData *imageData = UIImageJPEGRepresentation(imageOriginal, 0.5);
        
        NSDictionary *dict = @{@"id":self.feedModal.feed_id,@"user_id":[Profile getCurrentProfileUserId]};
        [iOSRequest postImageAlarm:[NSString stringWithFormat:KUpdateAlarm,KbaseUrl] parameters:dict imageData:imageData success:^(NSDictionary *responseStr) {
            
            [self.arrayFiles insertObject:[[FileModal alloc] initWithAttributes:[[responseStr valueForKey:@"data"] objectAtIndex:0] ]  atIndex:0];
            [self.collectionViewMain reloadData];
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
                    NSDictionary *dict = @{@"id":self.feedModal.feed_id,@"user_id":[Profile getCurrentProfileUserId],@"duration":[NSString stringWithFormat:@"%f",CMTimeGetSeconds(avAsset.duration)
                                                                                                                                  ]};
                    [[NSFileManager defaultManager] removeItemAtPath:tmpFile error:nil];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        UIImage *thumbImage = [self generateThumbImage:[info objectForKey:
                                                                        UIImagePickerControllerMediaURL]];
                        NSData *thumbData = UIImageJPEGRepresentation(thumbImage, 1);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [iOSRequest postVideoAlarm:[NSString stringWithFormat:KUpdateAlarm,KbaseUrl] parameters:dict videoData:videoData thumbData:thumbData success:^(NSDictionary *responseStr) {
                                
                                
                                [self.arrayFiles insertObject:[[FileModal alloc] initWithAttributes:[[responseStr valueForKey:@"data"] objectAtIndex:0] ]  atIndex:0];
                                [self.collectionViewMain reloadData];
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
#pragma mark - Button actions
- (IBAction)actionCamera:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo",@"Choose photo from gallery",@"Take Video",@"Choose Video from gallery",nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionEdit
{
    
    self.isEditing = YES;
    [self setNavDone];
}
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)actionDone
{
    [self deleteMedia];
    self.isEditing = NO;
    [self.collectionViewMain reloadData];
    [self setNavBar];
    
}

#pragma mark - 
#pragma mark - loader
-(void)setupLoaderView1
{
    UIColor *colorProfile ;
    if(self.currentTab==1)
    {
        colorProfile = KOrangeColor;
    }
    else if (self.currentTab==3)
    {
        colorProfile = KRedColor;
    }
    else
    {
        colorProfile = KGreenColor;
    }
    
    [self setUpLoaderView:colorProfile];

}

#pragma mark -
 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:KImageVideoDetailSegue])
     {
         ImageVideoDetailViewController *imageVc = (ImageVideoDetailViewController *)segue.destinationViewController;
         imageVc.indexToScroll = self.selectedIndex;
         imageVc.arrayFiles = self.arrayFiles;
         imageVc.feed_id = self.feedModal.feed_id;
     }

 }


@end
