//
//  SoundSelectViewController.h
//  MyGuardApp
//
//  Created by vishnu on 15/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundSelectCell1.h"
#import "SoundSelectCell2.h"
#import "ApiConstants.h"
#import "SoundRecordViewController.h"
#import "AudioPlayerView.h"
#import <AVFoundation/AVFoundation.h>


@interface SoundSelectViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,AudioPlayerProtocol,AVAudioPlayerDelegate>

@property NSInteger alarmCount;
@property (nonatomic,strong) NSTimer *timerObj;
@property (strong,nonatomic)AVAudioPlayer *audioPlayer;
@property (nonatomic,retain) AudioPlayerView *audioPlayeView;
@property (nonatomic,strong) NSIndexPath *selectedIndex;
@property (nonatomic,strong) NSString *stringType;
@property (nonatomic,strong) NSMutableArray *arraySounds;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSound;

@end
