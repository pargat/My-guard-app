//
//  AppDelegate.m
//  MyGuardApp
//
//  Created by vishnu on 05/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    

    
    if([launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey]!=nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey] forKey:@"pushInfo"];
    }
    [GMSServices provideAPIKey:@"AIzaSyD34jykbce1qf8oS-EqqkTx-NvtPXX8M6w"];
    // Override point for customization after application launch.
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[NSUserDefaults standardUserDefaults] rm_setCustomObject:nil forKey:@"sex_loc"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Demo"];
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.myguardapps.MyGuardApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyGuardApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MyGuardApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}




#pragma mark -
#pragma mark - Push Notification functions

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    
    
    application.applicationIconBadgeNumber = 0;
    
    // Get Bundle Info for Remote Registration (handy if you have more than one app)
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    
    // Set the defaults to disabled unless we find otherwise...
    NSString *pushBadge ;
    NSString *pushAlert;
    NSString *pushSound ;
    
    NSUInteger rntypes;
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        //returns UIRemoteNotificationType typedef for nsuinteger
        UIUserNotificationSettings * notificationSettings;
        notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        rntypes = [notificationSettings types];
        pushBadge = (rntypes & UIUserNotificationTypeBadge) ? @"enabled" : @"disabled";
        pushAlert = (rntypes & UIUserNotificationTypeAlert) ? @"enabled" : @"disabled";
        pushSound = (rntypes & UIUserNotificationTypeSound) ? @"enabled" : @"disabled";
        
    }
    else
    {
        rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        pushBadge = (rntypes & UIRemoteNotificationTypeBadge) ? @"enabled" : @"disabled";
        pushAlert = (rntypes & UIRemoteNotificationTypeAlert) ? @"enabled" : @"disabled";
        pushSound = (rntypes & UIRemoteNotificationTypeSound) ? @"enabled" : @"disabled";
        
    }
    
    // Get the users Device Model, Display Name, Unique ID, Token & Version Number
    
    UIDevice *dev = [UIDevice currentDevice];
    
    NSString *deviceUuid = [[[[devToken description]
                              stringByReplacingOccurrencesOfString:@"<"withString:@""]
                             stringByReplacingOccurrencesOfString:@">" withString:@""]
                            stringByReplacingOccurrencesOfString: @" " withString: @""];;
    
    NSString *deviceName = dev.name;
    NSString *deviceModel = dev.model;
    NSString *deviceSystemVersion = dev.systemVersion;
    
    // Prepare the Device Token for Registration (remove spaces and < >)
    NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    // Build URL String for Registration
    // !!! CHANGE "www.mywebsite.com" TO YOUR WEBSITE. Leave out the http://
    // !!! SAMPLE: "secure.awesomeapp.com"
    
    NSString *host = @"api.firesonar.com/FireSonar/apiv2/easyapns/";
    
    // !!! CHANGE "/apns.php?" TO THE PATH TO WHERE apns.php IS INSTALLED
    // !!! ( MUST START WITH / AND END WITH ? ).
    // !!! SAMPLE: "/path/to/apns.php?"
    NSString *urlString = [NSString stringWithFormat:@"/apns.php?task=%@&appname=%@&appversion=%@&deviceuid=%@&devicetoken=%@&devicename=%@&devicemodel=%@&deviceversion=%@&pushbadge=%@&pushalert=%@&pushsound=%@", @"register", appName,appVersion, [deviceUuid substringToIndex:38], deviceToken, deviceName, deviceModel, deviceSystemVersion, pushBadge, pushAlert, pushSound];
    
    
    
    
    // Register the Device Data
    // !!! CHANGE "http" TO "https" IF YOU ARE USING HTTPS PROTOCOL
    NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlR, NSData *returnData, NSError *e) {
                               
                               
                               if (e == nil) {
                                   // NSLog(@"Return Data: %@", returnData);
                                   NSDictionary *dict = [[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil] mutableCopy];
                                   NSString *apn_id = [dict valueForKey:@"id"];
                                   [[NSUserDefaults standardUserDefaults] setObject:apn_id forKey:@"apn_id"];
                                   
                              
                                   if([Profile getCurrentProfileUserId]!=nil)
                                   {
                                       NSString *stringApn = [NSString stringWithFormat:@"%@set_apnid.php?user_id=%@&apnid=%@",KbaseUrl,[Profile getCurrentProfileUserId],apn_id];
                                       [iOSRequest getJsonResponse:stringApn success:^(NSDictionary *responseDict) {
                                           
                                       } failure:^(NSString *errorString) {
                                           
                                       }];
                                   }
                                   
                                   
                               }
                           }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register remote notifications");
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushForeground" object:userInfo];
    
}

@end
