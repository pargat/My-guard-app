//
//  MyGuardInAppHelper.h
//  MyGuardApp
//
//  Created by vishnu on 21/11/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAPHelper.h"

@interface MyGuardInAppHelper : IAPHelper

+ (MyGuardInAppHelper *)sharedInstance;

@end
