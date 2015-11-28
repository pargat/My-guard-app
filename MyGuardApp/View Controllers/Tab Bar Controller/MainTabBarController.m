//
//  MainTabBarController.m
//  MyGuardApp
//
//  Created by vishnu on 15/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "MainTabBarController.h"


const UInt32 FFTLEN = 2048;
int _fftBufIndex = 0;
float * _fftBuf;
int samplesRemaining=FFTLEN;
int previousFreq=0;
@interface MainTabBarController ()

{
    
    
    COMPLEX_SPLIT _A;
    FFTSetup      _FFTSetup;
    BOOL          _isFFTSetup;
    vDSP_Length   _log2n;
    
    BOOL timerFlag ;
    
    int _samplesRemaining;
    NSMutableArray *getsFireArray ;
    NSMutableArray *mainFireMeanArray ;
    
    NSMutableArray *alanaFireArray;
    NSMutableArray *alanaFireMeanArray;
    
    NSMutableArray *CherrieFireArray;
    NSMutableArray *CherrieFireMeanArray;
    
    NSMutableArray *homieAndPhotoFireArray;
    NSMutableArray *homieAndPhotoFireMeanArray;
    
    NSMutableArray *oneCodeSmokeFireArray;
    NSMutableArray *oneCodeSmokeFireMeanArray;
    
    NSMutableArray *ambiguousArray;
    NSMutableArray *ambiguousMeanArray;
    
    NSMutableArray *getsCOArray ;
    NSMutableArray *mainCOMeanArray ;
    NSMutableArray *mainCOMeanDiffArray ;
    
    NSMutableArray *FreqIndexArray ;
    
    BOOL ISOVERLAYSHOWING ;
    BOOL ISWAVEOVERLAYSHOWING ;
    
    NSTimer *alarmTimer ;
    
    
    AVAudioPlayer *audioPlayer;
    
    int alarmCount ;
}

@property AlarmOverLayView *AlarmObj ;
@property WaveAnimationView *waveObj ;
@property NSTimer *twoHunMSTimer;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LOcationUpdater sharedManager];
    // Do any additional setup after loading the view.
    
    [self setDefaultSounds];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
    
    
    getsFireArray = [[NSMutableArray alloc] init];
    
    mainFireMeanArray = [[NSMutableArray alloc] init];
    FreqIndexArray = [[NSMutableArray alloc] init];
    
    alanaFireArray = [[NSMutableArray alloc] init];
    CherrieFireArray= [[NSMutableArray alloc] init];
    homieAndPhotoFireArray=[[NSMutableArray alloc] init];
    oneCodeSmokeFireArray=[[NSMutableArray alloc] init];
    ambiguousArray=[[NSMutableArray alloc] init];
    
    alanaFireMeanArray = [[NSMutableArray alloc] init];
    CherrieFireMeanArray= [[NSMutableArray alloc] init];
    homieAndPhotoFireMeanArray=[[NSMutableArray alloc] init];
    oneCodeSmokeFireMeanArray=[[NSMutableArray alloc] init];
    ambiguousMeanArray=[[NSMutableArray alloc] init];
    getsCOArray = [[NSMutableArray alloc] init];
    mainCOMeanArray = [[NSMutableArray alloc] init];
    mainCOMeanDiffArray = [[NSMutableArray alloc] init];
    self.microphone = [EZMicrophone microphoneWithDelegate:self startsImmediately:YES];
    ISOVERLAYSHOWING = NO;
    ISWAVEOVERLAYSHOWING = NO ;
    
    self.twoHunMSTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(TwoHundredMSSampling) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(setOffAlarmViaNotification:) name:@"alarmOff" object:nil];
    
    
    
    //push notification
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        
    }
    
    [self locationInitialiser];
    _fftBuf = (float *)malloc(sizeof(float)*FFTLEN);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performPushForeground:) name:@"pushForeground" object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self setTitleAndImages];
    [self.navigationController.navigationBar setHidden:YES];
    [self showVideoPermission];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



#pragma mark -
#pragma mark - View Helpers and observers
-(void)setDefaultSounds
{
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"FireSound"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"FireDefault.mp3" forKey:@"FireSound"];
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"GunSound"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"GunDefault.mp3" forKey:@"GunSound"];

    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"COSound"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"CODefault.mp3" forKey:@"COSound"];

    }

    
}
-(void)performPushForeground:(NSNotification *)n
{
    NSDictionary *dict = [n.object valueForKey:@"C"];
    NSString *str = [dict valueForKey:@"type"];
    
    if([str isEqualToString:@"1"])
    {
        [self performSegueWithIdentifier:KMapFeedSegue sender:dict];
    }
    else if([str isEqualToString:@"2"])
    {
        [self performSegueWithIdentifier:KFalseAlarmSegue sender:dict];
    }
    else if ([str isEqualToString:@"5"])
    {
        [self performSegueWithIdentifier:KAdminSegue sender:dict];
    }

}

