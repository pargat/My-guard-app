//
//  ApiConstants.h
//  MyGuardApp
//
//  Created by vishnu on 14/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "Colors.h"
#import "SegueNames.h"
#import "iOSRequest.h"
#import "Profile.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

typedef enum : NSUInteger {
    NEIGHBOUR,
    FAMILY,
    FRIENDS,
    SEARCH
} COMMUNITYTAB;

typedef enum : NSUInteger {
    FIRE,
    GUN,
    CO
} MAINTAB;


//General Constants
#define DisplayScale [[UIScreen mainScreen] scale]
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define TIMEOFFSET [[NSTimeZone localTimeZone] secondsFromGMT]

#define KBaseTimbthumbUrl @"http://api.firesonar.com/FireSonar/timthumb.php?src=uploads/%@&w=%f&h=%f"
#define KGetSafetyMeasure @"%@get_safety_measures.php?user_id=%@&type=%@&page=%d&length=%d"
#define KbaseUrl @"http://api.firesonar.com/FireSonar/api/"
#define KLoginApi @"%@login_new.php?email=%@&password=%@&lat=%f&lng=%f&zone=%ld"
#define KFbRegister @"%@fb_register_new.php?email=%@&lat=%f&lng=%f&zone=%ld"
#define KBaseTimbthumbUrl @"http://api.firesonar.com/FireSonar/timthumb.php?src=uploads/%@&w=%f&h=%f"

//feeds
#define KGetVideos @"%@get_informational_videos.php?user_id=%@&type=%@&page=%d&length=10"
#define KGetAlarms @"%@get_alarms.php?user_id=%@&type=%d&page=%d&length=10&zone=%ld"

//Community
#define KListFamily @"%@list_all_family.php?user_id=%@"
#define KListFriends @"%@list_all_friends.php?user_id=%@"
#define KListNeighbours @"%@list_all_neighbours.php?user_id=%@&latitude=%f&longitude=%f"
#define KListAllCommunity @"%@list_all_community.php?user_id=%@&latitude=%f&longitude=%f"

//open tok alarm
#define KOpenTok @"%@post_alarm_tok.php"

// General User Profile
#define KGetMyDetails @"%@get_my_profile.php?uid=%@"
#define KGetOtherDetails @"%@get_other_profile.php?user_id=%@"

//push admin message
#define KGetMessage @"%@view_broadcast.php?user_id=%@&id=%@"

//Profile fetching
#define KGetProfile @"%@get_other_profile.php?uid=%@&mid=%@"

// Sign Up Screen
#define KSignUpScreen @"%@signup_new.php"

#define KScreenFeed @"%@get_alarms.php?user_id=%@&type=%@&page=%d&length=10&zone=%ld&key=%@"
#define KScreenSafetyMeasures @"%@get_safety_measures.php?user_id=%@&type=%@&page=%d&length=10"
#define KScreenInfoVideos @"%@get_informational_videos.php?user_id=%@&type=%@&page=%d&length=10"

#define kListAllUsers @"%@list_all_users.php?user_id=%@"
#define KUpdateAlarm @"%@update_alarm.php"


//Map marker icon
#define KFireIcon @"http://api.firesonar.com/FireSonar/uploads/pin_fire.png"
#define KCOIcon @"http://api.firesonar.com/FireSonar/uploads/pin_co.png"
#define KGunIcon @"http://api.firesonar.com/FireSonar/uploads/pin_gunshot.png"
