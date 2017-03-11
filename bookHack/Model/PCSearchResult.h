//
//  PCSearchResult.h
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/12.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCSearchResult : NSObject
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *ID;
@end