-(void)showVideoPermission
{
    if(self.isFirstTime)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"video_permission", nil) delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alertView.tag = 1;
        [alertView show];
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"sex_permission", nil) delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alertView.tag = 2;
            [alertView show];

        }
        self.isFirstTime = NO;
    }
    
}
-(void)setTitleAndImages
{
    [(UITabBarItem*)[[[self tabBar] items] objectAtIndex:0] setImage:[UIImage imageNamed:@"tb_fire_normal"]];
    [(UITabBarItem*)[[[self tabBar] items] objectAtIndex:1] setImage:[UIImage imageNamed:@"tb_gun_normal"]];
    [(UITabBarItem*)[[[self tabBar] items] objectAtIndex:2] setImage:[UIImage imageNamed:@"tb_co_normal"]];
    [(UITabBarItem*)[[[self tabBar] items] objectAtIndex:4] setImage:[UIImage imageNamed:@"tb_sex_offenders_normal"]];
    [(UITabBarItem*)[[[self tabBar] items] objectAtIndex:3] setImage:[UIImage imageNamed:@"tb_community_normal"]];
    
    [(UITabBarItem*)[[[self tabBar] items] objectAtIndex:0] setSelectedImage:[UIImage imageNamed:@"tb_fire_pressed"]];
    [(UITabBarItem*)[[[self tabBar] items] objectAtIndex:1] setSelectedImage:[UIImage imageNamed:@"tb_gun_pressed"]];
    [(UITabBarItem*)[[[self tabBar] items] objectAtIndex:2] setSelectedImage:[UIImage imageNamed:@"tb_co_pressed"]];
    [(UITabBarItem*)[[[self tabBar] items] objectAtIndex:4] setSelectedImage:[UIImage imageNamed:@"tb_sex_offenders_pressed"]];
    [(UITabBarItem*)[[[self tabBar] items] objectAtIndex:3] setSelectedImage:[UIImage imageNamed:@"tb_community_pressed"]];
    
    
    
    [(UITabBarItem*)[[[self tabBar] items] objectAtIndex:0] setTitle:NSLocalizedString(@"fire", nil)];
    [(UITabBarItem*)[[[self tabBar] items] objectAtIndex:2] setTitle:NSLocalizedString(@"co", nil)];
    [(UITabBarItem*)[[[self tabBar] items] objectAtIndex:1] setTitle:NSLocalizedString(@"gunshot", nil)];
    [(UITabBarItem*)[[[self tabBar] items] objectAtIndex:3] setTitle:NSLocalizedString(@"community", nil)];
    [(UITabBarItem*)[[[self tabBar] items] objectAtIndex:4] setTitle:NSLocalizedString(@"tb_sex_offenders", nil)];
    
    
}

#pragma mark -
#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        if(alertView.tag==1)
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"video_permission"];
        else
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sex_permission"];
    }
    else
    {
        if(alertView.tag==1)
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"video_permission"];
        else
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sex_permission"];
    }
}

#pragma mark - Two Hundred's Milliseconds / Three Seconds Sampling
-(void)TwoHundredMSSampling
{
    
    [self sampleFire];
    
    getsFireArray = [[NSMutableArray alloc] init];
    alanaFireArray = [[NSMutableArray alloc] init];
    CherrieFireArray= [[NSMutableArray alloc] init];
    homieAndPhotoFireArray=[[NSMutableArray alloc] init];
    oneCodeSmokeFireArray=[[NSMutableArray alloc] init];
    ambiguousArray=[[NSMutableArray alloc] init];
    
    
    getsCOArray = [[NSMutableArray alloc] init];
    
}

