//
//  PCMapHotelItem.m
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "PCMapHotelItem.h"
#include <stdlib.h>
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

+(PCMapHotelItem*)initWithDictionary:(NSDictionary*)dic {
    CLLocation *locate = [[CLLocation alloc]initWithLatitude:[dic[@"location"][@"latitude"]floatValue] longitude:[dic[@"location"][@"longitude"]floatValue]];
    
    PCMapHotelItem *item = [[self alloc]initWithLocation:locate name:@"name"];
    item.ID = dic[@"hotel_id"];
    item.maxPrice = [NSNumber numberWithInt:[dic[@"price"]intValue]];
    item.minPrice = [NSNumber numberWithInt:[dic[@"price"]intValue]];
    //TODO:demo
    int demoInt = arc4random_uniform(5);
    item.star = [NSNumber numberWithInt:[dic[@"stars"] intValue]];
    item.numberReviews = [NSNumber numberWithInt:demoInt];
    item.userRating = [NSNumber numberWithFloat:[dic[@"review_score"] floatValue]];
    
    
    return item;
}
@end
