//
//  CommonFunctions.m
//  MyGuardApp
//
//  Created by vishnu on 20/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "CommonFunctions.h"

@implementation CommonFunctions
+(void)videoPlay
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&setCategoryError]) {
        // handle error
    }
}
+(void)recordAudio
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    if (![session setCategory:AVAudioSessionCategoryRecord
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&setCategoryError]) {
        // handle error
    }

}
+(NSString *)getFullImage:(NSString *)stringLink view:(UIView *)view
{
   return [NSString stringWithFormat:@"%@&w=%f&h=%f",stringLink,view.frame.size.width*DisplayScale,view.frame.size.height*DisplayScale];
}
@end
