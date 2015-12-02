//
//  VideoStreamViewController.m
//  FireSonar
//
//  Created by vishnu on 20/07/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

#import "VideoStreamViewController.h"
static NSString *const kApiKey = @"45282132";

@interface VideoStreamViewController ()
{
    OTSession *_session;
    OTPublisher *_publisher;

}
@end

@implementation VideoStreamViewController

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
    [self setupSession];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(16, 16, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
}
#pragma mark - 
#pragma mark - open tok session setup
- (void)setupSession
{
    //setup one time session
    if (_session) {
        _session = nil;
    }
    
    _session = [[OTSession alloc] initWithApiKey:kApiKey
                                       sessionId:[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionId"]
                                        delegate:self];
    [_session connectWithToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"token"] error:nil];
    
    [self setupPublisher];
    
}

- (void)setupPublisher
{
    // create one time publisher and style publisher
    //   _publisher = [[OTPublisher alloc] initWithDelegate:selfname:[[UIDevice currentDevice] name]];
    
    // create one time publisher and style publisher
    _publisher = [[OTPublisher alloc]
                  initWithDelegate:self
                  name:@"vishnu"];
    
    _publisher.cameraPosition = AVCaptureDevicePositionBack;
    [_publisher.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)]; 
    
    [self.view addSubview:_publisher.view];
    
    
}


#pragma mark -
#pragma mark - OTSession delegate
- (void)sessionDidConnect:(OTSession*)session
{
    OTError *error;
    [_session publish:_publisher error:&error];

}

- (void)sessionDidDisconnect:(OTSession*)session
{
    
}
- (void)session:(OTSession*)session didFailWithError:(OTError*)error
{
    
}

#pragma mark - 
#pragma mark - OTpublisher delegate
- (void)publisher:(OTPublisherKit*)publisher streamCreated:(OTStream*)stream
{
    
}

-(void)actionBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
