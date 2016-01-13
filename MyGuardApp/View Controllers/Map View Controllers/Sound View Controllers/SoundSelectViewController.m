//
//  SoundSelectViewController.m
//  MyGuardApp
//
//  Created by vishnu on 15/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "SoundSelectViewController.h"

@interface SoundSelectViewController ()

@end

@implementation SoundSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self viewHelper];

}

#pragma mark -
#pragma mark - View helpers
-(void)setUpNavBar
{
    NSString *type;
    if([self.stringType isEqualToString:@"Fire"])
    {
        type = @"fire_walk_t";
    }
    else if ([self.stringType isEqualToString:@"Gun"])
    {
        type = @"gun_walk_t";
    }
    else
    {
        type = @"co_walk_t";
    }
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"alert_sound_for", nil),NSLocalizedString(type, nil)]];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
    [btnBack setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = btnBack;
    
}

-(void)deleteFile:(NSString *)filePath
{
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:filePath]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
    }
    
}

-(void)handleTimer
{
    self.alarmCount ++;
    float duration = self.audioPlayer.duration;
    float valueChange = self.alarmCount*0.2/duration;
    [self.audioPlayeView.sliderViewTime setValue:valueChange animated:YES];
    
}
-(void)viewHelper
{
    self.arraySounds = [[self listFileAtPath:self.stringType] mutableCopy];
    [self.tableViewSound setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableViewSound setDelegate:self];
    [self.tableViewSound setDataSource:self];
    [self.tableViewSound reloadData];
    [self setUpNavBar];
}
-(NSArray *)listFileAtPath:(NSString *)type
{
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER,type] error:NULL];
    return directoryContent;
}


#pragma mark -
#pragma mark - Table View Delegate and datasource functions
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2+self.arraySounds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        SoundSelectCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"SoundSelectCell1"];
        [self configureCellMain:cell atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        SoundSelectCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"SoundSelectCell2"];
        [self configureCell:cell atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        static SoundSelectCell1 *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"SoundSelectCell1"];
        });
        
        [self configureCellMain:sizingCell atIndexPath:indexPath];
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
        
    }
    else
    {
        static SoundSelectCell2 *sizingCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizingCell = [tableView dequeueReusableCellWithIdentifier:@"SoundSelectCell2"];
        });
        
        [self configureCell:sizingCell atIndexPath:indexPath];
        CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
        
    }
}
-(void)configureCellMain:(SoundSelectCell1 *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell.labelRecord setText:NSLocalizedString(@"tap_to_change", nil)];
    
}
-(void)configureCell:(SoundSelectCell2 *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *stringSelected = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@Sound",self.stringType]];
   
    if(indexPath.row==1)
    {
        [cell.labelName setText:[NSString stringWithFormat:@"MyGuard %@",self.stringType]];
        if([stringSelected isEqualToString:[NSString stringWithFormat:@"%@Default.mp3",self.stringType]])
        {
            [cell.labelName setTextColor:KPurpleColor];
            [cell.labelName setFont:[UIFont boldSystemFontOfSize:16.0]];
            [cell.labelName setText:[NSString stringWithFormat:@"MyGuard %@ (current)",self.stringType]];
            cell.isSelected = YES;
        }
        else
        {
            [cell.labelName setTextColor:[UIColor blackColor]];
            [cell.labelName setFont:[UIFont systemFontOfSize:16.0]];
            cell.isSelected = NO;
        }

    }
    else
    {
        [cell.labelName setText:[[self.arraySounds objectAtIndex:indexPath.row-2]stringByDeletingPathExtension] ];
        if([stringSelected isEqualToString:[self.arraySounds objectAtIndex:indexPath.row-2]])
        {
            [cell.labelName setTextColor:KPurpleColor];
            [cell.labelName setText:[[[self.arraySounds objectAtIndex:indexPath.row-2]stringByDeletingPathExtension] stringByAppendingString:@" (current)"] ];
             [cell.labelName setFont:[UIFont boldSystemFontOfSize:16.0]];
            cell.isSelected = YES;

        }
        else
        {
            [cell.labelName setTextColor:[UIColor blackColor]];
             [cell.labelName setFont:[UIFont systemFontOfSize:16.0]];
            cell.isSelected = NO;

        }

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        [self performSegueWithIdentifier:KSoundRecordSegue sender:nil];
    }
    else
    {
        self.selectedIndex = indexPath;
        [CommonFunctions videoPlay];
        UIActionSheet *actionSheet;
        SoundSelectCell2 *cell = (SoundSelectCell2 *)[tableView cellForRowAtIndexPath:indexPath];
        if(cell.isSelected)
        {
            actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Play",nil ];
        }
        else if(indexPath.row==1)
        {
            actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Play",@"Set it as alarm",nil ];
        }
        else
        {
            
            actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Play",@"Set it as alarm",@"Delete",nil ];
            
        }
        
        [actionSheet showInView:self.view];
    }
}

