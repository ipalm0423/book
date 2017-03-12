//
//  PCMapSceneItem.m
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "PCMapSceneItem.h"
static NSString *const ImageKey = @"AIzaSyAUlF-CDK8FqvWwwKJfFEkLw-LVDxFWlZ0";
@implementation PCMapSceneItem


+(PCMapSceneItem*)initWithDictionary:(NSDictionary*)dic{
    NSString *name = dic[@"name"];
    NSString *place_id = dic[@"place_id"];
    NSDictionary *geometry = dic[@"geometry"];
    CLLocation *locate = [[CLLocation alloc]initWithLatitude:[geometry[@"location"][@"lat"]floatValue] longitude:[geometry[@"location"][@"lng"] floatValue]];
    PCMapSceneItem *item = [[PCMapSceneItem alloc] initWithLocation:locate name:name];
    item.ID = place_id;
    item.photoReference = dic[@"photos"][0][@"photo_reference"];
    return item;
}

-(NSString *)imageURL{
    if (_photoReference) {
        return [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=%@&key=%@", _photoReference, ImageKey];
    }
    return @"";
}
@end
