//
//  AppDelegate.h
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/10.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

