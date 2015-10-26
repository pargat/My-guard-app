//
//  Video.m
//  MyGuardApp
//
//  Created by vishnu on 21/09/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "Video.h"

@implementation Video



-(id)initWithAttributes:(NSDictionary *)tempDict
{
    self = [super init];
    if(self!=nil)
    {
        
        self.videoDescription = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"description"]];
        self.videoDisplayTime = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"nice_time"]];
        self.videoId = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"id"]];
        self.videoImageName = [tempDict valueForKey:@"image_name"];
        self.videoLink = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"video"]];
        self.videoTitle = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"title"]];
        self.videoType = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"type"]];
 ;
        self.videoDuration = [NSString stringWithFormat:@"%@",[tempDict valueForKey:@"duration"]];
    }
    return self;
}

+(NSMutableArray *)parseDictToModal : (NSArray *)tempArr {
    NSMutableArray *videoArr = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *tempDict in tempArr) {
        
        [videoArr addObject:[[Video alloc]initWithAttributes:tempDict]];
    }
    return videoArr;
}


#pragma mark - api hit

+(void)callAPIForVideos : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *videoArr))success failure : (void(^)(NSString *errorStr))failure
{
    
    [iOSRequest getJsonResponse:urlStr success:^(NSDictionary *responseDict) {
        
        NSMutableArray *arrVideo = [Video parseDictToModal:[responseDict valueForKey:@"data"]];
        success(arrVideo);
    } failure:^(NSString *errorString) {
        failure(errorString);
    }];
    
}


@end
