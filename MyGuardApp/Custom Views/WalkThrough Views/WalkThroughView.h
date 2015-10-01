//
//  WalkThroughView.h
//  MyGuardApp
//
//  Created by vishnu on 14/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalkThroughView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageViewWalk;

-(void)setUpWalk:(NSString *)title desc:(NSString *)description imageName:(NSString *)name;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;


@end
