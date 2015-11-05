//
//  PostViewController.m
//  FushApp
//
//  Created by CB Labs_1 on 02/04/15.
//  Copyright (c) 2015 CB Labs_1. All rights reserved.
//

#import "PostViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface PostViewController ()

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBar];
    [self viewHelper];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    [self.textViewContent becomeFirstResponder];
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObservers];
}

#pragma mark -
#pragma mark - View Helpers
-(void)resignKB
{
    [self.textViewContent resignFirstResponder];
}

-(void)viewHelper
{
    self.textViewContent.placeholder = @"Type here";
    self.btnCamera.layer.cornerRadius = self.btnCamera.frame.size.width/2;
    self.btnCamera.clipsToBounds = YES;
    
    if(self.feedType==1)
    {
        [self.btnCamera setBackgroundColor:KOrangeColor];
    }
    else if (self.feedType==3)
    {
        [self.btnCamera setBackgroundColor:KRedColor];
    }
    else
    {
        [self.btnCamera setBackgroundColor:KGreenColor];
    }
    
}
-(void)setNavBar
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    if(self.feedType==1)
    {
        [navigationBar setBarTintColor:KOrangeColor];
    }
    else if (self.feedType==3)
    {
        [navigationBar setBarTintColor:KRedColor];
    }
    else
    {
        [navigationBar setBarTintColor:KGreenColor];
    }
    
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationItem setTitle:NSLocalizedString(@"new_post", nil)];
    [navigationBar setBarStyle:UIBarStyleBlack];
    [navigationBar setTranslucent:NO];
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    UIBarButtonItem *btnPost = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"post", nil) style:UIBarButtonItemStylePlain target:self action:@selector(actionPost)];
    [btnPost setTintColor:[UIColor whiteColor]];
    btnPost.enabled = NO;
    self.navigationItem.rightBarButtonItem = btnPost;
}
#pragma mark -
#pragma mark-KeyBoard Handling
-(void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}
- (void)registerForKeyboardNotifications

{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    
}





- (void)keyboardWasShown:(NSNotification*)aNotification

{
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.layoutTextView.constant = kbSize.height;
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    self.layoutTextView.constant = 0;
}


#pragma mark -
#pragma mark - Image related delegate and helpers
-(void)openCamera
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    [pickerController setDelegate:self];
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    [self presentViewController:pickerController animated:YES completion:^{
        
    }];
}
-(void)openGallery
{
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    [pickerController setDelegate:self];
    //pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary|UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary|UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //    pickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage, nil];
    pickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    [self presentViewController:pickerController animated:YES completion:^{
        
    }];
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
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    
    
    if([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        self.isPostVideo = false;
        //CGSize size = CGSizeMake(600, 800);
        
        self.imagePost = [info valueForKey:UIImagePickerControllerOriginalImage];
        //self.imagePost = [self.imagePost imageByScalingAndCroppingForSize:size];
        
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [self.imagePost imageByScalingAndCroppingForSize:CGSizeMake(self.view.frame.size.width-64,self.view.frame.size.width-64)];
        
        CGFloat oldWidth = textAttachment.image.size.width;
        
        //I'm subtracting 10px to make the image display nicely, accounting
        //for the padding inside the textView
        CGFloat scaleFactor = oldWidth / (self.textViewContent.frame.size.width - 10);
        textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [attributedString appendAttributedString:attrStringWithImage];
        [attributedString appendAttributedString:[[NSAttributedString alloc ] initWithString:self.textViewContent.text]];
        self.textViewContent.attributedText = attributedString;
    }
    
    else
    {
        self.isPostVideo = YES;
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //Video conversion finished
                        NSLog(@"Successful!");
                        self.duration = CMTimeGetSeconds(avAsset.duration);
                        self.videoData = [NSData dataWithContentsOfFile:tmpFile];
                        self.imagePost = [self generateThumbImage:[info objectForKey:
                                                                   UIImagePickerControllerMediaURL]];
                        
                        
                        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
                        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                        textAttachment.image = [self.imagePost imageByScalingAndCroppingForSize:CGSizeMake(self.view.frame.size.width-64,self.view.frame.size.width-64)];
                        
                        CGFloat oldWidth = textAttachment.image.size.width;
                        
                        //I'm subtracting 10px to make the image display nicely, accounting
                        //for the padding inside the textView
                        CGFloat scaleFactor = oldWidth / (self.textViewContent.frame.size.width - 10);
                        textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
                        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
                        [attributedString appendAttributedString:attrStringWithImage];
                        [attributedString appendAttributedString:[[NSAttributedString alloc ] initWithString:self.textViewContent.text]];
                        self.textViewContent.attributedText = attributedString;
                            [self.textViewContent setFont:[UIFont systemFontOfSize:16]];
                    });
                }
                    break;
                default:
                    break;
            }
        }];
        
        
        
        
        
    }
    
    [self.textViewContent setFont:[UIFont systemFontOfSize:16]];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}

