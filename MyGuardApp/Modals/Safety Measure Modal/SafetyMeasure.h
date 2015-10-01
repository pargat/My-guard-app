//
//  SafetyMeasure.h
//  MyGuardApp
//
//  Created by vishnu on 18/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iOSRequest.h"

@interface SafetyMeasure : NSObject

@property (nonatomic,strong) NSString *safetyDescription;
@property (nonatomic,strong) NSString *safetyFirstName;
@property (nonatomic,strong) NSString *safetyLastName;
@property (nonatomic,strong) NSString *safetyUsername;
@property (nonatomic,strong) NSString *safetyId;
@property (nonatomic,strong) NSString *safetyUserId;
@property (nonatomic,strong) NSString *safetyType;
@property (nonatomic,strong) NSString *safetyImageName;
@property (nonatomic,strong) NSString *safetyDisplayTime;


-(id)initWithAttributes:(NSDictionary *)tempDict;
+(NSMutableArray *)parseDictToModal : (NSArray *)tempArr;
+(void)callAPIForSafetyMeasure : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *safetyArr))success failure : (void(^)(NSString *errorStr))failure;
+(void)callAPIForSafetyMeasureOfUserSelf : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *safetyArr))success failure : (void(^)(NSString *errorStr))failure;


@end
