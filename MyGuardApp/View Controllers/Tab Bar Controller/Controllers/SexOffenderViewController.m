//
//  SexOffenderViewController.m
//  MyGuardApp
//
//  Created by vishnu on 16/09/15.
//  Copyright (c) 2015 myguardapps. All rights reserved.
//

#import "SexOffenderViewController.h"

@interface SexOffenderViewController ()
{
    JTMaterialSpinner *loaderObj ;
}

@end

@implementation SexOffenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableViewOffenders setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableViewOffenders setDelegate:self];
    [self.tableViewOffenders setDataSource:self];
//    [self setUpLoaderView];
    //[self getOffenders];
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar setDelegate:self];
    [self.searchBar setShowsCancelButton:YES];
    [self.searchBar setTintColor:[UIColor whiteColor]];
    [self.tableViewOffenders setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    //[self setInAppThing];
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
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"sex_permission"]==false||[[NSUserDefaults standardUserDefaults] valueForKey:@"sex_permission"] == nil)
    {
        [self.tableViewOffenders setHidden:YES];
        [self.viewNoOne setHidden:NO];
        [self.labelCool setText:NSLocalizedString(@"sex_disabled", nil)];
    }
    else if([[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"sex_list"]==nil)
    {
        [self.tableViewOffenders setHidden:YES];
        [self.labelCool setText:NSLocalizedString(@"sex_nearby", nil)];
        [self.viewNoOne setHidden:NO];
    }
    else
    {
        self.arraySexOffender = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"sex_list"];
        [self.tableViewOffenders setHidden:NO];
        if(self.tableViewOffenders.delegate == nil)
        {
            [self.tableViewOffenders setDelegate:self];
            [self.tableViewOffenders setDataSource:self];
        }
        [self.tableViewOffenders reloadData];
        [self.viewNoOne setHidden:YES];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeLoaderView];
}


