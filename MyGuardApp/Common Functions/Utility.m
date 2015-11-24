//
//  Utility.m
//  MyGuardApp
//
//  Created by vishnu on 21/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "Utility.h"

@implementation Utility


+(void)alert:(NSString *)stringTitle msg:(NSString *)stringMessage
{
    [[[UIAlertView alloc] initWithTitle:stringTitle message:stringMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}
@end