-(void)sampleFire
{
    
    if (mainFireMeanArray.count < 15)
    {
        [mainFireMeanArray addObject:[self meanOf:getsFireArray]];
    }
    
    else
    {
        // shift
        
        [mainFireMeanArray removeObjectAtIndex:0];
        [mainFireMeanArray addObject:[self meanOf:getsFireArray]];
        
        
        NSMutableArray *mainFireMeanDiffArray = [[self meanDeviationOf:mainFireMeanArray : 0.8] mutableCopy] ;
        
        
        NSString *original =  [mainFireMeanDiffArray componentsJoinedByString:@""];
        NSString *replaceOnesWithX = [original stringByReplacingOccurrencesOfString:@"[1]+"
                                                                         withString:@"x"
                                                                            options:NSRegularExpressionSearch
                                                                              range:NSMakeRange(0, original.length)];
        
        NSString *replaceOnesWithY = [replaceOnesWithX stringByReplacingOccurrencesOfString:@"[0]+"
                                                                                 withString:@"y"
                                                                                    options:NSRegularExpressionSearch
                                      
                                                                                      range:NSMakeRange(0, replaceOnesWithX.length)];
        
        
        if ( [replaceOnesWithY hasPrefix:@"xyxyxy"] && !ISOVERLAYSHOWING && !ISWAVEOVERLAYSHOWING && [[NSUserDefaults standardUserDefaults] valueForKey:@"profile"] != nil)
        {
            
            int times = (int)[[original componentsSeparatedByString:@"1"] count]-1;
            if(times>=5)
            {
                NSDictionary *temp = @{@"type":@"1"};
                [self setOffAlarmViaNotification1:temp];
                return;
            }
        }
        
    }
    
    
    if (ambiguousMeanArray.count < 15)
    {
        [ambiguousMeanArray addObject:[self meanOf:ambiguousArray]];
    }
    
    else
    {
        // shift
        
        [ambiguousMeanArray removeObjectAtIndex:0];
        [ambiguousMeanArray addObject:[self meanOf:ambiguousArray]];
        
        //      NSLog(@"%@", [mainFireMeanArray componentsJoinedByString:@""]);
        
        
        NSMutableArray *mainFireMeanDiffArray = [[self meanDeviationOf:ambiguousMeanArray : 0.8] mutableCopy] ;
        // NSLog(@"%@", [mainFireMeanDiffArray componentsJoinedByString:@""]);
        
        
        
        NSString *original =  [mainFireMeanDiffArray componentsJoinedByString:@""];
        
        
        if([original respondsToSelector:@selector(containsString:)])
        {
            if ([[original substringToIndex:4] containsString:@"1111"]&& !ISOVERLAYSHOWING && !ISWAVEOVERLAYSHOWING&[[original substringToIndex:1] isEqualToString:@"1"]&&![[original substringFromIndex:5] containsString:@"1"])
            {
                
                NSDictionary *temp = @{@"type":@"3"};
                [self setOffAlarmViaNotification1:temp];
                return;
            }
        }
        else
        {
            
            if ([[original substringToIndex:4] rangeOfString:@"1111"].length != 0&& !ISOVERLAYSHOWING && !ISWAVEOVERLAYSHOWING&&[[original substringFromIndex:5] rangeOfString:@"1"].length == 0) {
                NSDictionary *temp = @{@"type":@"3"};
                [self setOffAlarmViaNotification1:temp];
                return;
                
            }
            
        }
        
        
        NSString *replaceOnesWithX = [original stringByReplacingOccurrencesOfString:@"[1]+"
                                                                         withString:@"x"
                                                                            options:NSRegularExpressionSearch
                                                                              range:NSMakeRange(0, original.length)];
        
        NSString *replaceOnesWithY = [replaceOnesWithX stringByReplacingOccurrencesOfString:@"[0]+"
                                                                                 withString:@"y"
                                                                                    options:NSRegularExpressionSearch
                                      
                                                                                      range:NSMakeRange(0, replaceOnesWithX.length)];
        
        
        if ( [replaceOnesWithY hasPrefix:@"xyxyxy"] && !ISOVERLAYSHOWING && !ISWAVEOVERLAYSHOWING && [[NSUserDefaults standardUserDefaults] valueForKey:@"profile"] != nil)
        {
            int times =(int) [[original componentsSeparatedByString:@"1"] count]-1;
            if(times>=6)
            {
                NSDictionary *temp = @{@"type":@"1"};
                [self setOffAlarmViaNotification1:temp];
                return;
            }
        }
        
        
        
        
        
    }
    if (alanaFireMeanArray.count < 15)
    {
        [alanaFireMeanArray addObject:[self meanOf:alanaFireArray]];
    }
    
    else
    {
        // shift
        
        [alanaFireMeanArray removeObjectAtIndex:0];
        [alanaFireMeanArray addObject:[self meanOf:alanaFireArray]];
        
        
        NSMutableArray *mainFireMeanDiffArray = [[self meanDeviationOf:alanaFireMeanArray : 0.8] mutableCopy] ;
        
        
        NSString *original =  [mainFireMeanDiffArray componentsJoinedByString:@""];
        NSString *replaceOnesWithX = [original stringByReplacingOccurrencesOfString:@"[1]+"
                                                                         withString:@"x"
                                                                            options:NSRegularExpressionSearch
                                                                              range:NSMakeRange(0, original.length)];
        
        NSString *replaceOnesWithY = [replaceOnesWithX stringByReplacingOccurrencesOfString:@"[0]+"
                                                                                 withString:@"y"
                                                                                    options:NSRegularExpressionSearch
                                      
                                                                                      range:NSMakeRange(0, replaceOnesWithX.length)];
        
        
        if ( [replaceOnesWithY hasPrefix:@"xyxyxy"] && !ISOVERLAYSHOWING && !ISWAVEOVERLAYSHOWING && [[NSUserDefaults standardUserDefaults] valueForKey:@"profile"] != nil)
        {
            int times =(int) [[original componentsSeparatedByString:@"1"] count]-1;
            if(times>=6)
            {
                NSDictionary *temp = @{@"type":@"1"};
                [self setOffAlarmViaNotification1:temp];
                return;
            }
        }
        
    }
    
    
    if (CherrieFireMeanArray.count < 15)
    {
        [CherrieFireMeanArray addObject:[self meanOf:CherrieFireArray]];
    }
    
    else
    {
        // shift
        
        [CherrieFireMeanArray removeObjectAtIndex:0];
        [CherrieFireMeanArray addObject:[self meanOf:CherrieFireArray]];
        
        
        NSMutableArray *mainFireMeanDiffArray = [[self meanDeviationOf:CherrieFireMeanArray : 0.8] mutableCopy] ;
        
        
        NSString *original =  [mainFireMeanDiffArray componentsJoinedByString:@""];
        NSString *replaceOnesWithX = [original stringByReplacingOccurrencesOfString:@"[1]+"
                                                                         withString:@"x"
                                                                            options:NSRegularExpressionSearch
                                                                              range:NSMakeRange(0, original.length)];
        
        NSString *replaceOnesWithY = [replaceOnesWithX stringByReplacingOccurrencesOfString:@"[0]+"
                                                                                 withString:@"y"
                                                                                    options:NSRegularExpressionSearch
                                      
                                                                                      range:NSMakeRange(0, replaceOnesWithX.length)];
        
        
        if ( [replaceOnesWithY hasPrefix:@"xyxyxy"] && !ISOVERLAYSHOWING && !ISWAVEOVERLAYSHOWING && [[NSUserDefaults standardUserDefaults] valueForKey:@"profile"] != nil)
        {
            
            int times = (int)[[original componentsSeparatedByString:@"1"] count]-1;
            if(times>=6)
            {
                
                NSDictionary *temp = @{@"type":@"1"};
                [self setOffAlarmViaNotification1:temp];
                return;
            }
            
        }
        
    }
    
    if (homieAndPhotoFireMeanArray.count < 15)
    {
        [homieAndPhotoFireMeanArray addObject:[self meanOf:homieAndPhotoFireArray]];
    }
    
    else
    {
        // shift
        
        [homieAndPhotoFireMeanArray removeObjectAtIndex:0];
        [homieAndPhotoFireMeanArray addObject:[self meanOf:homieAndPhotoFireArray]];
        
        
        NSMutableArray *mainFireMeanDiffArray = [[self meanDeviationOf:homieAndPhotoFireMeanArray : 0.8] mutableCopy] ;
        
        
        NSString *original =  [mainFireMeanDiffArray componentsJoinedByString:@""];
        NSString *replaceOnesWithX = [original stringByReplacingOccurrencesOfString:@"[1]+"
                                                                         withString:@"x"
                                                                            options:NSRegularExpressionSearch
                                                                              range:NSMakeRange(0, original.length)];
        
        NSString *replaceOnesWithY = [replaceOnesWithX stringByReplacingOccurrencesOfString:@"[0]+"
                                                                                 withString:@"y"
                                                                                    options:NSRegularExpressionSearch
                                      
                                                                                      range:NSMakeRange(0, replaceOnesWithX.length)];
        
        
        if ( [replaceOnesWithY hasPrefix:@"xyxyxy"] && !ISOVERLAYSHOWING && !ISWAVEOVERLAYSHOWING && [[NSUserDefaults standardUserDefaults] valueForKey:@"profile"] != nil)
        {
            int times = (int)[[original componentsSeparatedByString:@"1"] count]-1;
            if(times>=6)
            {
                
                
                NSDictionary *temp = @{@"type":@"1"};
                [self setOffAlarmViaNotification1:temp];
                return;
            }
            
        }
        
    }
    
    if (oneCodeSmokeFireMeanArray.count < 15)
    {
        [oneCodeSmokeFireMeanArray addObject:[self meanOf:oneCodeSmokeFireArray]];
    }
    
    else
    {
        // shift
        
        [oneCodeSmokeFireMeanArray removeObjectAtIndex:0];
        [oneCodeSmokeFireMeanArray addObject:[self meanOf:oneCodeSmokeFireArray]];
        
        
        NSMutableArray *mainFireMeanDiffArray = [[self meanDeviationOf:oneCodeSmokeFireMeanArray : 0.8] mutableCopy] ;
        
        
        NSString *original =  [mainFireMeanDiffArray componentsJoinedByString:@""];
        NSString *replaceOnesWithX = [original stringByReplacingOccurrencesOfString:@"[1]+"
                                                                         withString:@"x"
                                                                            options:NSRegularExpressionSearch
                                                                              range:NSMakeRange(0, original.length)];
        
        NSString *replaceOnesWithY = [replaceOnesWithX stringByReplacingOccurrencesOfString:@"[0]+"
                                                                                 withString:@"y"
                                                                                    options:NSRegularExpressionSearch
                                      
                                                                                      range:NSMakeRange(0, replaceOnesWithX.length)];
        
        
        if ( [replaceOnesWithY hasPrefix:@"xyxyxy"] && !ISOVERLAYSHOWING && !ISWAVEOVERLAYSHOWING && [[NSUserDefaults standardUserDefaults] valueForKey:@"profile"] != nil)
        {
            int times = (int)[[original componentsSeparatedByString:@"1"] count]-1;
            if(times>=6)
            {
                
                NSDictionary *temp = @{@"type":@"1"};
                [self setOffAlarmViaNotification1:temp];
                return;
            }
            
            
        }
        
    }
    
    
}
#pragma mark -
#pragma mark - Micophone open and closing
-(void)stopMicrophone
{
    
    [self.microphone stopFetchingAudio];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
    
}
-(void)startMicrophone
{
    [self.microphone startFetchingAudio];
}


