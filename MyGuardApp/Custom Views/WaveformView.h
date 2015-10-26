//
//  WaveformView.h
//  MyGuardApp
//
//  Created by vishnu on 17/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveformView : UIView

-(void)updateBuffer:(float *)buffer withBufferSize:(UInt32)bufferSize;


@end
