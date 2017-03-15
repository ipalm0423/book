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

+(PCNetworkManager*_Nonnull)shareInstance;


-(void)getSearchResultByKeyword:(NSString* _Nonnull)keyword completionBlock:(void(^ _Nullable)(  NSArray *_Nullable results,  NSError * _Nullable error ))completion;
-(void)getScenesFromPlaceID:(NSString* _Nonnull)ID completionBlock:(void (^ _Nullable)(NSArray *_Nullable results, NSError *_Nullable error))completion;
-(void)getHotelResultFromScene:(NSArray* _Nonnull)scenes completionBlock:(void (^ _Nullable )(NSArray *_Nullable results, CLLocation *_Nullable center, NSError *_Nullable error))completion;
@end
