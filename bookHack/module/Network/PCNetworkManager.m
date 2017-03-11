//
//  PCNetworkManager.m
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/12.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "PCNetworkManager.h"
static NSString *const GoogleKey = @"AIzaSyAUlF-CDK8FqvWwwKJfFEkLw-LVDxFWlZ0";
static PCNetworkManager *shareInstance;
static dispatch_once_t context;
@implementation PCNetworkManager

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

+(PCNetworkManager*)shareInstance{
    
    dispatch_once(&context, ^{
        if (shareInstance == nil) {
            shareInstance = [[self alloc]init];
        }
    });
    return shareInstance;
}

-(void)getSearchResultByKeyword:(NSString*)keyword{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"https://maps.googleapis.com/maps/api/place/autocomplete/json" parameters:@{@"input":keyword, @"key":GoogleKey} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"get search result success:%@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get search result error:%@", error.localizedDescription);
    }];
    
}
@end
