//
//  MapViewController.h
//  MyGuardApp
//
//  Created by vishnu on 13/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "FeedModal.h"
#import "ApiConstants.h"
#import <UIImageView+WebCache.h>

@interface MapViewController : UIViewController<AVSpeechSynthesizerDelegate>

@property (nonatomic,strong) NSString *stringSpeech;
@property (nonatomic,strong) AVSpeechSynthesizer *synth;
@property (nonatomic,strong) NSDictionary *dictInfo;
@property (nonatomic,strong) FeedModal *feed;
@property (weak, nonatomic) IBOutlet UIView *viewMapHolder;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDp;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription1;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewType;
@property (weak, nonatomic) IBOutlet UIButton *btnHush;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;


- (IBAction)actionHush:(id)sender;

@end
