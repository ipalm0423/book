//
//  PCMapItem.h
//  bookHack
//
//  Created by 蘇柄臣 on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PCSearchItem : NSObject
@property (strong, nonatomic) NSString *targetPlace;
@property (strong, nonatomic) NSNumber *numberOfPeople;
@property (strong, nonatomic) NSDate *checkInDate;
@property (strong, nonatomic) NSDate *checkOutDate;
@end

@interface PCMapBaseItem : NSObject
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSURL *thumbnailImageURL;
@property (strong, nonatomic) NSMutableArray *detailImageURLs;
@end

@interface PCMapSceneItem : PCMapBaseItem
@property (strong, nonatomic) NSString *category;
@end

@interface PCMapHotelItem : PCMapBaseItem
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSNumber *star;
@end



