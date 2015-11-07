//
//  AudioPlayerView.m
//  FireSonar
//
//  Created by CB Labs_1 on 24/02/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import "AudioPlayerView.h"

@implementation AudioPlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AudioPlayerView" owner:self options:nil] lastObject];
        self.btnRecordOrPlay.selected = NO;
        self.viewAudioHolder.layer.borderColor = [[UIColor colorWithWhite:1 alpha:0.2]CGColor];
        self.viewAudioHolder.layer.borderWidth = 1;
        self.viewAudioHolder.clipsToBounds = YES;
        self.viewAudioHolder.layer.cornerRadius = 4.0;
    }
    
    
    return self;
    
}

- (IBAction)actionPlayOrPause:(id)sender {
    [self.delegate delegatePlayOrPaused];
}

- (IBAction)actionDone:(id)sender {
    [self.delegate delegateDone];
}
@end
