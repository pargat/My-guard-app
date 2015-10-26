//
//  ContactsData.h
//  FireSonar
//
//  Created by Gagan on 29/11/14.
//  Copyright (c) 2014 Gagan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ContactsData : NSObject

@property(nonatomic,retain)NSString *contact_fname;
@property(nonatomic,retain)NSString *contact_lname;
@property(nonatomic,retain)NSArray *contact_phoneNos;
@property(nonatomic,retain)UIImage *contact_image ;
@property(nonatomic,retain)NSString *contact_phone_number ;
@end
