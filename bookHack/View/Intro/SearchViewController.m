//
//  SearchViewController.m
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "SwipeViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <QuartzCore/QuartzCore.h>

@interface SearchViewController ()<UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (strong, nonatomic) IBOutlet UITextField *inputField;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray<GMSAutocompletePrediction*> *searchResults;
@end

@implementation SearchViewController{
    NSTimer *headerTimer;
    NSArray *headerTexts;
    NSArray *placeHolderColor;
    NSInteger headerIndex;
    NSArray *imageNames;
    NSInteger imageIndex;
    NSTimer *imageTimer;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupViewData];
    [self switchHeaderLabelText];
    [self switchBackgroundImageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startAnimateView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopAnimateView];
}

#pragma mark - View
-(void)setupView{
    //field
    self.inputField.delegate = self;
    [self.inputField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //imageView
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.imageViewBackground addGestureRecognizer:tapGesture];
    [self.imageViewBackground setUserInteractionEnabled:YES];
}
-(void)switchHeaderLabelText{
    headerIndex ++;
    headerIndex = headerIndex % headerTexts.count;
    self.inputField.placeholder = headerTexts[headerIndex];
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [self.inputField.layer addAnimation:transition forKey:nil];
    [self switchInputFieldPlaceHolderColor];
    
}

-(void)switchBackgroundImageView{
    imageIndex ++;
    imageIndex = imageIndex % imageNames.count;
    self.imageViewBackground.image = [UIImage imageNamed:imageNames[imageIndex]];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [self.imageViewBackground.layer addAnimation:transition forKey:nil];
    
}

-(void)switchInputFieldPlaceHolderColor{
    [self.inputField setValue:placeHolderColor[imageIndex]
                    forKeyPath:@"_placeholderLabel.textColor"];
}
-(void)showTableView{
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 150, self.view.frame.size.width-20, 130)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.layer.cornerRadius = 5;
        self.tableView.clipsToBounds = YES;
        [self.view addSubview:self.tableView];
        [self.tableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
        
    }
    self.tableView.alpha = 0.8;
    
    [self.tableView reloadData];
}

-(void)dismissTableView{
    self.tableView.alpha = 0;
}

-(void)hideKeyboard:(UIGestureRecognizer*)gesture{
    [self.inputField resignFirstResponder];
}
#pragma mark - Data
-(void)setupViewData{
    headerTexts = @[@"Where To Fun ?", @"Where To Go ?", @"Where To Trip ?"];
    imageNames = @[@"ca0",@"dt0",@"dt1",@"eng0", @"eng1", @"jp0", @"jp1", @"tw0", @"tw1"];
    placeHolderColor = @[[UIColor darkGrayColor],[UIColor darkGrayColor], [UIColor darkGrayColor], [UIColor darkGrayColor], [UIColor darkGrayColor], [UIColor darkGrayColor], [UIColor darkGrayColor], [UIColor darkGrayColor],[UIColor darkGrayColor]];
    self.searchResults = [NSMutableArray new];
}

