//
//  MyGuardInAppHelper.m
//  MyGuardApp
//
//  Created by vishnu on 21/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "MyGuardInAppHelper.h"

@implementation MyGuardInAppHelper

+ (MyGuardInAppHelper *)sharedInstance {
    static dispatch_once_t once;
    static MyGuardInAppHelper *sharedInstance;
    dispatch_once(&once, ^{
        NSSet *productIdentifier = [NSSet setWithObjects:INAPP_FIRE_ID,INAPP_SEX_ID,INAPP_CO_ID,
                                    nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifier];
    });
    return sharedInstance;
}


@end