#pragma mark -
#pragma mark - Button Actions
- (IBAction)actionCamera:(id)sender {
    [self.view endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo",@"Choose photo from gallery",@"Take Video",@"Choose Video from gallery",nil];
    [actionSheet showInView:self.view];}

- (void)actionPost {
    UIColor *colorProfile;
    if(self.feedType==1)
    {
        colorProfile = KOrangeColor;
    }
    else if (self.feedType==2)
    {
        colorProfile = KGreenColor;
    }
    else
    {
        colorProfile = KRedColor;
    }
    [self setUpLoaderView:colorProfile];
    if(self.isPostVideo)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[Profile getCurrentProfileUserId] forKey:@"user_id"];
        if(self.textViewContent.text.length>1)
            [dict setObject:[self.textViewContent.text substringFromIndex:1] forKey:@"description"];
        else
            [dict setObject:@"" forKey:@"description"];
        [dict setObject:[NSString stringWithFormat:@"%d",self.feedType] forKey:@"type"];
        [dict setObject:[NSString stringWithFormat:@"%d", self.duration] forKey:@"duration"];
        [iOSRequest postVideoAlarm:[NSString stringWithFormat:KPostAlarmApi,KbaseUrl] parameters:dict videoData:self.videoData thumbData:UIImageJPEGRepresentation(self.imagePost, 0.5) success:^(NSDictionary *responseStr) {
            [self showStaticAlert:@"Success" message:@"Media posted successfully"];
            self.isPostVideo = false;
            self.imagePost = nil;
            self.videoData = nil;
            self.navigationItem.rightBarButtonItem.enabled = NO;
             [self.textViewContent setText:@""];
            [self removeLoaderView];
        } failure:^(NSError *error) {
            [self removeLoaderView];
        }];
        
    }
    else
    {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[Profile getCurrentProfileUserId] forKey:@"user_id"];
        if(self.textViewContent.text.length>1)
            [dict setObject:[self.textViewContent.text substringFromIndex:1] forKey:@"description"];
        else
            [dict setObject:@"" forKey:@"description"];
        [dict setObject:[NSString stringWithFormat:@"%d",self.feedType] forKey:@"type"];
        
        
        NSData *dataImage = UIImageJPEGRepresentation(self.imagePost, 0.5);
        [iOSRequest postImageAlarm:[NSString stringWithFormat:KPostAlarmApi,KbaseUrl] parameters:dict imageData:dataImage success:^(NSDictionary *responseStr) {
             [self showStaticAlert:@"Success" message:@"Media posted successfully"];
            self.isPostVideo = false;
            self.imagePost = nil;
            self.videoData = nil;
            self.navigationItem.rightBarButtonItem.enabled = NO;
            [self.textViewContent setText:@""];
            [self removeLoaderView];
            
        } failure:^(NSError *error) {
            [self removeLoaderView];        }];
    }
    
    
    
}

- (void)actionBack {
    [self.textViewContent resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
