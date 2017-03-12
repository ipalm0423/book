//
//  PCNetworkManager.h
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/12.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GooglePlaces;


@interface PCNetworkManager : NSObject<NSURLSessionDelegate>

+(PCNetworkManager*_Nullable)shareInstance;


-(void)getSearchResultByKeyword:(NSString*)keyword completionBlock:(void(^)(NSArray *results))completion;
-(void)getScenesFromPlaceID:(NSString*)ID completionBlock:(void (^)(NSArray *results))completion;
@end