#pragma mark - Mean and Mean Deviation

- (NSNumber *)meanOf:(NSArray *)array
{
    double runningTotal = 0.0;
    
    for(NSNumber *number in array)
    {
        runningTotal += [number doubleValue];
    }
    
    return [NSNumber numberWithDouble:(runningTotal / [array count])];
}


- (NSArray *)meanDeviationOf:(NSArray *)array :(float)thresholdValue
{
    float mean = [[self meanOf:array] floatValue];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSNumber *number in array)
    {
        float diff = [number floatValue] - mean ;
        if (diff > thresholdValue&&[number floatValue]>0) {
            [tempArray addObject:[NSNumber numberWithFloat:1]];
        }
        else
            [tempArray addObject:[NSNumber numberWithFloat:0]];
    }
    
    return tempArray;
}



#pragma mark - FFT
/**
 Adapted from http://batmobile.blogs.ilrt.org/fourier-transforms-on-an-iphone/
 */
-(void)createFFTWithBufferSize:(float)bufferSize withAudioData:(float*)data {
    
    // Setup the length
    _log2n = log2f(bufferSize);
    
    // Calculate the weights array. This is a one-off operation.
    _FFTSetup = vDSP_create_fftsetup(_log2n, FFT_RADIX2);
    
    // For an FFT, numSamples must be a power of 2, i.e. is always even
    int nOver2 = bufferSize/2;
    
    // Populate *window with the values for a hamming window function
    float *window = (float *)malloc(sizeof(float)*bufferSize);
    vDSP_hamm_window(window, bufferSize, 0);
    // Window the samples
    vDSP_vmul(data, 1, window, 1, data, 1, bufferSize);
    free(window);
    
    // Define complex buffer
    _A.realp = (float *) malloc(nOver2*sizeof(float));
    _A.imagp = (float *) malloc(nOver2*sizeof(float));
}
-(void)updateFFTWithBufferSize:(float)bufferSize withAudioData:(float*)data
{
    _fftBufIndex=0;
    // For an FFT, numSamples must be a power of 2, i.e. is always even
    int nOver2 = bufferSize/2;
    
    // Pack samples:
    // C(re) -> A[n], C(im) -> A[n+1]
    vDSP_ctoz((COMPLEX*)data, 2, &_A, 1, nOver2);
    
    // Perform a forward FFT using fftSetup and A
    // Results are returned in A
    vDSP_fft_zrip(_FFTSetup, &_A, 1, _log2n, FFT_FORWARD);
    
    // Convert COMPLEX_SPLIT A result to magnitudes
    float maxMag = 0;
    
    
    
    int _i_max = 0;
    for(int i=0; i<nOver2; i++)
    {
        // Calculate the magnitude
        float mag = _A.realp[i]*_A.realp[i]+_A.imagp[i]*_A.imagp[i];
        if(maxMag < mag) {
            _i_max = i;
        }
        maxMag = mag > maxMag ? mag : maxMag;
    }
    
    
    
    
    float frequency = _i_max / bufferSize * 44100.0;
    
    //iphone 6 vishnu  7:40 15july
    //fire 3273 debugging,  one code smoke similar
    //alana 3229
    //co1 3531
    //co2 3488
    //cherrie 3186
    //homie 2971 and photo
    
    
    int freq = frequency ;
    if(freq>2000)
        NSLog(@"Freq %d",freq);
    if (freq==3273)
    {
        if(freq==previousFreq)
        {
            [getsFireArray addObject:[NSNumber numberWithFloat:maxMag]];
        }
        else
        {
            [getsFireArray removeLastObject];
        }
    }
    else
        [getsFireArray addObject:[NSNumber numberWithFloat:0.0]];
    
    
    if (freq==2971)
    {
        //        if(freq==previousFreq)
        //        {
        [homieAndPhotoFireArray addObject:[NSNumber numberWithFloat:maxMag]];
        // }
        //        else
        //        {
        //            [homieAndPhotoFireArray removeLastObject];
        //        }
    }
    else
        [homieAndPhotoFireArray addObject:[NSNumber numberWithFloat:0.0]];
    
    
    //culprit 3617-9 times,3488-4times,3574-5times,3531-3times
    
    if (freq==3531||freq==3488||freq==7062||freq==6976)
    {
        if(freq==previousFreq)
        {
            [ambiguousArray addObject:[NSNumber numberWithFloat:maxMag]];
        }
        else
        {
            [ambiguousArray removeLastObject];
        }
        
    }
    
    else
        [ambiguousArray addObject:[NSNumber numberWithFloat:0.0]];
    
    
    //    if (freq==3531)
    //    {
    ////        if(freq==previousFreq)
    ////        {
    //            [kiddeFireArray addObject:[NSNumber numberWithFloat:maxMag]];
    //        //}
    ////        else
    ////        {
    ////            [kiddeFireArray removeLastObject];
    ////
    ////        }
    //
    //    }
    //    else
    //        [kiddeFireArray addObject:[NSNumber numberWithFloat:0.0]];
    
    
    if (freq==3229)
    {
        if(freq==previousFreq)
        {
            [alanaFireArray addObject:[NSNumber numberWithFloat:maxMag]];
        }
        else
        {
            [alanaFireArray addObject:[NSNumber numberWithFloat:0.0]];
            
        }
        
    }
    else
        [alanaFireArray addObject:[NSNumber numberWithFloat:0.0]];
    
    if (freq==3186)
    {
        if(freq==previousFreq)
            [CherrieFireArray addObject:[NSNumber numberWithFloat:maxMag]];
        else
            [CherrieFireArray addObject:[NSNumber numberWithFloat:0.0]];
    }
    
    else
        [CherrieFireArray addObject:[NSNumber numberWithFloat:0.0]];
    
    
    previousFreq = freq;
    
    
    
    
    
}


