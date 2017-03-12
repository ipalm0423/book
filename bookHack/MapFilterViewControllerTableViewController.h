//
//  MapFilterViewControllerTableViewController.h
//  bookHack
//
//  Created by 蘇柄臣 on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MARKRangeSlider/MARKRangeSlider.h>
#import "PCSearchItem.h"

@interface PCAttributeAdjustmentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet MARKRangeSlider *rangeSlider;
@end

@interface MapFilterViewControllerTableViewController : UITableViewController
@property (weak, nonatomic) PCSearchItem *searchItem;
@end
