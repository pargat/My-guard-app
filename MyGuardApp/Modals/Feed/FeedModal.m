//
//  FeedModal.m
//  MyGuardApp
//
//  Created by vishnu on 01/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "FeedModal.h"

@implementation FeedModal


-(id)initWithAttributes:(NSDictionary *)dict
{
    self = [super init];
    if(self!=nil)
    {
        
        self.feed_full_time = [dict valueForKey:@"nice_time"];
        self.feed_id = [dict  valueForKey:@"id"];
        self.feed_username = [dict valueForKey:@"username"];
        self.feed_userid = [dict  valueForKey:@"user_id"];
        self.feed_image = [dict  valueForKey:@"image"];
        self.feed_video = [dict  valueForKey:@"video"];
        self.feed_lat = [dict valueForKey:@"latitude"];
        self.feed_lng = [dict  valueForKey:@"longitude"];
        self.feed_type = [dict  valueForKey:@"type"];
        self.feed_createdOn = [dict  valueForKey:@"created_on"];
        self.feed_desc = [dict  valueForKey:@"description"];
        self.feed_place = [dict  valueForKey:@"place"];
        self.feed_imageName = [dict  valueForKey:@"image_name"];
        self.feed_time_passed = [dict valueForKey:@"n_time"];
        
        if(((NSArray *)[dict valueForKey:@"files"]).count==0)
        {
            self.feed_files = [[NSMutableArray alloc] init];
        }
        else
        {
            self.feed_files = [FileModal parseDictToFeed:[dict valueForKey:@"files"]];
        }
        self.feed_address = [dict valueForKey:@"place"];
        self.feed_distance = [dict valueForKey:@"distance"];
        if([dict valueForKey:@"lastname"]!=nil)
            self.feed_fullname = [NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"firstname"],[dict valueForKey:@"lastname"]];
        else
            self.feed_fullname = [NSString stringWithFormat:@"%@",[dict valueForKey:@"firstname"]];
    }
    return self;
}


+(NSMutableArray *)parseDictToFeed : (NSArray *)arrFeed
{
    NSMutableArray *arrayFeed = [[NSMutableArray alloc] init];
    for (int i =0; i<arrFeed.count; i++) {
         FeedModal *modal = [[FeedModal alloc] initWithAttributes:[arrFeed objectAtIndex:i]];
        [arrayFeed addObject:modal];
    }
    
    return arrayFeed;
   
}


#pragma mark - api hit

+(void)callApIForUploadPic : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(bool success))success failure : (void(^)(NSString *errorStr))failure
{
    
    [iOSRequest getJsonResponse:urlStr success:^(NSDictionary *responseDict) {
                success(true);
    } failure:^(NSString *errorString) {
        failure(errorString);
    }];
    
}

+(void)callAPIForFeed : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *feedArr))success failure : (void(^)(NSString *errorStr))failure
{
    
    [iOSRequest getJsonResponse:urlStr success:^(NSDictionary *responseDict) {
        
        NSMutableArray *arrFeed = [self parseDictToFeed:[responseDict valueForKey:@"data"]];
        success(arrFeed);
    } failure:^(NSString *errorString) {
        failure(errorString);
    }];
    
}


@end
