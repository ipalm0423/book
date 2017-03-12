//
//  PCMapSceneItem.h
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCMapBaseItem.h"

@interface PCMapSceneItem : PCMapBaseItem
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSString *photoReference;
@property (strong, nonatomic) NSString *imageURL;
+(PCMapSceneItem*)initWithDictionary:(NSDictionary*)dic;
@end
