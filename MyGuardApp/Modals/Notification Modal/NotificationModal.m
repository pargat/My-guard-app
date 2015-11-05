//
//  NotificationModal.m
//  MyGuardApp
//
//  Created by vishnu on 28/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "NotificationModal.h"

@implementation NotificationModal
-(id)initWithAttributes:(NSDictionary *)tempDict
{
    self = [super init];
    if(self!=nil)
    {
        self.notifAlarmId = [tempDict valueForKey:@"alarm_id"];
        self.notifDp = [tempDict valueForKey:@"image"];
        self.notifFirstName = [tempDict valueForKey:@"firstname"];
        self.notifFromUser = [tempDict valueForKey:@"from_user"];
        self.notifId = [tempDict valueForKey:@"id"];
        self.notifIsRead = [tempDict valueForKey:@"is_read"];
        self.notifRefId = [tempDict valueForKey:@"ref_id"];
        self.notifText = [tempDict valueForKey:@"notification_text"];
        self.notifTimePassed = [tempDict valueForKey:@"nice_time"];
        self.notifTitle = [tempDict valueForKey:@"notification_title"];
        self.notifToUser = [tempDict valueForKey:@"to_user"];
        self.notifType = [tempDict valueForKey:@"notification_type"];
    }
    return self;
}

+(NSMutableArray *)parseDictToModal : (NSArray *)tempArr {
    NSMutableArray *notifArr = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *tempDict in tempArr) {
        
        [notifArr addObject:[[NotificationModal alloc]initWithAttributes:tempDict]];
    }
    return notifArr;
}
#pragma mark -
#pragma mark - api hit

+(void)callAPIForNotifications : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *notifArr))success failure : (void(^)(NSString *errorStr))failure
{
    
    [iOSRequest getJsonResponse:urlStr success:^(NSDictionary *responseDict) {
        
        NSMutableArray *arrayNotif = [NotificationModal parseDictToModal:[responseDict valueForKeyPath:@"notifications"]];
        success(arrayNotif);
    } failure:^(NSString *errorString) {
        failure(errorString);
    }];
    
}

@end