#pragma mark -
#pragma mark - EZMicrophoneDelegate
-(void)    microphone:(EZMicrophone *)microphone
     hasAudioReceived:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
{
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"Demo"]==nil)
    {
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       if (!timerFlag)
                       {
                           // Update time domain plot
                           //
                           // Setup the FFT if it's not already setup
                           if( !_isFFTSetup )
                           {
                               [self createFFTWithBufferSize:bufferSize withAudioData:buffer[0]];
                               _isFFTSetup = YES;
                           }
                           // Get the FFT data
                           [self updateFFTWithBufferSize:bufferSize withAudioData:buffer[0]];
                       }
                   });
    }
}

#pragma mark -
#pragma mark - Set Off Alarm
-(void)delegateSendImmediate:(MAINTAB)currentTab
{
    [self removeAlarmOverlay];
    [self startWaveAnimation:currentTab];
    [self sendPushToCommunity];
    
}
-(void)setOffAlarmViaNotification : (NSNotification *)n
{
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] endEditing:YES];

    
    
    ISOVERLAYSHOWING = YES ;
    self.type = [n.userInfo valueForKey:@"type"];
    
    self.AlarmObj = [[AlarmOverLayView alloc] init];
    
    if([self.type isEqualToString:@"1"])
    {
        self.AlarmObj.currentTab = FIRE;
        
    }
    else if ([self.type isEqualToString:@"2"])
    {
        self.AlarmObj.currentTab = GUN;
        
    }
    else
    {
        self.AlarmObj.currentTab = CO;
        
    }
    [self.AlarmObj viewColorSetter];
    
    self.AlarmObj.delegate = self;
    [[[UIApplication sharedApplication] keyWindow]addSubview:self.AlarmObj];
    alarmCount = 0 ;
    [self playAlarm];
    alarmTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    
    
    
}
-(void)resetArrays
{
    alanaFireMeanArray = [[NSMutableArray alloc] init];
    CherrieFireMeanArray= [[NSMutableArray alloc] init];
    homieAndPhotoFireMeanArray=[[NSMutableArray alloc] init];
    oneCodeSmokeFireMeanArray=[[NSMutableArray alloc] init];
    ambiguousMeanArray=[[NSMutableArray alloc] init];
    
    alanaFireArray = [[NSMutableArray alloc] init];
    CherrieFireArray= [[NSMutableArray alloc] init];
    homieAndPhotoFireArray=[[NSMutableArray alloc] init];
    oneCodeSmokeFireArray=[[NSMutableArray alloc] init];
    ambiguousArray=[[NSMutableArray alloc] init];
    getsFireArray = [[NSMutableArray alloc] init];
    mainFireMeanArray = [[NSMutableArray alloc] init];
    FreqIndexArray = [[NSMutableArray alloc] init];
    
    getsCOArray = [[NSMutableArray alloc] init];
    mainCOMeanArray = [[NSMutableArray alloc] init];
    mainCOMeanDiffArray = [[NSMutableArray alloc] init];
}
-(void)setOffAlarmViaNotification1 : (NSDictionary *)n
{
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] endEditing:YES];

    [self resetArrays];
    
    ISOVERLAYSHOWING = YES ;
    self.type = [n valueForKey:@"type"];
    self.AlarmObj = [[AlarmOverLayView alloc] init];
    
    self.AlarmObj = [[AlarmOverLayView alloc] init];
    
    if([self.type isEqualToString:@"1"])
    {
        self.AlarmObj.currentTab = FIRE;
        
    }
    else if ([self.type isEqualToString:@"2"])
    {
        self.AlarmObj.currentTab = GUN;
        
    }
    else
    {
        self.AlarmObj.currentTab = CO;
        
    }
    [self.AlarmObj viewColorSetter];
    self.AlarmObj.delegate = self;
    [[[UIApplication sharedApplication] keyWindow]addSubview:self.AlarmObj];
    alarmCount = 0 ;
    [self playAlarm];
    alarmTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    
    
    
}


