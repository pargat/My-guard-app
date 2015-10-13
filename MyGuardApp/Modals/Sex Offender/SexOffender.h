//
//  SexOffender.h
//  MyGuardApp
//
//  Created by vishnu on 09/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iOSRequest.h"

@interface SexOffender : NSObject


@property (nonatomic, strong) NSString *offenderId;
@property (nonatomic, strong) NSString *offenderPhoto;
@property (nonatomic, strong) NSString *offenderName;
@property (nonatomic, strong) NSString *offenderFirstName;
@property (nonatomic, strong) NSString *offenderMiddleName;
@property (nonatomic, strong) NSString *offenderLastName;
@property (nonatomic, strong) NSString *offenderDob;
@property (nonatomic, strong) NSString *offenderAge;
@property (nonatomic, strong) NSString *offenderSex;
@property (nonatomic, strong) NSString *offenderRace;
@property (nonatomic, strong) NSString *offenderHair;
@property (nonatomic, strong) NSString *offenderEye;
@property (nonatomic, strong) NSString *offenderHeight;
@property (nonatomic, strong) NSString *offenderWeight;
@property (nonatomic, strong) NSString *offenderStreet1;
@property (nonatomic, strong) NSString *offenderStreet2;
@property (nonatomic, strong) NSString *offenderCity;
@property (nonatomic, strong) NSString *offenderState;
@property (nonatomic, strong) NSString *offenderZipCode;
@property (nonatomic, strong) NSString *offenderCounty;
@property (nonatomic, strong) NSString *offenderMatchType;
@property (nonatomic, strong) NSString *offenderLatitude;
@property (nonatomic, strong) NSString *offenderLongitude;
@property (nonatomic,strong) NSString *offenderAddress;

+(void)callAPIForSexOffenders : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *offenderArr))success failure : (void(^)(NSString *errorStr))failure;

@end
