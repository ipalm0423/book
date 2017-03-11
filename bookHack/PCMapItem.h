//
//  PCMapItem.h
//  bookHack
//
//  Created by 蘇柄臣 on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#ifndef PCMapItem_h
#define PCMapItem_h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface PCMapBaseItem : NSObject
@property CLLocation *location;
@end

@interface PCMapSceneItem : PCMapBaseItem
@property UIImage *previewImage;
@end

@interface PCMapHotelItem : PCMapBaseItem
@property NSString *hotelId;
@property NSNumber *numberOfPeople;
@property NSDate *checkInDate;
@property NSDate *checkOutDate;
@end

#endif /* PCMapItem_h */
