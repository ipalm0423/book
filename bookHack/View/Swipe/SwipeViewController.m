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

@interface SwipeViewController ()

@property (strong, nonatomic) IBOutlet ZLSwipeableView *swipeableView;
@property (strong, nonatomic) IBOutlet UIButton *buttonFavor;
@property (strong, nonatomic) IBOutlet UIButton *buttonDelete;
@property (strong, nonatomic) IBOutlet UIButton *buttonRetry;
@property (strong, nonatomic) IBOutlet UILabel *labelRetry;



@property (nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSMutableArray *favoriteList;
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
    [self switchToRetryButton:NO];
}

-(void)switchToRetryButton:(BOOL)isRetry{
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
    PCMapSceneItem *item0 = [[PCMapSceneItem alloc]init];
    item0.name = @"0";
    item0.thumbnailImageURL = [NSURL URLWithString:@"https://i.imgur.com/50JrTK9.jpg"];
    PCMapSceneItem *item1 = [[PCMapSceneItem alloc]init];
    item1.name = @"1";
    item1.thumbnailImageURL = [NSURL URLWithString:@"http://i.imgur.com/mt06zny.jpg"];
    PCMapSceneItem *item2 = [[PCMapSceneItem alloc]init];
    item2.name = @"2";
    item2.thumbnailImageURL = [NSURL URLWithString:@"http://i.imgur.com/CjpjZfK.jpg"];
    self.candidates = [NSMutableArray arrayWithObjects:item0, item1, item2, nil];
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
        
    }else{
        //show retry view
        [self switchToRetryButton:YES];
        
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
