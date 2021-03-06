//
//  MapViewController.h
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCSearchItem.h"

@interface MapViewController : UIViewController
@property (strong, nonatomic) NSArray *hotelMapItems;
@property (strong, nonatomic) NSArray *sceneMapItems;
@property (strong, nonatomic) PCSearchItem *userSearchItem;
@end
