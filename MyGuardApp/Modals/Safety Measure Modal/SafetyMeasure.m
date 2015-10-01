//
//  SafetyMeasure.m
//  MyGuardApp
//
//  Created by vishnu on 18/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "SafetyMeasure.h"

@implementation SafetyMeasure


-(id)initWithAttributes:(NSDictionary *)tempDict
{
    self = [super init];
    if(self!=nil)
    {
        
        self.safetyDescription = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"description"]];
        self.safetyDisplayTime = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"nice_time"]];
        self.safetyFirstName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"firstname"]];
        self.safetyId = [tempDict valueForKey:@"id"];
        self.safetyImageName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"image_name"]];
        self.safetyLastName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"lastname"]];
        self.safetyType = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"type"]];
        self.safetyUserId = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"user_id"]];
        self.safetyUsername = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"username"]];
        
    }
    return self;
}

+(NSMutableArray *)parseDictToModal : (NSArray *)tempArr {
    NSMutableArray *safetyArr = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *tempDict in tempArr) {
        
        [safetyArr addObject:[[SafetyMeasure alloc]initWithAttributes:tempDict]];
    }
    return safetyArr;
}


#pragma mark - api hit

+(void)callAPIForSafetyMeasure : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *safetyArr))success failure : (void(^)(NSString *errorStr))failure
{
    
    [iOSRequest getJsonResponse:urlStr success:^(NSDictionary *responseDict) {
        
        NSMutableArray *arraySafety = [SafetyMeasure parseDictToModal:[responseDict valueForKey:@"data"]];
        success(arraySafety);
    } failure:^(NSString *errorString) {
        failure(errorString);
    }];
    
}
+(void)callAPIForSafetyMeasureOfUserSelf : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *safetyArr))success failure : (void(^)(NSString *errorStr))failure
{
    
    [iOSRequest getJsonResponse:urlStr success:^(NSDictionary *responseDict) {
        
        NSMutableArray *arraySafety = [SafetyMeasure parseDictToModal:[responseDict valueForKey:@"safety_measures"]];
        success(arraySafety);
    } failure:^(NSString *errorString) {
        failure(errorString);
    }];
    
}


@end
