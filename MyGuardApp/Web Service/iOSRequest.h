//
//  iOSRequest.h
//  Mp-3
//
//  Created by HeLLs GAtE on 12/06/14.
//  Copyright (c) 2014 codebrew labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface iOSRequest : NSObject


+(void)getJsonResponse : (NSString *)urlStr success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSString * errorString))failure;


+(void)getStringResponse : (NSString *)urlStr success : (void (^)(NSString *responseStr))success failure:(void(^)(NSError* error))failure;
+(void)postNormalData :(NSDictionary *)parameters :(NSString *)urlStr  success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure;
+(void)postMultipart : (NSDictionary *)parameters :(NSArray *)images :(NSString *)urlStr success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure;


+(void)postImageAlarm : (NSString *)url parameters:(NSDictionary *)dparameters imageData:(NSData *)dimageData success: (void (^) (NSDictionary *responseStr))success failure: (void (^) (NSError *error))failure;
+(void)postVideoAlarm : (NSString *)url parameters:(NSDictionary *)dparameters videoData:(NSData *)dVideoData thumbData:(NSData *)thumbData success: (void (^) (NSDictionary *responseStr))success failure: (void (^) (NSError *error))failure;
+(void)uploadData : (NSString *)url parameters:(NSDictionary *)dparameters imageData:(NSData *)dimageData success: (void (^) (NSDictionary *responseStr))success failure: (void (^) (NSError *error))failure;
+(void)postNormalData1 :(NSDictionary *)parameters  str:(NSString *)urlStr  success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure;


@end