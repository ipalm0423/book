//
//  PCNetworkManager.m
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/12.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "PCNetworkManager.h"

@import GooglePlaces;

static NSString *const GoogleKey = @"AIzaSyBZ3urs5fuTVlzLaWxNoqU0a_jpCacxlBk";
static NSString *const ServerAPIScene = @"http://172.20.10.8:5566/attractions?place_id=ChIJyWEHuEmuEmsRm9hTkapTCrk";

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

-(void)getSearchResultByKeyword:(NSString*)keyword completionBlock:(void(^)(NSArray *results))completion{

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



#pragma mark - scene
-(void)getScenesFromPlaceID:(NSString*)ID completionBlock:(void (^)(NSArray *results))completion{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *url = [NSString stringWithFormat:@"%@?place_id=%@", ServerAPIScene, ID];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setURL:[NSURL URLWithString:ServerAPIScene]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:5];
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error:%@", error);
            return ;
        }else{
            NSLog(@"success");
            NSError* parseError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
            NSArray *result = [self parseSceneObjectWithJSON:json];
            completion(result);
        }
        
    }];
    
    [dataTask resume];
    
    
}

-(NSArray*)parseSceneObjectWithJSON:(NSDictionary*)dic{
    NSMutableArray *array = [NSMutableArray new];
    NSArray *results = dic[@"Results"];
    for (NSDictionary *sceneDic in results) {
        PCMapSceneItem *newScene = [PCMapSceneItem initWithDictionary:sceneDic];
        [array addObject:newScene];
    }
    return array;
}
@end
