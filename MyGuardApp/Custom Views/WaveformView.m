//
//  WaveformView.m
//  MyGuardApp
//
//  Created by vishnu on 17/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

//
//  WaveformView.m
//
//  Created by Edward Majcher on 7/17/14.
//

#import "WaveformView.h"

//Gain applied to incoming samples
static CGFloat kGain = 10.;

//Number of samples displayed
static int kMaxWaveforms = 80.;

@interface WaveformView ()

@property (nonatomic) BOOL addToBuffer;

//Holds kMaxWaveforms number of incoming samples,
//80 is based on half the width of iPhone, adding a 1 pixel line between samples
@property (strong, nonatomic) NSMutableArray* bufferArray;

+ (float)RMS:(float *)buffer length:(int)bufferSize;

@end

@implementation WaveformView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bufferArray = [NSMutableArray array];
}

-(void)updateBuffer:(float *)buffer withBufferSize:(UInt32)bufferSize
{
    if (!self.addToBuffer) {
        self.addToBuffer = YES;
        return;
    } else {
        self.addToBuffer = NO;
    }
    
    float rms = [WaveformView RMS:buffer length:bufferSize];
    
    if ([self.bufferArray count] == kMaxWaveforms) {
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
         [self.bufferArray removeObjectAtIndex:0];
    }
    
    [self.bufferArray addObject:@(rms * kGain)];
    
    [self setNeedsDisplay];
}

+ (float)RMS:(float *)buffer length:(int)bufferSize {
    float sum = 0.0;
    
    for(int i = 0; i < bufferSize; i++) {
        sum += buffer[i] * buffer[i];
    }
    
    return sqrtf( sum / bufferSize );
}


// *****************************************************

- (void)drawRect:(CGRect)rect
{
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat midY = CGRectGetMidY(rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw out center line
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1.);
    
    CGContextMoveToPoint(context, 0., midY);
    CGContextAddLineToPoint(context, maxX, midY);
    
    CGContextStrokePath(context);
    
    CGFloat x = 0.;
    
    for (NSNumber* n in self.bufferArray) {
        CGFloat height = 20 * [n floatValue];
        CGContextMoveToPoint(context, x, midY - height);
        CGContextAddLineToPoint(context, x, midY + height);
        CGContextStrokePath(context);
        
        x += 2;
    }
    
    if ([self.bufferArray count] >= kMaxWaveforms) {
        [self addMarkerInContext:context forX:midX forRect:rect];
    } else {
        [self addMarkerInContext:context forX:x forRect:rect];
    }
}

- (void)addMarkerInContext:(CGContextRef)context forX:(CGFloat)x forRect:(CGRect)rect
{
    CGFloat maxY = CGRectGetMaxY(rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    
    CGContextFillEllipseInRect(context, CGRectMake(x - 1.5, 0, 3, 3));
    
    CGContextMoveToPoint(context, x, 0 + 3);
    CGContextAddLineToPoint(context, x, maxY - 3);
    CGContextStrokePath(context);
    
    CGContextFillEllipseInRect(context, CGRectMake(x - 1.5, maxY - 3, 3, 3));
}

@end
