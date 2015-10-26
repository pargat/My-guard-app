//
//  CommentModal.h
//  MyGuardApp
//
//  Created by vishnu on 25/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModal : NSObject

@property (nonatomic,strong) NSString * commentContent;
@property (nonatomic,strong) NSString * commentTimePassed;
@property (nonatomic,strong) NSString * commentName;
@property (nonatomic,strong) NSString * commentDp;
@property (nonatomic,strong) NSString * commentID;

+(NSMutableArray *)parseDictToModal : (NSArray *)tempArr;


@end
