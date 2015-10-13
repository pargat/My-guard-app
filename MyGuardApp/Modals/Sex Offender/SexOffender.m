//
//  SexOffender.m
//  MyGuardApp
//
//  Created by vishnu on 09/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SexOffender.h"

@implementation SexOffender



-(id)initWithAttributes:(NSDictionary *)tempDict
{
    self = [super init];
    if(self!=nil)
    {
        
        self.offenderAge = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"age"]];
        self.offenderCity = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"city"]];
        self.offenderCounty = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"county"]];
        self.offenderDob = [tempDict valueForKey:@"dob"];
        self.offenderEye = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"eye"]];
        self.offenderFirstName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"firstname"]];
        self.offenderHair = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"hair"]];
        self.offenderHeight = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"height"]];
        self.offenderId = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"offenderid"]];
        self.offenderLastName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"lastname"]];
        self.offenderLatitude = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"latitude"]];
        self.offenderLongitude = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"longitude"]];
        self.offenderMatchType = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"matchtype"]];
        self.offenderMiddleName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"middlename"]];
        self.offenderName = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"name"]];
        self.offenderPhoto = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"photo"]];
        self.offenderRace = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"race"]];
        self.offenderSex = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"sex"]];
        self.offenderState = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"state"]];
        self.offenderStreet1 = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"street1"]];
        self.offenderStreet2 = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"street2"]];

        self.offenderWeight = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"weight"]];
        self.offenderZipCode = [NSString stringWithFormat:@"%@", [tempDict valueForKey:@"zipcode"]];
        
        self.offenderAddress = [NSString stringWithFormat:@"%@ \n%@\n%@,%@", self.offenderStreet1,self.offenderStreet2,self.offenderCity,self.offenderState];

    }
    return self;
}




+(NSMutableArray *)parseDictToModal : (NSArray *)tempArr {
    NSMutableArray *userArr = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *tempDict in tempArr) {
        
        [userArr addObject:[[SexOffender alloc]initWithAttributes:tempDict]];
    }
    return userArr;
}

#pragma mark - api hit

+(void)callAPIForSexOffenders : (NSString *)urlStr  Params : (NSDictionary *)paramsDict success : (void(^)(NSMutableArray *offenderArr))success failure : (void(^)(NSString *errorStr))failure
{
    
    [iOSRequest getJsonResponse:urlStr success:^(NSDictionary *responseDict) {
        
        NSMutableArray *arrayOffenders = [SexOffender parseDictToModal:[responseDict valueForKeyPath:@"offenders"]];
        success(arrayOffenders);
    } failure:^(NSString *errorString) {
        failure(errorString);
    }];
    
}



@end
