//
//  User.m
//  MyGuardApp
//
//  Created by vishnu on 19/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "User.h"

@implementation User

-(id)initWithAttributes:(NSDictionary *)tempDict
{
    self = [super init];
    if(self!=nil)
    {
        
        self.userAddress = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"address"]];
        self.UserDisability = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"disability"]];
        self.userDOB = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"dob"]];
        self.userEmail = [tempDict valueForKey:@"email"];
        self.userFirstName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"firstname"]];
        self.userGender = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"gender"]];
        self.userImageName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"image_name"]];
        self.userIsFamily = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"is_family"]];
        self.userIsFriend = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"is_friend"]];
        self.UserLastName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"lastname"]];
        self.userLatitude = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"latitude"]];
        self.userLongitude = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"longitude"]];
        self.userPhoneNumber = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"phone_no"]];
        self.userUserId = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"id"]];
        self.userUserName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"username"]];
    }
    return self;
}


+(NSMutableArray *)parseDictToModal : (NSArray *)tempArr {
    NSMutableArray *userArr = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *tempDict in tempArr) {
        
        [userArr addObject:[[User alloc]initWithAttributes:tempDict]];
    }
    return userArr;
}


#pragma mark - api hit                                                                                                                      

+(void)callAPIForCommunityUser : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *safetyArr))success failure : (void(^)(NSString *errorStr))failure
{
    
    [iOSRequest getJsonResponse:urlStr success:^(NSDictionary *responseDict) {
        
        NSMutableArray *arrayUsers = [User parseDictToModal:[responseDict valueForKeyPath:@"data"]];
        success(arrayUsers);
    } failure:^(NSString *errorString) {
        failure(errorString);
    }];
    
}



@end
