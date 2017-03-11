//
//  PCMapBaseItem.h
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PCMapBaseItem : NSObject
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSURL *thumbnailImageURL;
@property (strong, nonatomic) NSMutableArray *detailImageURLs;
@end
