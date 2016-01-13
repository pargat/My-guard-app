//
//  MissingModal.h
//  MyGuardApp
//
//  Created by vishnu on 13/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iOSRequest.h"

@interface MissingModal : NSObject


@property (nonatomic, strong) NSString *missingId;
@property (nonatomic, strong) NSString *missingName;
@property (nonatomic, strong) NSString *missingImage;
@property (nonatomic, strong) NSString *missingDescription;
@property (nonatomic, strong) NSString *missingLocation;
@property (nonatomic, strong) NSString *missingLat;
@property (nonatomic, strong) NSString *missingLng;
@property (nonatomic, strong) NSString *missingDate;
@property (nonatomic, strong) NSString *missingCreatedOn;
@property (nonatomic, strong) NSString *missingUserId;

+(void)callAPIForMissing : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *offenderArr))success failure : (void(^)(NSString *errorStr))failure;


@end
