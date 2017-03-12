//
//  PCSearchItem.h
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PCSearchItem : NSObject
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *targetPlace;
@property (strong, nonatomic) NSNumber *numberOfPeople;
@property (strong, nonatomic) NSDate *checkInDate;
@property (strong, nonatomic) NSDate *checkOutDate;
@property (strong, nonatomic) NSNumber *minimumPrice;
@property (strong, nonatomic) NSNumber *maximumPrice;
@property (strong, nonatomic) NSNumber *minimumUserScore;
@property (strong, nonatomic) NSNumber *maximumUserScore;
@property (strong, nonatomic) NSNumber *minimumReviews;
@property (strong, nonatomic) NSNumber *minimumStar;
@property (strong, nonatomic) NSNumber *maximumStar;
@property (strong, nonatomic) NSNumber *minimumDistance;
@property (strong, nonatomic) NSNumber *maximumDistance;
@end
