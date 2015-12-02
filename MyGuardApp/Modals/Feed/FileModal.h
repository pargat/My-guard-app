//
//  FileModal.h
//  MyGuardApp
//
//  Created by vishnu on 16/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileModal : NSObject

//0 for image 1 for video
@property BOOL fileType;
@property (nonatomic,strong) NSString *fileImageName;
@property (nonatomic,strong) NSString *fileDescription;
@property (nonatomic,strong) NSString *fileThumbCumImageLink;
@property (nonatomic,strong) NSString *fileVideoLink;
@property (nonatomic,strong) NSString *fileNumberOfComments;
@property (nonatomic,strong) NSString *fileDuration;
@property (nonatomic,strong) NSString *fileId;

-(id)initWithAttributes:(NSDictionary *)dict;
+(NSMutableArray *)parseDictToFeed : (NSArray *)arrFeed;

@end
