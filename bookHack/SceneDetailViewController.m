//
//  SceneDetailViewController.m
//  bookHack
//
//  Created by 蘇柄臣 on 2017/3/12.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "SceneDetailViewController.h"

@interface SceneDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelSceneName;
@property (weak, nonatomic) IBOutlet UILabel *labelSceneRating;

@end

@implementation SceneDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelSceneName.text = self.sceneItem.name;
    self.labelSceneRating.text = [NSString stringWithFormat:@"%@ Star", self.sceneItem.rating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
