//
//  PCMapHotelItem.m
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "PCMapHotelItem.h"

@implementation PCMapHotelItem
- (PCMapBaseItem *)initWithLocation: (CLLocation *)location name: (NSString *)name {
    if (self = [super initWithLocation:location name:name]) {
        self.ID = @"10179";
        self.minPrice = @(0);
        self.maxPrice = @(0);
        self.star = @(3);
        self.userRating = @(5);
        self.numberReviews = @(0);
    }
    return self;
}
@end
