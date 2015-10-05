//
//  FeedModal.h
//  MyGuardApp
//
//  Created by vishnu on 01/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiConstants.h"

@interface FeedModal : NSObject


@property(nonatomic,retain)NSString *feed_fullname;
@property(nonatomic,retain)NSString *feed_id ;
@property(nonatomic,retain)NSString *feed_userid ;
@property(nonatomic,retain)NSString *feed_video ;
@property(nonatomic,retain)NSString *feed_image ;
@property(nonatomic,retain)NSString *feed_imageName ;
@property(nonatomic,retain)NSString *feed_username;
@property(nonatomic,retain)NSString *feed_lat ;
@property(nonatomic,retain)NSString *feed_lng ;
@property(nonatomic,retain)NSString *feed_type ;
@property(nonatomic,retain)NSString *feed_createdOn ;
@property(nonatomic,retain)NSString *feed_desc ;
@property(nonatomic,retain)NSString *feed_place ;
@property(nonatomic,retain)NSString *feed_address;

//Changes
@property (nonatomic,retain)NSString *feed_time_passed;
@property (nonatomic,retain)NSArray *feed_files;


//Functions
+(void)callAPIForFeed : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *feedArr))success failure : (void(^)(NSString *errorStr))failure;
-(id)initWithAttributes:(NSDictionary *)dict;
+(void)callApIForUploadPic : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(bool success))success failure : (void(^)(NSString *errorStr))failure;

@end
