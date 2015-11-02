//
//  Profile.m
//  MyGuardApp
//
//  Created by vishnu on 17/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "Profile.h"

@implementation Profile

-(id)initWithAttributes:(NSDictionary *)tempDict
{
    self = [super init];
    if(self!=nil)
    {
        
        self.profileAddress = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"address"]];
        self.profileDisability = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"disability"]];
        self.profileDOB = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"dob"]];
        self.profileEmail = [tempDict valueForKey:@"email"];
        self.profileFirstName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"firstname"]];
        self.profileGender = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"gender"]];
        self.profileImageFullLink = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"image"]];
        self.profileImageName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"image_name"]];
        self.profileIsBlocked = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"block"]];
        self.profileLastName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"lastname"]];
        self.profileLatitude = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"latitude"]];
        self.profileLongitude = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"longitude"]];
        self.profilePhoneNumber = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"phone_no"]];
        self.profileUserId = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"id"]];
        self.profileUserName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"username"]];
        self.profileIsFamily = [tempDict valueForKey:@"is_family"];
        self.profileIsFriend = [tempDict valueForKey:@"is_friend"];
        self.profileFStatus = [tempDict valueForKey:@"fstatus"];
        
    }
    return self;
}

+(NSMutableArray *)parseDictToModal : (NSArray *)tempArr {
    NSMutableArray *profileArr = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *tempDict in tempArr) {
        
        [profileArr addObject:[[Profile alloc]initWithAttributes:tempDict]];
    }
    return profileArr;
}


#pragma mark -
#pragma mark - User related functions
+(NSString *)getCurrentProfileUserId
{
    Profile *modal = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
    return modal.profileUserId;
}
+(NSString *)getCurrentProfile
{
    return [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
}



@end
