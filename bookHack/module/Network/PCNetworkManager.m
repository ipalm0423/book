//
//  PCNetworkManager.m
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/12.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "PCNetworkManager.h"
@import GoogleMaps;
@import GooglePlaces;

static NSString *const GoogleKey = @"AIzaSyBZ3urs5fuTVlzLaWxNoqU0a_jpCacxlBk";

#pragma mark - address


#pragma mark - Singelton
static PCNetworkManager *shareInstance;
static dispatch_once_t context;
@implementation PCNetworkManager{
    AFHTTPSessionManager *manager;
    GMSPlacesClient *_placeClient;
}

-(instancetype)init{
    if (self = [super init]) {
        manager = [AFHTTPSessionManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        [manager.securityPolicy setValidatesDomainName:NO
         ];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [GMSServices provideAPIKey:GoogleKey];
        _placeClient = [[GMSPlacesClient alloc] init];
        [GMSPlacesClient provideAPIKey:GoogleKey];
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

-(void)getSearchResultByKeyword:(NSString *)keyword completionBlock:(void (^)(NSArray *))completion{

    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc]init];
    filter.type = kGMSPlacesAutocompleteTypeFilterCity;
    
    [[GMSPlacesClient sharedClient] autocompleteQuery:[keyword stringByReplacingOccurrencesOfString:@" " withString:@"+"] bounds:nil filter:filter callback:^(NSArray<GMSAutocompletePrediction *> * _Nullable results, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Autocomplete error %@", [error localizedDescription]);
            return;
        }
        if (completion) {
            completion(results);
        }
    }];
}
@end
