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


//Post
#define KPostAlarmApi @"%@post_fake_alarm.php"

//General Constants
#define KInternetNotAvailable @"Internet is not available"
#define EmergencyDefaultKey @"emergencyContacts"
#define DisplayScale [[UIScreen mainScreen] scale]
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define TIMEOFFSET [[NSTimeZone localTimeZone] secondsFromGMT]

//reporting
#define KReportImageApi @"%@report_image.php?user_id=%@&image_id=%@"


//Image extra apis
#define KRemoveFilesApi @"%@remove_files_v2.php?user_id=%@&alarm_id=%@&image_ids=%@"


#define KGetSafetyMeasure @"%@get_safety_measures.php?user_id=%@&type=%@&page=%d&length=%d"
#define KbaseUrl @"http://api.firesonar.com/FireSonar/apiv2/"
#define KLoginApi @"%@login_new.php?email=%@&password=%@&lat=%f&lng=%f&zone=%ld"
#define KFbRegister @"%@fb_register_new.php?email=%@&lat=%f&lng=%f&zone=%ld"
#define KBaseTimbthumbUrl @"%@&w=%f&h=%f"

//Comment Screen
#define KAddComment @"%@add_image_comment.php?user_id=%@&image_id=%@&alarm_id=%@&comment=%@"
#define KGetCommentApi @"%@get_image_comments.php?user_id=%@&image_id=%@&alarm_id=%@"

//Register screen
#define KIsEmailAvailable @"%@is_email_available.php?email=%@"


//Adding Safety Measure
#define KAddSafetyMeasureApi @"%@post_safety_measure_v2.php?user_id=%@&type=%@&description=%@"


//feeds
#define KGetVideos @"%@get_informational_videos.php?user_id=%@&type=%@&page=%d&length=10"
#define KGetAlarms @"%@get_alarms.php?user_id=%@&type=%d&page=%d&length=10&zone=%ld"

//Community
#define KSearchUsers @"%@list_search_users.php?user_id=%@&key=%@"
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

//Edit Profile
#define KEditProfile @"%@edit_profile.php"

//Profile fetching
#define KGetProfile @"%@get_other_profile.php?uid=%@&mid=%@"

//Notification apis
#define KClearAllNotifs @"%@clear_all_notifications.php?user_id=%@"
#define KGetNotificationApi @"%@get_notifications_v2.php?user_id=%@&page=%d"
#define KMarkNotificationApi @"%@mark_notification_read.php?user_id=%@&notification_id=%@"

//Safety measure
#define KViewSafetyMeasure @"%@view_safety_measure.php?id=%@"

//Settings
#define KLogoutApi  @"%@logout.php?user_id=%@"

//Search api
#define KSearchNewApi @"%@new_search.php?user_id=%@&keyword=%@&flag=%@"

// Sign Up Screen
#define KSignUpScreen @"%@signup_new.php"

#define KScreenFeed @"%@get_alarms.php?user_id=%@&type=%@&page=%d&length=10&zone=%ld&key=%@"
#define KScreenSafetyMeasures @"%@get_safety_measures.php?user_id=%@&type=%@&page=%d&length=10"
#define KScreenInfoVideos @"%@get_informational_videos.php?user_id=%@&type=%@&page=%d&length=10"

#define kListAllUsers @"%@list_all_users.php?user_id=%@"
#define KUpdateAlarm @"%@update_alarm_v2.php"

//Friend and  family api
#define KAcceptRequest @"%@accept_request.php?user_id=%@&other_id=%@&type=%@"
#define KCancelRequest @"%@remove_link.php?user_id=%@&other_id=%@"
#define KAddFriendApi @"%@add_as_friend_v2.php?user_id=%@&friend_id=%@"
#define KAddFamilyApi @"%@add_as_family_v2.php?user_id=%@&family_id=%@"

//Map marker icon
#define KFireIcon @"http://api.firesonar.com/FireSonar/uploads/pin_fire.png"
#define KCOIcon @"http://api.firesonar.com/FireSonar/uploads/pin_co.png"
#define KGunIcon @"http://api.firesonar.com/FireSonar/uploads/pin_gunshot.png"
