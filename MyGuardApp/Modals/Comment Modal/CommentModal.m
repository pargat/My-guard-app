//
//  CommentModal.m
//  MyGuardApp
//
//  Created by vishnu on 25/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "CommentModal.h"

@implementation CommentModal


-(id)initWithAttributes:(NSDictionary *)tempDict
{
    self = [super init];
    if(self!=nil)
    {
        
        self.commentContent = [tempDict valueForKey:@"comment"];
        self.commentDp = [tempDict valueForKey:@"image"];
        self.commentTimePassed = [tempDict valueForKey:@"nice_time"];
        self.commentName = [tempDict valueForKey:@"firstname"];
        self.commentID = [tempDict valueForKey:@"id"];
        
    }
    return self;
}

+(NSMutableArray *)parseDictToModal : (NSArray *)tempArr {
    NSMutableArray *commentArr = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *tempDict in tempArr) {
        
        [commentArr addObject:[[CommentModal alloc]initWithAttributes:tempDict]];
    }
    return commentArr;
}

@end
