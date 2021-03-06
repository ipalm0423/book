//
//  HotelDetailViewController.m
//  bookHack
//
//  Created by 蘇柄臣 on 2017/3/12.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "HotelDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <HCSStarRatingView/HCSStarRatingView.h>

@interface HotelDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelHotelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelUserRating;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRatingView;

@end

@implementation HotelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelHotelName.text = _hotelItem.name;
    self.labelPrice.text = [NSString stringWithFormat:@"€%@ ~ €%@", self.hotelItem.minPrice, self.hotelItem.maxPrice];
    [self.starRatingView setValue:_hotelItem.star.floatValue];
    self.labelUserRating.text = [NSString stringWithFormat:@"%.1f / 10", _hotelItem.userRating.floatValue];
    
    //
    NSString *urlString = [NSString stringWithFormat:@"https://hacker234:8hqNW6HtfU@distribution-xml.booking.com/json/bookings.getHotelDescriptionPhotos?hotel_ids=%@", _hotelItem.ID];
    NSURL *apiUrl = [[NSURL alloc] initWithString:urlString];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:apiUrl];
        NSArray *result = [NSJSONSerialization JSONObjectWithData:data
                                                          options:NSJSONReadingAllowFragments
                                                            error:nil];
        for (NSDictionary *dict in result) {
            NSString *imageUrl = dict[@"url_max300"];
            if (imageUrl != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
                });
                return;
            }
        }
        return;
    });
    
    [self.imageView sd_setImageWithURL:_hotelItem.thumbnailImageURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionBookIt:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://www.booking.com/hotel/us/planet-hollywood.html?label=gen173nr-1DCAEoggJCAlhYSDNiBW5vcmVmaOcBiAEBmAExuAEHyAEN2AED6AEB-AECqAID;sid=fb42cf096c2c4afc37649603a566e9f0;dest_id=20079110;dest_type=city;dist=0;group_adults=2;hpos=1;room1=A%2CA;sb_price_type=total;srfid=349d74ccdf1be693e61b77887de7075ee5b684d9X1;type=total;ucfs=1&#hotelTmpl"];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

@end
