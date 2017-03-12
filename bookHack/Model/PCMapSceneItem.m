//
//  PCMapSceneItem.m
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "PCMapSceneItem.h"

@implementation PCMapSceneItem
- (PCMapBaseItem *)initWithLocation: (CLLocation *)location name: (NSString *)name {
    if (self = [super initWithLocation:location name:name]) {
        self.rating = @(2);
    }
    return self;
}
@end
