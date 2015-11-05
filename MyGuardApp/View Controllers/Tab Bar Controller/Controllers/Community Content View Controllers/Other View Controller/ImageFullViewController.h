//
//  ImageFullViewController.h
//  MyGuardApp
//
//  Created by vishnu on 05/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

@interface ImageFullViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *imageLink;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewMain;

@end
