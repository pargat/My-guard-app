//
//  YoutubeViewController.h
//  FireSonar
//
//  Created by CB Labs_1 on 11/03/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface YoutubeViewController : BaseViewController<UIWebViewDelegate>
@property(nonatomic,strong) NSString *stringLink;
@property (weak, nonatomic) IBOutlet UIWebView *webViewVideo;
@end
