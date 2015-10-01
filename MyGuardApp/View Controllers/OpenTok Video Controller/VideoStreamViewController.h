//
//  VideoStreamViewController.h
//  FireSonar
//
//  Created by vishnu on 20/07/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenTok/OpenTok.h>
#import <EZAudio.h>

@interface VideoStreamViewController : UIViewController<OTSessionDelegate,OTPublisherDelegate>

@end
