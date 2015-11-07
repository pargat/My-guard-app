//
//  RecordView.m
//  FireSonar
//
//  Created by CB Labs_1 on 15/03/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import "RecordView.h"

@implementation RecordView

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"RecordView" owner:self options:nil] lastObject];
        self.viewRecordHolder.layer.cornerRadius = 5;
        self.viewRecordHolder.clipsToBounds = YES;
        [self.viewRecordHolder setHidden:NO];
        [self.viewRecordHolder1 setHidden:YES];
        self.isRecording = false;
        [self.labelClickToRecord setText:NSLocalizedString(@"click_here_to_record", nil)];
    }
    
    
    return self;
    
}

- (IBAction)actionPlay1:(id)sender {
    [self.delegate delegatePlay1];
}

- (IBAction)actionDelete1:(id)sender {
    [self.delegate delegateDelete1];
}


- (IBAction)actionRecordPlay:(id)sender {
    [self.delegate delegateRecordPlay];
}

- (IBAction)actionRecord:(id)sender {
    [self.delegate delegateRecord];
}


@end