-(void)handleTimer : (NSTimer *)timer
{
    if (alarmCount==30)
    {
        alarmCount=0;
        [self startWaveAnimation:(self.AlarmObj.currentTab)];

        [self removeAlarmOverlay];
        [self sendPushToCommunity];
        
        return ;
    }
    alarmCount +=1;
    
    self.AlarmObj.overlay_timerLabel.text = [NSString stringWithFormat:@"%d" , 30 - alarmCount];
    if(alarmCount%5!=0)
        self.AlarmObj.overlay_timerImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"timer_%i" , alarmCount%5]];
    else
        self.AlarmObj.overlay_timerImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"timer_5" ]];
    
}

-(void)playAlarm
{
    NSURL *yourMusicFile;
    if([self.type isEqualToString:@"1"])
    {
        NSString *stringType = [[NSUserDefaults standardUserDefaults] valueForKey:@"FireSound"];
        if([stringType isEqualToString:@"FireDefault.mp3"]||[[NSUserDefaults standardUserDefaults] valueForKey:@"FireSound"]==nil)
        {
            yourMusicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"FireDefault" ofType:@"mp3"]];
        }
        else
        {
            yourMusicFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Fire/%@",DOCUMENTS_FOLDER,stringType]];
        }
        
    }
    else if ([self.type isEqualToString:@"2"])
    {
        NSString *stringType = [[NSUserDefaults standardUserDefaults] valueForKey:@"GunSound"];
        if([stringType isEqualToString:@"GunDefault.mp3"]||[[NSUserDefaults standardUserDefaults] valueForKey:@"GunSound"]==nil)
        {
            yourMusicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"GunDefault" ofType:@"mp3"]];
        }
        else
        {
            yourMusicFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Gun/%@",DOCUMENTS_FOLDER,stringType]];
        }
    }
    else
    {
        NSString *stringType = [[NSUserDefaults standardUserDefaults] valueForKey:@"COSound"];
        if([stringType isEqualToString:@"CODefault.mp3"]||[[NSUserDefaults standardUserDefaults] valueForKey:@"COSound"]==nil)
        {
            yourMusicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CODefault" ofType:@"mp3"]];
        }
        else
        {
            yourMusicFile = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/CO/%@",DOCUMENTS_FOLDER,stringType]];
        }
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&setCategoryError]) {
        // handle error
    }
    
    
    
    
    NSError *error = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:yourMusicFile error:&error];
    
    audioPlayer.numberOfLoops = -1;
    audioPlayer.volume = 1.0;
    [audioPlayer play];
    
}



