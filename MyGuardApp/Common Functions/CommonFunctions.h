//
//  CommonFunctions.h
//  MyGuardApp
//
//  Created by vishnu on 20/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "ApiConstants.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface CommonFunctions : NSObject

+(void)videoPlay;
+(void)recordAudio;
+(NSString *)getFullImage:(NSString *)stringLink view:(UIView *)view;
+(NSArray *)getBoundingBox:(double)kilometers lat:(double)lat lon:(double)lon;
+(UIViewController*) currentViewController ;
@end
