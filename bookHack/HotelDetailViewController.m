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

@end

@implementation HotelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelHotelName.text = _hotelItem.name;
    self.labelPrice.text = [NSString stringWithFormat:@"€%@ ~ €%@", self.hotelItem.minPrice, self.hotelItem.maxPrice];
    NSString *urlString = [NSString stringWithFormat:@"https://hacker234:8hqNW6HtfU@distribution-xml.booking.com/json/bookings.getBlockAvailability?arrival_date=2017-06-10&departure_date=2017-06-11&hotel_ids=%@", self.hotelItem.ID];
    NSURL *apiUrl = [[NSURL alloc] initWithString:urlString];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:apiUrl];
        NSArray *result = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *prices = [NSMutableArray new];
            NSNumber *minPrice = @(0);
            NSNumber *maxPrice = @(0);
            for (NSDictionary *dict in result) {
                NSNumber *n = @([dict[@"block"][0][@"min_price"][@"price"] floatValue]);
                [prices addObject:n];
                if (n.floatValue > maxPrice.floatValue) {
                    maxPrice = n;
                }
                if (n.floatValue < minPrice.floatValue || minPrice.integerValue == 0) {
                    minPrice = n;
                }
            }
            
            self.hotelItem.minPrice = minPrice;
            self.hotelItem.maxPrice = maxPrice;
            self.labelPrice.text = [NSString stringWithFormat:@"€%@ ~ €%@", self.hotelItem.minPrice, self.hotelItem.maxPrice];
        });
    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
