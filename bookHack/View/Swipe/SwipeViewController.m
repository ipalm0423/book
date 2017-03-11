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
@property (strong, nonatomic) NSMutableArray *imageURLs;
@end

@implementation SwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSwipeView];
}

-(void)setupSwipeView{
    //self.swipeableView.frame = self.view.bounds;
    self.swipeableView.dataSource = self;
    self.swipeableView.delegate = self;
    [self.swipeableView loadViewsIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ZLSwipeableViewDataSource
-(UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView{
    
    UIView *parentView = [[UIView alloc] initWithFrame:swipeableView.bounds];
    CardView *cardView = [CardView cardViewWithName:@"Hello World" imageURL:@"https://i.imgur.com/50JrTK9.jpg"];
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
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view {
    NSLog(@"did cancel swipe");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
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
