//
//  PCSearchItem.m
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "PCSearchItem.h"

@implementation PCSearchItem
- (id)init {
    if (self = [super init]) {
        self.location = [[CLLocation alloc] initWithLatitude:-33.880837 longitude:151.205606];
        self.targetPlace = @"Default place name";
        self.numberOfPeople = @(1);
        self.checkInDate = [NSDate new]; // today
        self.checkOutDate = [NSDate dateWithTimeIntervalSinceNow:86400]; // one day after since now
        self.minimumPrice = @(1000);
        self.maximumPrice = @(5000);
        self.minimumUserScore = @(0);
        self.maximumUserScore = @(10);
        self.minimumReviews = @(0);
        self.minimumStar = @(0);
        self.maximumStar = @(5);
        self.minimumDistance = @(0);
        self.maximumDistance = @(5);
    }
    return self;
}
@end