#pragma mark -
#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"])
    {
        if(buttonIndex==0)
        {
            NSURL *sound_file;
            if(self.selectedIndex.row ==1)
            {
                sound_file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@Default",self.stringType] ofType:@"mp3"]];
            }
            else
            {
                
                sound_file = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",DOCUMENTS_FOLDER,self.stringType,[self.arraySounds objectAtIndex:self.selectedIndex.row-2]]];
            }
            
            
            self.audioPlayeView = [[AudioPlayerView alloc] init];
            
            [self.audioPlayeView setFrame: CGRectMake(0, 0, [[UIApplication sharedApplication] keyWindow].frame.size.width, [[UIApplication sharedApplication] keyWindow].frame.size.height )];
            
            
            self.audioPlayeView.delegate = self;
            self.alarmCount = 0;
            self.timerObj = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
            
            NSError *error = nil;
            // Play it
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:sound_file error:&error];
            self.audioPlayer.delegate = self;
            [self.audioPlayer prepareToPlay];
            
            [self.audioPlayer play];
            [[[UIApplication sharedApplication] keyWindow]addSubview:self.audioPlayeView];
            
            
            
        }
        else if (buttonIndex==1)
        {
            if(self.selectedIndex.row==1)
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"FireDefault.mp3" forKey:[NSString stringWithFormat:@"%@Sound",self.stringType]];
                
            }
            else
            {
                NSString *fileName = [self.arraySounds objectAtIndex:self.selectedIndex.row-2];
                [[NSUserDefaults standardUserDefaults] setObject:fileName forKey:[NSString stringWithFormat:@"%@Sound",self.stringType]];
            }
            
        }
        else if(buttonIndex==2)
        {
            NSString *fileName = [self.arraySounds objectAtIndex:self.selectedIndex.row-2];
            
            [self.arraySounds removeObjectAtIndex:self.selectedIndex.row-2];
            BOOL allFileDeleted = false;
            if([self.arraySounds count]==0)
            {
                allFileDeleted = true;
            }
            
            [self deleteFile:[NSString stringWithFormat:@"%@/%@/%@",DOCUMENTS_FOLDER,self.stringType,fileName]];
        }
    }
    
    [self.tableViewSound reloadData];
    
    
}

#pragma mark - delegate audio player
-(void)delegateDone
{
    [self.audioPlayeView removeFromSuperview];
    self.audioPlayer = nil;
    [self.timerObj invalidate];
    [CommonFunctions recordAudio];
}
-(void)delegatePlayOrPaused
{
    if(self.audioPlayeView.btnRecordOrPlay.isSelected)
    {
        self.audioPlayeView.btnRecordOrPlay.selected = NO;
    }
    else
    {
        self.audioPlayeView.btnRecordOrPlay.selected = YES;
    }
    // self.audioPlayeView.btnRecordOrPlay.selected = !self.audioPlayeView.btnRecordOrPlay.isSelected;
    if(self.audioPlayeView.btnRecordOrPlay.isSelected)
    {
        [self.audioPlayer pause];
        [self.timerObj invalidate];
    }
    else
    {
        if(self.audioPlayeView.sliderViewTime.value==1.0)
        {
            [self.audioPlayeView.sliderViewTime setValue:0];
            self.alarmCount=0;
        }
        [self.audioPlayer play];
        self.timerObj = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    }
}
-(void)PlayorPause
{
}
-(void)DoneAction
{
    
}


#pragma mark - 
#pragma mark - Button Actions
-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:KSoundRecordSegue])
    {
        SoundRecordViewController *soundVC = (SoundRecordViewController *)segue.destinationViewController;
        soundVC.stringType = self.stringType;
    }
}


@end
