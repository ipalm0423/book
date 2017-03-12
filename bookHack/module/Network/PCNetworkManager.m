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
static NSString *const ServerAPIScene = @"http://172.20.10.8:5566/attractions";
static NSString *const ServerAPIHotel = @"http://172.20.10.8:5566/attractions/hotels";

#pragma mark - address


#pragma mark - Singelton
static PCNetworkManager *shareInstance;
static dispatch_once_t context;
@implementation PCNetworkManager{
    AFHTTPSessionManager *manager;
    GMSPlacesClient *_placeClient;
    NSURLSession *defaultSession;
    
}

-(instancetype)init{
    if (self = [super init]) {
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
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

-(void)getHotelResultFromScene:(NSArray*)scenes completionBlock:(void (^)(NSArray *results, CLLocation *center))completion{
    if (scenes.count == 0) {
        NSLog(@"have no scene");
        return;
    }
    NSString *dateString = @"checkin=2017-06-08&checkout=2017-07-07";//TODO:demo only
    NSString *scenesString = @"place_ids=";
    BOOL isFirstItem = YES;
    for (PCMapSceneItem *scene in scenes) {
        if (isFirstItem) {
            isFirstItem = NO;
            scenesString = [NSString stringWithFormat:@"%@%@",scenesString, scene.ID];
        }else{
            scenesString = [NSString stringWithFormat:@"%@,%@",scenesString, scene.ID];
        }
    }
    //format:
    //http://172.20.10.8:5566/attractions/hotels\?checkin=2017-06-08\&checkout=2017-07-07\&place_ids=ChIJyWEHuEmuEmsRm9hTkapTCrk,ChIJLfySpTOuEmsRsc_JfJtljdc
    NSString *url = [NSString stringWithFormat:@"%@?%@&%@", ServerAPIHotel,dateString,scenesString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
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
            NSArray *results = [self parseHotelObjectWithJSON:json];
            CLLocation *center = [self parseHotelCenter:json];
            completion(results, center);
        }
        
    }];
    
    [dataTask resume];
    
}

#pragma mark - scene
-(void)getScenesFromPlaceID:(NSString*)ID completionBlock:(void (^)(NSArray *results))completion{
    
    NSString *url = [NSString stringWithFormat:@"%@?place_id=%@", ServerAPIScene, ID];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];

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

#pragma mark - parse
-(NSArray*)parseSceneObjectWithJSON:(NSDictionary*)dic{
    NSMutableArray *array = [NSMutableArray new];
    NSArray *results = dic[@"Results"];
    for (NSDictionary *sceneDic in results) {
        PCMapSceneItem *newScene = [PCMapSceneItem initWithDictionary:sceneDic];
        [array addObject:newScene];
    }
    return array;
}

-(NSArray*)parseHotelObjectWithJSON:(NSDictionary*)dic{
    NSMutableArray *array = [NSMutableArray new];
    NSArray *results = dic[@"hotels"];
    for (NSDictionary *hotelDic in results) {
        PCMapHotelItem *newScene = [PCMapHotelItem initWithDictionary:hotelDic];
        [array addObject:newScene];
    }
    return array;
}

-(CLLocation*)parseHotelCenter:(NSDictionary*)dic{
    CLLocation *center = [[CLLocation alloc]initWithLatitude:[dic[@"latitude"]floatValue] longitude:[dic[@"longitude"]floatValue]];
    return center;
}
@end
