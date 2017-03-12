//
//  SwipeViewController.h
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bookHack-Swift.h"
#import "ZLSwipeableView.h"

@interface SwipeViewController : UIViewController<ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

@property (strong, nonatomic) NSArray *candidates;
@property (strong, nonatomic) PCSearchItem *searchItem;

@end