-(void)disarmClicked
{
    
    
    [audioPlayer pause];
    audioPlayer = nil;
    [self removeAlarmOverlay];
    ISOVERLAYSHOWING = NO;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
    }
    
    
}

-(void)removeAlarmOverlay
{
    
    [self.AlarmObj removeFromSuperview];
    self.AlarmObj = nil;
    
    [alarmTimer invalidate];
    alarmTimer = nil;
    
}

-(void)sendPushToCommunity
{
    
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];
    
    
    
}

#pragma mark - Wave Animation View
-(void)startWaveAnimation:(MAINTAB)tab
{
    ISWAVEOVERLAYSHOWING = YES;
    self.waveObj = [WaveAnimationView new];
    self.waveObj.currentTab = tab;
    self.waveObj.delegate = self;
    [[[UIApplication sharedApplication] keyWindow]addSubview:self.waveObj];
    [self.waveObj startOverlayAnimation];
    
}

-(void)waveAnimationTurnOff
{
    
    ISWAVEOVERLAYSHOWING = NO ;
    
    [self.waveObj stopOverlayAnimation];
    [self.waveObj removeFromSuperview];
    self.waveObj = nil;
    
    [audioPlayer pause];
    audioPlayer = nil;
}


#pragma mark -
#pragma mark - Location Manager delegate and helper functions
-(void)locationInitialiser
{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *currentLocation = [locations lastObject];
    
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false&language=us",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
    
    [iOSRequest postNormalData:nil :urlStr success:^(NSDictionary *responseDict) {
        
        
        NSDictionary *dictAddress = [[responseDict valueForKey:@"results"] objectAtIndex:0];
        NSString *addressString = [dictAddress valueForKey:@"formatted_address"];
        if([addressString isEqualToString:@""]||addressString==nil)
        {
            addressString = @"";
        }
        
        NSString *typeString;
        if([self.type isEqualToString:@"1"])
        {
            typeString = @"1";
        }
        else if ([self.type isEqualToString:@"2"])
        {
            typeString = @"3";
            
        }
        else
        {
            typeString = @"2";
            
        }

        
        NSDictionary *dictPara = @{@"user_id":[Profile getCurrentProfileUserId],@"latitude":[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude ],@"longitude":[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude ],@"description":@"",@"type":typeString,@"place":addressString};
        NSString *finalUrl = [NSString stringWithFormat:KOpenTok,KbaseUrl] ;
        [self hitApi:dictPara str:finalUrl];
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
}
-(void)hitApi:(NSDictionary *)dictPara str:(NSString *)urlStr
{
    
    [iOSRequest postNormalData:dictPara :urlStr success:^(NSDictionary *responseDict) {
        [self.waveObj removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setObject:[responseDict valueForKey:@"token"] forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setObject:[responseDict valueForKey:@"sessionId"] forKey:@"sessionId"];
        [self waveAnimationTurnOff];
        [self stopMicrophone];

        if([[NSUserDefaults standardUserDefaults] boolForKey:@"video_permission"]==YES)
        {
            VideoStreamViewController *vStreamVC = [[VideoStreamViewController alloc] init];
            [vStreamVC.view setFrame:self.view.frame];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self presentViewController:vStreamVC animated:YES completion:^{
                    
                }];
            });
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}



#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:KMapFeedSegue])
    {
        MapViewController *mapVC = (MapViewController *)segue.destinationViewController;
        mapVC.dictInfo = sender;
        
    }
    else if ([segue.identifier isEqualToString:KFalseAlarmSegue])
    {
        FalseAlarmViewController *falseVC = (FalseAlarmViewController *)segue.destinationViewController;
        [[NSUserDefaults standardUserDefaults] setObject:sender forKey:@"false"];
       // falseVC.dictInfo  = sender;
    }
    else if ([segue.identifier isEqualToString:KAdminSegue])
    {
        [self.navigationController.navigationBar setHidden:NO];
        AdminMessageViewController *adminVC = (AdminMessageViewController *)segue.destinationViewController;
        adminVC.messageId = [sender valueForKey:@"id"];
        adminVC.messageString = [sender valueForKey:@"m"];
    }

}


@end
