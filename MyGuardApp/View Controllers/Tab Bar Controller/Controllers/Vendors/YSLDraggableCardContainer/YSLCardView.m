//
//  YSLCardView.m
//  Crew-iOS
//
//  Created by yamaguchi on 2015/10/23.
//  Copyright © 2015年 h.yamaguchi. All rights reserved.
//

#import "YSLCardView.h"

@implementation YSLCardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupCardView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCardView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupCardView];
    }
    return self;
}

- (void)setupCardView {
    
//    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    self.layer.borderWidth = 0.4f;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.cornerRadius = 7.0;
    
}

@end
