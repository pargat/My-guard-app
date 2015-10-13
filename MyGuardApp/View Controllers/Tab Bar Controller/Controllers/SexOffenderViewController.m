//
//  SexOffenderViewController.m
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "SexOffenderViewController.h"

@interface SexOffenderViewController ()

@end

@implementation SexOffenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableViewOffenders setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableViewOffenders setDelegate:self];
    [self.tableViewOffenders setDataSource:self];
    [self getOffenders];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBarAndTab];
    
}



#pragma mark -
#pragma mark - Helper functions
-(void)getOffenders
{
    [SexOffender callAPIForSexOffenders:@"http://services.familywatchdog.us/json/json.asp?key=YOUR-KEY-HERE&lite=0&type=searchbylatlong&minlat=39.9537592&maxlat=39.9557592&minlong=-75.2694439&maxlong=-75.2654439" Params:nil success:^(NSMutableArray *offenderArr) {
        self.arraySexOffender = [NSMutableArray arrayWithArray:offenderArr];
        [self.tableViewOffenders reloadData];
    } failure:^(NSString *errorStr) {
        
    }];
}
-(void)setNavBarAndTab
{
    [self.tabBarController.tabBar setTintColor:KPurpleColor];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBarTintColor:KPurpleColorNav];
    [navigationBar setBarStyle:UIBarStyleBlack];
    [navigationBar setTranslucent:NO];
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [navigationBar setShadowImage:[UIImage new]];
    [self.navigationItem setTitle:NSLocalizedString(@"tb_sex_offenders", nil)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *tmpdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://api.firesonar.com/FireSonar/timthumb.php?src=uploads/iSf0mKHUG5vgEt2pncuW.jpeg"]];
        UIImage *image = [UIImage imageWithData:tmpdata];
        image = [image circularScaleAndCropImage:CGRectMake(0, 0, 32, 32)];
        image = [image imageByScalingAndCroppingForSize:CGSizeMake(32, 32)];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIButton *btnProfileA = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
            [btnProfileA setImage:image forState:UIControlStateNormal];
            [btnProfileA addTarget:self action:@selector(actionProfile) forControlEvents:UIControlEventTouchUpInside];
            btnProfileA.layer.cornerRadius = btnProfileA.frame.size.width/2;
            btnProfileA.layer.borderColor = [[UIColor whiteColor] CGColor];
            btnProfileA.layer.borderWidth = 1.0;
            
            
            UIBarButtonItem *btnProfile = [[UIBarButtonItem alloc] initWithCustomView:btnProfileA];
            [btnProfile setTintColor:[UIColor whiteColor]];
            self.navigationItem.leftBarButtonItem = btnProfile;
        });
        
    });

}
#pragma mark -
#pragma mark - lat long calculating formula

-(NSArray *)getBoundingBox:(double)kilometers lat:(double)lat lon:(double)lon
{
    double R = 6371; // earth radius in km
    double lat1 = lat - (M_PI/180) *(kilometers / R);
    double lon1 = lon - (M_PI/180) *(kilometers / R / cos(lat*180/M_PI));
    double lat2 = lat + (M_PI/180) *(kilometers / R);
    double lon2 = lon +(M_PI/180) *(kilometers / R / cos(lat*180/M_PI));
    return @[[NSString stringWithFormat:@"%f",lat1],[NSString stringWithFormat:@"%f",lon1],[NSString stringWithFormat:@"%f",lat2],[NSString stringWithFormat:@"%f",lon2]];
}


#pragma mark -
#pragma mark - Button Actions
-(void)actionProfile
{
    
}


#pragma mark - 
#pragma mark - Table View Delegate and datasource functions
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arraySexOffender.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SexOffenderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SexOffenderCell"];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static SexOffenderCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableViewOffenders dequeueReusableCellWithIdentifier:@"SexOffenderCell"];
    });

    [self configureCell:sizingCell atIndexPath:indexPath];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}
-(void)configureCell:(SexOffenderCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SexOffender *modal = [self.arraySexOffender objectAtIndex:indexPath.row];
    [cell.imageViewDp sd_setImageWithURL:[NSURL URLWithString:modal.offenderPhoto]];
    [cell.labelName setText:modal.offenderName];
    [cell.labelDescription setText:[NSString stringWithFormat:@"Age : %@ Sex : %@",modal.offenderAge,modal.offenderSex]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.sexOffenderModal = [self.arraySexOffender objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:KSexOffenderDetailSegue sender:self];
}

#pragma mark -
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    SexOffenderDetailViewController *sexVC = (SexOffenderDetailViewController *)segue.destinationViewController;
    sexVC.sexOffenderModal = self.sexOffenderModal;
    

}


@end
