//
//  SwipeViewController.m
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "SwipeViewController.h"
#import "CardView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MapViewController.h"

@interface SwipeViewController ()

@property (strong, nonatomic) IBOutlet ZLSwipeableView *swipeableView;
@property (strong, nonatomic) IBOutlet UIButton *buttonFavor;
@property (strong, nonatomic) IBOutlet UIButton *buttonDelete;
@property (strong, nonatomic) IBOutlet UIButton *buttonRetry;
@property (strong, nonatomic) IBOutlet UILabel *labelRetry;



@property (nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSMutableArray *favoriteList;
@property (strong, nonatomic) NSMutableArray *relatedHotelList;
@end

@implementation SwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTestData];
    [self setupButton];
    [self loadSwipeView];
    [self updateCardsFromServer];
}

-(void)loadSwipeView{
    self.currentIndex = 0;
    self.swipeableView.dataSource = self;
    self.swipeableView.delegate = self;
    self.swipeableView.allowedDirection = ZLSwipeableViewDirectionHorizontal;
    self.swipeableView.numberOfActiveViews = self.candidates.count;
    [self.swipeableView loadViewsIfNeeded];
}

-(void)setupButton{
    [[self.buttonFavor imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.buttonDelete imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.buttonRetry imageView] setContentMode: UIViewContentModeScaleAspectFit];
    //hide retry button at first time
    [self showRetryButton:NO];
}

-(void)showRetryButton:(BOOL)isRetry{
    if (isRetry) {
        [UIView animateWithDuration:0.5 animations:^{
            self.buttonRetry.alpha = 1;
            self.labelRetry.alpha = 1;
            self.buttonFavor.alpha = 0;
            self.buttonDelete.alpha = 0;
            
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.buttonRetry.alpha = 0;
            self.labelRetry.alpha = 0;
            self.buttonFavor.alpha = 1;
            self.buttonDelete.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)loadTestData{
    PCMapSceneItem *item0 = [[PCMapSceneItem alloc]initWithLocation:[[CLLocation alloc] initWithLatitude:25.0380339 longitude:121.5014004] name:@"台北植物園"];
    item0.thumbnailImageURL = [NSURL URLWithString:@"https://lh4.googleusercontent.com/proxy/LPtqpIUNOQNtbmuLaBylddZLtFiuQ_QvU6XFmiv8R5tGAXMF_FWgZVixLs5QbwifkmdwakllQGhbkTNwrn352uI13S-0fJDMfu_ejlAB51pbI6XSmNPjiADFpJa-szPqylV0XPIMX5M3c5XY17qYsa6VoJcX10k=w408-h305"];
    
    PCMapSceneItem *item1 = [[PCMapSceneItem alloc]initWithLocation:[[CLLocation alloc] initWithLatitude:24.9865959 longitude:121.5424077] name:@"光點台北"];
    item1.thumbnailImageURL = [NSURL URLWithString:@"https://lh6.googleusercontent.com/proxy/IvgfqO7csUgAJBPho0llNwy6V4Q8BMb1fEu5OiphnlsaYx5rXBZOngwDjAJgYXHI4am7_MGz72xCjejk0GsCql86lwuk-uNafgsfCY6-nflgXcWUlEkpxxWsIomcO0zBSv8T2tY39U_A0pjxrAIkkOdm18CUSw=w528-h200"];
    PCMapSceneItem *item2 = [[PCMapSceneItem alloc]initWithLocation:[[CLLocation alloc] initWithLatitude:25.0336322 longitude:121.5074203] name:@"龍山寺"];
    item2.thumbnailImageURL = [NSURL URLWithString:@"https://lh6.googleusercontent.com/proxy/U6jSB6YG_V_-vClVtzQbS2JpNhWJd1800ufoe4gXUtR1mCPnLV_DY_553W6ZLAqEB5XvJEZnIu-ZHiEJfB0S_xeWEWXZ3ebSaCEcTmCA6dftEb0Ia4UDpTB2D9vQw2IxrZlOFBCmS_IEpit-5ZVW8lXFGx4m5Yk=w408-h271"];
    self.candidates = [NSMutableArray arrayWithObjects:item0, item1, item2, nil];
    
    //search
    self.searchItem = [[PCSearchItem alloc]init];
    self.searchItem.targetPlace = @"台北";
    self.searchItem.location = [[CLLocation alloc]initWithLatitude:25.049015 longitude:121.519618];
    self.searchItem.numberOfPeople = @1;
    self.searchItem.checkInDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*7];
    self.searchItem.checkInDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*14];
    
    
    //hotel
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data
-(void)addFavoriteItemForIndex:(NSInteger)index{
    if (self.favoriteList == nil) {
        self.favoriteList = [NSMutableArray new];
    }
    PCMapSceneItem *item = [self.candidates objectAtIndex:index];
    if (item) {
        [self.favoriteList addObject:item];
        NSLog(@"add scene: %@ to favor", item.name);
    }
}

-(BOOL)isLastCandidate:(NSInteger)index{
    if ((index + 1) == self.candidates.count) {
        return YES;
    }
    return NO;
}

-(void)processFavorResult{
    if (self.favoriteList.count > 0) {
        //post for hotel
        
        //show map view
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
        MapViewController *mapVC = [storyBoard instantiateInitialViewController];
        mapVC.hotelMapItems = self.relatedHotelList;
        mapVC.sceneMapItems = self.favoriteList;
        mapVC.userSearchItem = self.searchItem;
        
        [self.navigationController pushViewController:mapVC animated:YES];
    }else{
        //show retry view
        [self showRetryButton:YES];
    }
}

-(void)updateCardsFromServer{
    //post
    
}

#pragma mark - button
- (IBAction)touchFavorButton:(UIButton *)sender {
    [self.swipeableView swipeTopViewToRight];
}

- (IBAction)touchDeleteButton:(UIButton *)sender {
    [self.swipeableView swipeTopViewToLeft];
}

- (IBAction)touchRetryButton:(UIButton *)sender {
    //TODO:retry
    [self loadTestData];
    [self loadSwipeView];
    [self showRetryButton:NO];
}
#pragma mark - ZLSwipeableViewDataSource
-(UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView{
    if (self.candidates.count == 0 || self.currentIndex + 1 > self.candidates.count) {
        return nil;
    }
    
    UIView *parentView = [[UIView alloc] initWithFrame:swipeableView.bounds];
    PCMapSceneItem *item = [self.candidates objectAtIndex:self.currentIndex];
    parentView.tag = self.currentIndex;
    self.currentIndex++;
    
    CardView *cardView = [CardView cardViewWithName:item.name imageURL:item.thumbnailImageURL];
    [parentView addSubview:cardView];
    
    //constraint
    NSDictionary *metrics =
    @{ @"height" : @(parentView.bounds.size.height),
       @"width" : @(parentView.bounds.size.width) };
    NSDictionary *views = NSDictionaryOfVariableBindings(cardView);
    [parentView addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:@"H:|[cardView(width)]"
                                options:0
                                metrics:metrics
                                views:views]];
    [parentView addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:|[cardView(height)]"
                                options:0
                                metrics:metrics
                                views:views]];
    return parentView;
}



#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    NSLog(@"did swipe in direction: %zd", direction);
    if (direction == ZLSwipeableViewDirectionLeft) {
        //unlike
    }else if (direction == ZLSwipeableViewDirectionRight){
        //add to favor
        [self addFavoriteItemForIndex:view.tag];
    }
    
    if ([self isLastCandidate:view.tag]) {
        //process
        [self processFavorResult];
    }
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
