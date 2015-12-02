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
#pragma mark -
#pragma mark - lat long calculating formula

+(NSArray *)getBoundingBox:(double)kilometers lat:(double)lat lon:(double)lon
{
    double R = 6371; // earth radius in km
    double lat1 = lat - (M_PI/180) *(kilometers / R);
    double lon1 = lon - (M_PI/180) *(kilometers / R / cos(lat*180/M_PI));
    double lat2 = lat + (M_PI/180) *(kilometers / R);
    double lon2 = lon +(M_PI/180) *(kilometers / R / cos(lat*180/M_PI));
    return @[[NSString stringWithFormat:@"%f",lat1],[NSString stringWithFormat:@"%f",lat2],[NSString stringWithFormat:@"%f",lon1],[NSString stringWithFormat:@"%f",lon2]];
}


#pragma mark -
#pragma mark - View Controller getters
+(UIViewController*) currentViewController {
    
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [CommonFunctions findBestViewController:viewController];
    
}
+(UIViewController*) findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [CommonFunctions findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [CommonFunctions findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [CommonFunctions findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [CommonFunctions findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
    
}
@end
