//
//  PCSearchItem.h
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCSearchItem : NSObject
@property (strong, nonatomic) NSString *targetPlace;
@property (strong, nonatomic) NSNumber *numberOfPeople;
@property (strong, nonatomic) NSDate *checkInDate;
@property (strong, nonatomic) NSDate *checkOutDate;
@end