#pragma mark - Timer
-(void)startAnimateView{
    [self switchBackgroundImageView];
    [self switchHeaderLabelText];
    imageTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(switchBackgroundImageView) userInfo:nil repeats:YES];
    headerTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(switchHeaderLabelText) userInfo:nil repeats:YES];
    imageIndex = 0;
    headerIndex = 0;
}
-(void)stopAnimateView{
    [imageTimer invalidate];
    imageTimer = nil;
    [headerTimer invalidate];
    headerTimer = nil;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldDidChange:(UITextField*)textField{
    NSLog(@"text field text:%@", self.inputField.text);
    __weak typeof (self) weakSelf = self;
    if (self.inputField.text && self.inputField.text.length > 0) {
        [[PCNetworkManager shareInstance]getSearchResultByKeyword:textField.text completionBlock:^(NSArray *results, NSError *error) {
            if (error) {
                NSLog(@"error :%@",error.localizedDescription);
                return;
            }
            if (results && results.count > 0) {
                weakSelf.searchResults = results;
            }
            [weakSelf showTableView];
        }];
    }else{
        [self dismissTableView];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    GMSAutocompletePrediction *result = self.searchResults[indexPath.row];
    cell.labelMain.text = result.attributedFullText.string;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GMSAutocompletePrediction *result = self.searchResults[indexPath.row];
    self.inputField.text = result.attributedFullText.string;
    [self dismissTableView];
    [self hideKeyboard:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof (self)weakSelf = self;
    [[PCNetworkManager shareInstance] getScenesFromPlaceID:result.placeID completionBlock:^(NSArray *results, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [weakSelf presentSwipeViewCcontrollerFromResult:[weakSelf getDemoResultData]];
        }else if (results.count > 0) {
            [weakSelf presentSwipeViewCcontrollerFromResult:results];
        }
    }];
    NSLog(@"select search hint for: %@", result.attributedFullText.string);
}

#pragma mark - Get Scene


-(void)presentSwipeViewCcontrollerFromResult:(NSArray*)result{
    //TODO:for demo setting
    PCSearchItem *searchItem = [PCSearchItem new];
    PCMapSceneItem *firstScen = result[0];
    searchItem.location = [[CLLocation alloc] initWithLatitude:firstScen.coordinate.latitude longitude:firstScen.coordinate.longitude];
    searchItem.targetPlace = self.inputField.text;
    
    //view segue
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Swipe" bundle:nil];
    SwipeViewController *swipeVC = [storyBoard instantiateInitialViewController];
    swipeVC.candidates = result;
    swipeVC.searchItem = searchItem;
    
    
    [self.navigationController pushViewController:swipeVC animated:YES];
}

#pragma mark - DEMO
-(NSArray*)getDemoResultData{
    PCMapSceneItem *item0 = [[PCMapSceneItem alloc]initWithLocation:[[CLLocation alloc] initWithLatitude:25.0380339 longitude:121.5014004] name:@"台北植物園"];
    item0.thumbnailImageURL = [NSURL URLWithString:@"https://lh4.googleusercontent.com/proxy/LPtqpIUNOQNtbmuLaBylddZLtFiuQ_QvU6XFmiv8R5tGAXMF_FWgZVixLs5QbwifkmdwakllQGhbkTNwrn352uI13S-0fJDMfu_ejlAB51pbI6XSmNPjiADFpJa-szPqylV0XPIMX5M3c5XY17qYsa6VoJcX10k=w408-h305"];
    
    PCMapSceneItem *item1 = [[PCMapSceneItem alloc]initWithLocation:[[CLLocation alloc] initWithLatitude:24.9865959 longitude:121.5424077] name:@"光點台北"];
    item1.thumbnailImageURL = [NSURL URLWithString:@"https://lh6.googleusercontent.com/proxy/IvgfqO7csUgAJBPho0llNwy6V4Q8BMb1fEu5OiphnlsaYx5rXBZOngwDjAJgYXHI4am7_MGz72xCjejk0GsCql86lwuk-uNafgsfCY6-nflgXcWUlEkpxxWsIomcO0zBSv8T2tY39U_A0pjxrAIkkOdm18CUSw=w528-h200"];
    PCMapSceneItem *item2 = [[PCMapSceneItem alloc]initWithLocation:[[CLLocation alloc] initWithLatitude:25.0336322 longitude:121.5074203] name:@"龍山寺"];
    item2.thumbnailImageURL = [NSURL URLWithString:@"https://lh6.googleusercontent.com/proxy/U6jSB6YG_V_-vClVtzQbS2JpNhWJd1800ufoe4gXUtR1mCPnLV_DY_553W6ZLAqEB5XvJEZnIu-ZHiEJfB0S_xeWEWXZ3ebSaCEcTmCA6dftEb0Ia4UDpTB2D9vQw2IxrZlOFBCmS_IEpit-5ZVW8lXFGx4m5Yk=w408-h271"];
    PCMapSceneItem *item3 = [[PCMapSceneItem alloc]initWithLocation:[[CLLocation alloc] initWithLatitude:25.0300942 longitude:121.5176439] name:@"中正紀念堂"];
    item2.thumbnailImageURL = [NSURL URLWithString:@"https://lh6.googleusercontent.com/proxy/RN-QhnDKLjGwlnmf4KCDCt7prFFq3H6088YvTc9Gufj_WP31XY2qzZFaMJWglwUPHUjSdqbSlK_iAi-QfKVuZYRI9payxs2xTFaz7V2Kuu_oBxqWLW9cAYQK7XucYV7dsQ3E4s9eInYdgR_J4oJOcR3aNVF4DA=w408-h271"];
    PCMapSceneItem *item4 = [[PCMapSceneItem alloc]initWithLocation:[[CLLocation alloc] initWithLatitude:25.0300942 longitude:121.5176439] name:@"228"];
    item2.thumbnailImageURL = [NSURL URLWithString:@"https://lh6.googleusercontent.com/proxy/HhApW56QpLZmVcSes_i5M8pl9EVwuhHodVxMw-rALeLXju7p54JXOliAR9hNxRd8VERBgUSPkAaWt9Rzt2qluhL5Of6-IVxz6zVfRWdXUbbQDrRGJX1W1IK3hb1y04MUa4lfR6CADM_sL88qSqVzsLSdS5thTb8=w408-h306"];
    
    
    NSArray *demoItems = [NSMutableArray arrayWithObjects:item0, item1, item2, item3, item4, nil];
    
    return demoItems;
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
