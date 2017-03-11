//
//  PCMapHotelItem.h
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCMapBaseItem.h"

@interface PCMapHotelItem : PCMapBaseItem
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSNumber *star;
@property (strong, nonatomic) NSNumber *userRating;
@property (strong, nonatomic) NSNumber *minPrice;
@property (strong, nonatomic) NSNumber *maxPrice;
@property (strong, nonatomic) NSNumber *numberReviews;
@end
