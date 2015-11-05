//
//  AppDelegate.h
//  MyGuardApp
//
//  Created by vishnu on 05/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//
//Mythingk9
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FBSDKCoreKit.h>
#import "iOSRequest.h"
#import "ApiConstants.h"
#import "Profile.h"
#import <GoogleMaps/GoogleMaps.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

