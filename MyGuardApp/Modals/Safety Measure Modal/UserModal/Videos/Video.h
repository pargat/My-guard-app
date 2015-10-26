//
//  Video.h
//  MyGuardApp
//
//  Created by vishnu on 21/09/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiConstants.h"
@interface Video : NSObject

@property (nonatomic,strong) NSString *videoId;
@property (nonatomic,strong) NSString *videoType;
@property (nonatomic,strong) NSString *videoTitle;
@property (nonatomic,strong) NSString *videoDescription;
@property (nonatomic,strong) NSString *videoImageName;
@property (nonatomic,strong) NSString *videoLink;
@property (nonatomic,strong) NSString *videoDisplayTime;
@property (nonatomic,strong) NSString *videoDuration;

+(void)callAPIForVideos : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *videoArr))success failure : (void(^)(NSString *errorStr))failure;


@end
