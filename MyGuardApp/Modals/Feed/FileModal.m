//
//  FileModal.m
//  MyGuardApp
//
//  Created by vishnu on 16/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "FileModal.h"

@implementation FileModal


-(id)initWithAttributes:(NSDictionary *)dict
{
    self = [super init];
    if(self!=nil)
    {
        
        self.fileNumberOfComments = [dict valueForKey:@"comment_count"];
        self.fileId = [dict valueForKey:@"id"];
        if([[dict valueForKey:@"thumb"] isEqualToString:@""])
        {
            self.fileType = false;
            self.fileThumbCumImageLink = [dict valueForKey:@"media"];
        }
        else
        {
            self.fileType = true;
            self.fileThumbCumImageLink = [dict valueForKey:@"thumb"];
            self.fileVideoLink = [dict valueForKey:@"media"];
            self.fileDuration =[NSString stringWithFormat:@"%ld",[[dict valueForKey:@"duration"] integerValue]];
        }
        
    }
    return self;
}

+(NSMutableArray *)parseDictToFeed : (NSArray *)arrFeed
{
    NSMutableArray *arrayFeed = [[NSMutableArray alloc] init];
    for (int i =0; i<arrFeed.count; i++) {
        FileModal *modal = [[FileModal alloc] initWithAttributes:[arrFeed objectAtIndex:i]];
        [arrayFeed addObject:modal];
    }
    
    return arrayFeed;
    
}

@end
