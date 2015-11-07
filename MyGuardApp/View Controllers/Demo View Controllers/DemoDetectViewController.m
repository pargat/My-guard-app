//
//  DemoDetectViewController.m
//  MyGuardApp
//
//  Created by vishnu on 26/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "DemoDetectViewController.h"



@interface DemoDetectViewController ()
{
    
    const UInt32 FFTLEN;
    int _fftBufIndex;
    float * _fftBuf;
    int samplesRemaining;
    int previousFreq;
    
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
    
    
    NSTimer *alarmTimer ;
    
    
}
@property NSTimer *twoHunMSTimer;

@end

@implementation DemoDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self viewHelper];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CommonFunctions recordAudio];

    self.navigationController.navigationBarHidden = YES;
    self.microphone = [EZMicrophone microphoneWithDelegate:self startsImmediately:YES];
    self.twoHunMSTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(TwoHundredMSSampling) userInfo:nil repeats:YES];
        [self initialiseArray];

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.microphone setDelegate:nil];
    self.microphone = nil;
    
}

#pragma mark -
#pragma mark - View Helper
-(void)openDemoHush
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.microphone = nil;
        [self.twoHunMSTimer invalidate];
        [self performSegueWithIdentifier:KDemoHushSegue sender:nil];
        
    });
}
-(void)initialiseArray
{
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
}
-(void)viewHelper
{
    [self.labrlTitle setText:NSLocalizedString(@"detect_alarm_title", nil)];
    [self.labelDescription setText:NSLocalizedString(@"detect_alarm_description", nil)];
    NSMutableAttributedString *attButtonTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"Click" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    [attButtonTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@" here " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:204/255.0 blue:0 alpha:1]}]];
    [attButtonTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@"if nothing works" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    
    [self.btnClickhere setAttributedTitle:attButtonTitle forState:UIControlStateNormal];
    [self.audioPlot setBackgroundColor:KPurpleColorNav];
    [self.audioPlot setColor:[UIColor lightGrayColor]];
    self.audioPlot.gain = 2;
    
    
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
        
        
        if ( [replaceOnesWithY hasPrefix:@"xyxyxy"])
        {
            
            int times = (int)[[original componentsSeparatedByString:@"1"] count]-1;
            if(times>=5)
            {
                [self openDemoHush];
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
            if ([[original substringToIndex:4] containsString:@"1111"]&&[[original substringToIndex:1] isEqualToString:@"1"]&&![[original substringFromIndex:5] containsString:@"1"])
            {
                [self openDemoHush];
                return;
            }
        }
        else
        {
            
            if ([[original substringToIndex:4] rangeOfString:@"1111"].length != 0&&[[original substringFromIndex:5] rangeOfString:@"1"].length == 0) {
                
                [self openDemoHush];
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
        
        
        if ( [replaceOnesWithY hasPrefix:@"xyxyxy"])
        {
            int times =(int) [[original componentsSeparatedByString:@"1"] count]-1;
            if(times>=6)
            {
                [self openDemoHush];
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
        
        
        if ( [replaceOnesWithY hasPrefix:@"xyxyxy"])
        {
            int times =(int) [[original componentsSeparatedByString:@"1"] count]-1;
            if(times>=6)
            {
                [self openDemoHush];
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
        
        
        if ( [replaceOnesWithY hasPrefix:@"xyxyxy"]  && [[NSUserDefaults standardUserDefaults] valueForKey:@"profile"] != nil)
        {
            
            int times = (int)[[original componentsSeparatedByString:@"1"] count]-1;
            if(times>=6)
            {
                [self openDemoHush];
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
        
        
        if ( [replaceOnesWithY hasPrefix:@"xyxyxy"])
        {
            int times = (int)[[original componentsSeparatedByString:@"1"] count]-1;
            if(times>=6)
            {
                [self openDemoHush];
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
        
        
        if ( [replaceOnesWithY hasPrefix:@"xyxyxy"])
        {
            int times = (int)[[original componentsSeparatedByString:@"1"] count]-1;
            if(times>=6)
            {
                [self openDemoHush];
                return;
            }
            
            
        }
        
    }
    
    
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
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            // All the audio plot needs is the buffer data (float*) and the size.
        //            // Internally the audio plot will handle all the drawing related code,
        //            // history management, and freeing its own resources. Hence, one badass
        //            // line of code gets you a pretty plot :)
        //            [self.audioPlot updateBuffer:data withBufferSize:bufferSize];
        //        });
        
    }
    else
    {
        [getsFireArray addObject:[NSNumber numberWithFloat:0.0]];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            // All the audio plot needs is the buffer data (float*) and the size.
        //            // Internally the audio plot will handle all the drawing related code,
        //            // history management, and freeing its own resources. Hence, one badass
        //            // line of code gets you a pretty plot :)
        //            [self.audioPlot updateBuffer:nil withBufferSize:bufferSize];
        //        });
        
    }
    
    
    if (freq==2971)
    {
        [homieAndPhotoFireArray addObject:[NSNumber numberWithFloat:maxMag]];
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
    @try {
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
        dispatch_async(dispatch_get_main_queue(), ^{
            // All the audio plot needs is the buffer data (float*) and the size.
            // Internally the audio plot will handle all the drawing related code,
            // history management, and freeing its own resources. Hence, one badass
            // line of code gets you a pretty plot :)
            [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
        });

    }
    @catch (NSException *exception) {
        
    }
    
    
    
}


#pragma mark -
#pragma mark- button actions

- (IBAction)actionClickHer:(id)sender {
}

- (IBAction)actionCloseDemo:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count-3] animated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
