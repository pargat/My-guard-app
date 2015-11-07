//
//  RecordView.h
//  FireSonar
//
//  Created by CB Labs_1 on 15/03/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordViewProtocol

-(void)delegateRecord;
-(void)delegateRecordPlay;
-(void)delegatePlay1;
-(void)delegateDelete1;


@end

@interface RecordView : UIView
@property (nonatomic,assign) id<RecordViewProtocol> delegate;
@property BOOL isRecording;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UIButton *btnRecordPlay;
@property (weak, nonatomic) IBOutlet UILabel *labelClickToRecord;
@property (weak, nonatomic) IBOutlet UIView *viewRecordHolder;
@property (weak, nonatomic) IBOutlet UIView *viewRecordHolder1;


- (IBAction)actionPlay1:(id)sender;
- (IBAction)actionDelete1:(id)sender;

- (IBAction)actionRecordPlay:(id)sender;
- (IBAction)actionRecord:(id)sender;

@end
