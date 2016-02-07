//
//  MissingModal.m
//  MyGuardApp
//
//  Created by vishnu on 13/01/16.
//  Copyright © 2016 myguardapps. All rights reserved.
//

#import "MissingModal.h"

@implementation MissingModal


-(id)initWithAttributes:(NSDictionary *)tempDict
{
    self = [super init];
    if(self!=nil)
    {
        
        self.missingCreatedOn = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"createdOn"]];
        self.missingDate = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"date"]];
        self.missingDescription = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"description"]];
        self.missingId = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"id"]];
        self.missingImage = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"image"]];
        self.missingLat = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"lat"]];
        self.missingLng = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"lng"]];
        self.missingLocation = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"location"]];
        self.missingName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"name"]];
        self.missingUserId = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"user_id"]];
        self.missingPhone = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"phone"]];
        self.missingAge = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"age"]];
        self.missingEye = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"eye"]];
        self.missingHair = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"hair"]];
        self.missingHeight = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"height"]];


    }
    return self;
}




+(NSMutableArray *)parseDictToModal : (NSArray *)tempArr {
    NSMutableArray *userArr = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *tempDict in tempArr) {
        
        [userArr addObject:[[MissingModal alloc]initWithAttributes:tempDict]];
    }
    return userArr;
}

#pragma mark - api hit

+(void)callAPIForMissing : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *offenderArr))success failure : (void(^)(NSString *errorStr))failure
{
    
    [iOSRequest getJsonResponse:urlStr success:^(NSDictionary *responseDict) {
        
        NSMutableArray *arrayMissing = [MissingModal parseDictToModal:[responseDict valueForKeyPath:@"data"]];
        success(arrayMissing);
    } failure:^(NSString *errorString) {
        failure(errorString);
    }];
    
}



@end
