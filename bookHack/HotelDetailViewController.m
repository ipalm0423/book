//
//  HotelDetailViewController.m
//  bookHack
//
//  Created by 蘇柄臣 on 2017/3/12.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "HotelDetailViewController.h"

@interface HotelDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelHotelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelStar;
@property (weak, nonatomic) IBOutlet UILabel *labelUserRating;

@end

@implementation HotelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelHotelName.text = _hotelItem.name;
    self.labelPrice.text = [NSString stringWithFormat:@"€%@ ~ €%@", self.hotelItem.minPrice, self.hotelItem.maxPrice];
    self.labelStar.text = [NSString stringWithFormat:@"%@ Star", _hotelItem.star];
    self.labelUserRating.text = [NSString stringWithFormat:@"%.1f / 10", _hotelItem.userRating.floatValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