#pragma mark -
#pragma mark - Search bar delegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    UIButton *btnCancel = [self.searchBar valueForKey:@"_cancelButton"];
    [btnCancel setEnabled:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if(![[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        
        [self.searchBar resignFirstResponder];
        // [self setUpLoaderView];
        
        self.arraySearch = [[NSMutableArray alloc] init];
        for (SexOffender *modal in self.arraySexOffender) {
            if([modal.offenderZipCode respondsToSelector:@selector(containsString:)])
            {
                if ([modal.offenderZipCode containsString:self.searchBar.text])
                {
                    
                    [self.arraySearch addObject:modal];
                    
                }
                else if ([modal.offenderFirstName containsString:self.searchBar.text])
                {
                    [self.arraySearch addObject:modal];
                }
            }
            else
            {
                
                if ([modal.offenderZipCode rangeOfString:self.searchBar.text].length != 0) {
                    
                    [self.arraySearch addObject:modal];
                    
                }
                else if ([modal.offenderFirstName rangeOfString:self.searchBar.text].length != 0) {
                    
                    [self.arraySearch addObject:modal];
                    
                }

            }
            
        }
        
        UIButton *btnCancel = [self.searchBar valueForKey:@"_cancelButton"];
        [btnCancel setEnabled:YES];
        [self.tableViewOffenders reloadData];
        
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self setNavBarAndTab];
    [self.tableViewOffenders reloadData];
    
}


#pragma mark -
#pragma mark - In ap purchase functions
- (void)fetchInAppPurchases {
    [[MyGuardInAppHelper sharedInstance] requestProductWithCompletionHandler:^(BOOL success, NSArray *products) {
        
        
        if (success) {
            //sort products according to price
//            NSSortDescriptor *lowestPriceToHighest = [NSSortDescriptor sortDescriptorWithKey:@"price" ascending:YES];
//            NSArray *sortedProducts = [products sortedArrayUsingDescriptors:[NSArray arrayWithObject:lowestPriceToHighest]];
            
        }
        else {
        }
        
    }];
}


#pragma mark -
#pragma mark - Helper functions
-(void)setInAppThing
{
    self.btnBuy.layer.cornerRadius = 8.0;
    self.btnBuy.clipsToBounds = YES;
    self.btnRestore.layer.cornerRadius = 8.0;
    self.btnRestore.clipsToBounds = YES;

    [self.labelPremium setText:NSLocalizedString(@"sex_premium", nil)];
    [self.btnRestore setTitle:NSLocalizedString(@"restore_purchase", nil) forState:UIControlStateNormal];
    [self.labelPrimiumDes setText:NSLocalizedString(@"sex_description", nil)];
    [self.btnBuy setTitle:[NSString stringWithFormat:@"%@ (%@)",NSLocalizedString(@"sex_activate", nil),@"$20"] forState:UIControlStateNormal];
    [self fetchInAppPurchases];
}
-(void)getOffenders
{
    LOcationUpdater *loc = [LOcationUpdater sharedManager];
    NSArray *array = [CommonFunctions getBoundingBox:10 lat:loc.currentLoc.coordinate.latitude lon:loc.currentLoc.coordinate.longitude];
    [SexOffender callAPIForSexOffenders:[ NSString stringWithFormat:@"http://services.familywatchdog.us/json/json.asp?key=%@&lite=0&type=searchbylatlong&minlat=%@&maxlat=%@&minlong=%@&maxlong=%@",KSEXKEY,[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2],[array objectAtIndex:3]] Params:nil success:^(NSMutableArray *offenderArr) {
        self.arraySexOffender = [NSMutableArray arrayWithArray:offenderArr];
        [self.tableViewOffenders reloadData];
        [self removeLoaderView];
        
    } failure:^(NSString *errorStr) {
        [self removeLoaderView];
        
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
    
    LOcationUpdater *locationUpdater = [LOcationUpdater sharedManager];
    if(locationUpdater.imageDp!=nil)
    {
        UIButton *btnProfileA = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [btnProfileA setImage:locationUpdater.imageDp forState:UIControlStateNormal];
        [btnProfileA addTarget:self action:@selector(actionProfile) forControlEvents:UIControlEventTouchUpInside];
        btnProfileA.layer.cornerRadius = btnProfileA.frame.size.width/2;
        btnProfileA.layer.borderColor = [[UIColor whiteColor] CGColor];
        btnProfileA.layer.borderWidth = 1.0;
        
        
        UIBarButtonItem *btnProfile = [[UIBarButtonItem alloc] initWithCustomView:btnProfileA];
        [btnProfile setTintColor:[UIColor whiteColor]];
        btnProfile.customView.clipsToBounds = YES;

        self.navigationItem.leftBarButtonItem = btnProfile;
        
    }
    else
    {
        Profile *modal = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSData *tmpdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:modal.profileImageFullLink]];
            
            UIImage *image = [UIImage imageWithData:tmpdata];
            image = [image circularScaleAndCropImage:CGRectMake(0, 0, image.size.width, image.size.width)];
            image = [image imageByScalingAndCroppingForSize:CGSizeMake(image.size.width, image.size.width)];
            locationUpdater.imageDp = image;
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
                btnProfile.customView.clipsToBounds = YES;

            });
            
        });
    }
    
//    if([[NSUserDefaults standardUserDefaults] valueForKey:@"purchased"]!=nil)
//    {
//        UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_search"] style:UIBarButtonItemStylePlain target:self action:@selector(actionSearch)];
//        [btnSearch setTintColor:[UIColor whiteColor]];
//        self.navigationItem.rightBarButtonItem = btnSearch;
  //  }
    
    self.navigationItem.titleView = nil;
    
}
-(void)setSearchInNavBar
{
    self.navigationItem.title = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [self.navigationItem setTitleView:self.searchBar];
    [self.searchBar becomeFirstResponder];
}


#pragma mark -
#pragma mark - Button Actions
-(void)actionProfile
{
    [self performSegueWithIdentifier:KMyProfileSegue sender:nil];
}

-(void)actionSearch
{
    [self setSearchInNavBar];
}

#pragma mark -
#pragma mark - Table View Delegate and datasource functions
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.navigationItem.leftBarButtonItem==nil)
        return self.arraySearch.count;
    else
        return self.arraySexOffender.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SexOffenderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SexOffenderCell"];
    [self configureCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    return size.height;
}
-(void)configureCell:(SexOffenderCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SexOffender *modal;
    if(self.navigationItem.leftBarButtonItem==nil)
        modal = [self.arraySearch objectAtIndex:indexPath.row];
    else
        modal = [self.arraySexOffender objectAtIndex:indexPath.row];
    
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
    
    if([segue.identifier isEqualToString:KSexOffenderDetailSegue])
    {
        SexOffenderDetailViewController *sexVC = (SexOffenderDetailViewController *)segue.destinationViewController;
        sexVC.sexOffenderModal = self.sexOffenderModal;
    }
    
    
}



- (IBAction)actionBuy:(id)sender {
}

- (IBAction)actionRestore:(id)sender {
}
@end
