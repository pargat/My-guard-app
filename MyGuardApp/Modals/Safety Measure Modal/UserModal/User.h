//
//  User.h
//  MyGuardApp
//
//  Created by vishnu on 19/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiConstants.h"

@interface User : NSObject

@property (nonatomic,strong) NSString *userDistance;
@property (nonatomic,strong) NSString *userAddress;
@property (nonatomic,strong) NSString *userUserId;
@property (nonatomic,strong) NSString *userIsFamily;
@property (nonatomic,strong) NSString *userIsFriend;
@property (nonatomic,strong) NSString *userDOB;
@property (nonatomic,strong) NSString *userEmail;
@property (nonatomic,strong) NSString *userFirstName;
@property (nonatomic,strong) NSString *userGender;
@property (nonatomic,strong) NSString *UserDisability;
@property (nonatomic,strong) NSString *UserLastName;
@property (nonatomic,strong) NSString *userImageName;
@property (nonatomic,strong) NSString *userLatitude;
@property (nonatomic,strong) NSString *userLongitude;
@property (nonatomic,strong) NSString *userPhoneNumber;
@property (nonatomic,strong) NSString *userUserName;

+(NSMutableArray *)parseDictToModal : (NSArray *)tempArr;
+(void)callAPIForCommunityUser : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *safetyArr))success failure : (void(^)(NSString *errorStr))failure;

@end
