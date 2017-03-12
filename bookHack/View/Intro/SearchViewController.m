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
    [self switchInputFieldPlaceHolderColor];
    
}

-(void)switchBackgroundImageView{
    imageIndex ++;
    imageIndex = imageIndex % imageNames.count;
    self.imageViewBackground.image = [UIImage imageNamed:imageNames[imageIndex]];
    
    
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
        [[PCNetworkManager shareInstance]getSearchResultByKeyword:textField.text completionBlock:^(NSArray *results) {
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
    [[PCNetworkManager shareInstance] getScenesFromPlaceID:result.placeID completionBlock:^(NSArray *results) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (results.count > 0) {
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
    SwipeViewController *swipeVC = [storyBoard instantiateViewControllerWithIdentifier:@"SwipeViewID"];
    swipeVC.candidates = result;
    swipeVC.searchItem = searchItem;
    
    
    [self.navigationController pushViewController:swipeVC animated:YES];
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
