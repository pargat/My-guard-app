//
//  PostViewController.h
//  FushApp
//
//  Created by CB Labs_1 on 02/04/15.
//  Copyright (c) 2015 CB Labs_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "BaseViewController.h"
#import "UIImage+Extras.h"
#import <AVFoundation/AVFoundation.h>
#import <SZTextView.h>

@interface PostViewController : BaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property int feedType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTextView;
@property (nonatomic,strong) UIImage *imagePost;
@property BOOL isPostVideo;
@property int duration;
@property (nonatomic,strong) NSData *videoData;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet SZTextView *textViewMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnRemove;
- (IBAction)actionRemove:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAddOrRemove;


- (IBAction)actionCamera:(id)sender;

@end
