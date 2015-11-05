//
//  NotificationModal.h
//  MyGuardApp
//
//  Created by vishnu on 28/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiConstants.h"

@interface NotificationModal : NSObject

@property (nonatomic, strong) NSString *notifAlarmId;
@property (nonatomic, strong) NSString *notifFirstName;
@property (nonatomic, strong) NSString *notifId;
@property (nonatomic, strong) NSString *notifRefId;
@property (nonatomic, strong) NSString *notifToUser;
@property (nonatomic, strong) NSString *notifFromUser;
@property (nonatomic, strong) NSString *notifType;
@property (nonatomic, strong) NSString *notifIsRead;
@property (nonatomic, strong) NSString *notifText;
@property (nonatomic, strong) NSString *notifTitle;
@property (nonatomic, strong) NSString *notifDp;
@property (nonatomic, strong) NSString *notifTimePassed;

+(void)callAPIForNotifications : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *notifArr))success failure : (void(^)(NSString *errorStr))failure;

@end
