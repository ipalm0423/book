//
//  PCMapBaseItem.m
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "PCMapBaseItem.h"

@implementation PCMapBaseItem

- (NSString *)title {
    return _name;
}

- (PCMapBaseItem *)initWithLocation: (CLLocation *)location name: (NSString *)name {
    if (self = [super init]) {
        _location = location;
        _name = name;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return _location.coordinate;
}

@end
