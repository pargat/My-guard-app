//
//  Profile.h
//  MyGuardApp
//
//  Created by vishnu on 17/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiConstants.h"

@interface Profile : NSObject

@property (nonatomic,strong) NSString *profileAddress;
@property (nonatomic,strong) NSString *profileIsBlocked;
@property (nonatomic,strong) NSString *profileDisability;
@property (nonatomic,strong) NSString *profileDOB;
@property (nonatomic,strong) NSString *profileEmail;
@property (nonatomic,strong) NSString *profileFirstName;
@property (nonatomic,strong) NSString *profileGender;
@property (nonatomic,strong) NSString *profileUserId;
@property (nonatomic,strong) NSString *profileLastName;
@property (nonatomic,strong) NSString *profileImageName;
@property (nonatomic,strong) NSString *profileImageFullLink;
@property (nonatomic,strong) NSString *profileLatitude;
@property (nonatomic,strong) NSString *profileLongitude;
@property (nonatomic,strong) NSString *profilePhoneNumber;
@property (nonatomic,strong) NSString *profileUserName;

-(id)initWithAttributes:(NSDictionary *)tempDict;
+(NSMutableArray *)parseDictToModal : (NSArray *)tempArr;
+(NSString *)getCurrentProfileUserId;
+(NSString *)getCurrentProfile;


@end
