//
//  MapFilterViewControllerTableViewController.h
//  bookHack
//
//  Created by 蘇柄臣 on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCAttributeAdjustmentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@end

@interface MapFilterViewControllerTableViewController : UITableViewController

@end
