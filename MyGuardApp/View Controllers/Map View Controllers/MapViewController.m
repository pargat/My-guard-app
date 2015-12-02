//
//  MapViewController.m
//  MyGuardApp
//
//  Created by vishnu on 13/10/15.
//  Copyright © 2015 myguardapps. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
{
    GMSMapView *mapView;
}
@end

@implementation MapViewController

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
        [self viewSetter];
    if(self.feed!=nil)
    {
        [self mapSetterFeed];
        self.constraintHeight.constant = 0;
        [self.btnHush setHidden:YES];
        self.navigationController.navigationBarHidden = NO;
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(actionBack)];
        [btnBack setTintColor:[UIColor whiteColor]];
        self.navigationItem.leftBarButtonItem = btnBack;
        [self.navigationItem setTitle:NSLocalizedString(@"map", nil)];

    }
    else
    {
        [self mapSetterInfo];
        self.navigationController.navigationBarHidden = YES;

    }
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];



}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.synth.delegate = nil;
    self.synth = nil;
}
#pragma mark - 
#pragma mark - View Helpers
- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

-(void)viewSetter
{
    [self.btnHush setTitle:NSLocalizedString(@"hush", nil) forState:UIControlStateNormal];
    [self.labelAddress setPreferredMaxLayoutWidth:[[UIScreen mainScreen] bounds].size.width-116];
    [self.labelDescription1 setPreferredMaxLayoutWidth:[[UIScreen mainScreen] bounds].size.width-116
];
    
    self.imageViewDp.layer.cornerRadius = self.imageViewDp.frame.size.width/2;
    self.imageViewDp.clipsToBounds = YES;
}

-(void)mapSetterFeed
{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    
    //extra settings
    [self.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:KBaseTimbthumbUrl,self.feed.feed_imageName,self.imageViewDp.frame.size.width*DisplayScale,self.imageViewDp.frame.size.height*DisplayScale]]];
    NSString *imageString ;
    NSString *typeString;
    
    if ([self.feed.feed_type isEqualToString:@"1"]) {
        imageString = @"tb_fire_pressed.png";
        typeString = @"Fire";
        [self.navigationController.navigationBar setBarTintColor:KOrangeColor];
    }
    else if ([self.feed.feed_type isEqualToString:@"3"])
    {
        imageString = @"tb_gun_pressed.png";
        typeString = @"Gun Shot";
         [self.navigationController.navigationBar setBarTintColor:KRedColor];
    }
    else
    {
        imageString = @"tb_co_pressed.png";
        typeString = @"CO";
         [self.navigationController.navigationBar setBarTintColor:KGreenColor];
    }
    [self.imageViewType setImage:[UIImage imageNamed:imageString]];
    NSMutableAttributedString *stringMut = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *stringAtt = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.feed.feed_fullname] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    
    
    
    
    NSAttributedString *stringFlag = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" is in a possible emergency %@ environment",typeString] attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    [stringMut appendAttributedString:stringAtt];
    [stringMut appendAttributedString:stringFlag];
    
    [self.labelDescription1 setAttributedText:stringMut];
    [self.labelAddress setText:self.feed.feed_address];
    if([self.feed.feed_address isEqualToString:@""])
    {
        [self.labelAddress setText:@"N.A."];
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.feed.feed_lat floatValue]
                                                            longitude:[self.feed.feed_lng floatValue]
                                                                 zoom:6];
    
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    //self.view = mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([self.feed.feed_lat floatValue],[self.feed.feed_lng floatValue]);
    marker.title = self.feed.feed_fullname;
    //marker.snippet = [NSString stringWithFormat:@"%f, %f",[self.feedDetail.feed_lat floatValue],[self.feedDetail.feed_lng floatValue]];
    marker.icon = [UIImage imageNamed:@"ic_pin.png"];
    marker.map = mapView;
    
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewMapHolder addSubview:mapView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.viewMapHolder attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.viewMapHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.viewMapHolder attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.viewMapHolder attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:mapView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];

}
-(void)mapSetterInfo
{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    
    
    
    //Extra Settings
    
    NSString *imageString ;
    NSString *typeString;
    if ([[self.dictInfo valueForKey:@"y"] isEqualToString:@"1"]) {
        imageString = @"tb_fire_pressed.png";
        typeString = @"Fire";
        [self.btnHush setBackgroundColor:KOrangeColor];
         [self.navigationController.navigationBar setBarTintColor:KOrangeColor];
        
    }
    else if ([[self.dictInfo valueForKey:@"y"] isEqualToString:@"3"])
    {
        imageString = @"tb_gun_pressed.png";
        typeString = @"Gun Shot";
        [self.btnHush setBackgroundColor:KRedColor];
         [self.navigationController.navigationBar setBarTintColor:KRedColor];
    }
    else
    {
        imageString = @"tb_co_pressed.png";
        typeString = @"CO";
        [self.btnHush setBackgroundColor:KGreenColor];
         [self.navigationController.navigationBar setBarTintColor:KGreenColor];
        
    }
    [self.imageViewType setImage:[UIImage imageNamed:typeString]];
    
    
    NSMutableAttributedString *stringMut = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *stringAtt = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[self.dictInfo valueForKey:@"n"]] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    
    
    
    
    NSAttributedString *stringFlag = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" is in a possible emergency %@ environment",typeString] attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    [stringMut appendAttributedString:stringAtt];
    [stringMut appendAttributedString:stringFlag];
    
    
    self.stringSpeech = [NSString stringWithFormat:@"%@ is in a possible emergency %@ environment at %@",[self.dictInfo valueForKey:@"n"],typeString, [self.dictInfo valueForKey:@"a"]];
    
    [self.labelAddress setText:[self.dictInfo valueForKey:@"a"]];
    if([[self.dictInfo valueForKey:@"a"] isEqualToString:@""])
    {
        [self.labelAddress setText:@"N.A."];
    }
    
    [self.imageViewDp sd_setImageWithURL:[NSURL URLWithString:[self.dictInfo valueForKey:@"image"]]];
    [self.labelDescription1 setAttributedText:stringMut];
    [self speakUtteranceSetup];
    
    
    
    
    
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[self.dictInfo valueForKey:@"l1"] floatValue]
                                                            longitude:[[self.dictInfo valueForKey:@"l2"] floatValue]
                                                                 zoom:6];
    
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    mapView.myLocationEnabled = YES;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([[self.dictInfo valueForKey:@"l1"] floatValue],[[self.dictInfo valueForKey:@"l2"] floatValue]);
    marker.title = self.feed.feed_fullname;
    //marker.snippet = [NSString stringWithFormat:@"%f, %f",[self.feedDetail.feed_lat floatValue],[self.feedDetail.feed_lng floatValue]];
    marker.icon = [UIImage imageNamed:@"ic_pin.png"];
    marker.map = mapView;
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewMapHolder addSubview:mapView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.viewMapHolder attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.viewMapHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.viewMapHolder attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.viewMapHolder attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:mapView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
}
-(void)speakUtteranceSetup
{
    [CommonFunctions videoPlay];
    AVSpeechUtterance *utterance = [AVSpeechUtterance
                                    speechUtteranceWithString:self.stringSpeech];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    
    self.synth = [[AVSpeechSynthesizer alloc] init];
    self.synth.delegate = self;
    
    [self.synth speakUtterance:utterance];
    [self.synth continueSpeaking];
}
#pragma mark -
#pragma mark - avspeechsynthesizer delegate
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    
    
    [synthesizer speakUtterance:utterance];
    
}


#pragma mark -
#pragma mark - Button Actions
- (void)actionBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionHush:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
