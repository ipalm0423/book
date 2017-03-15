//
//  SceneDetailViewController.m
//  bookHack
//
//  Created by 蘇柄臣 on 2017/3/12.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "SceneDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <HCSStarRatingView/HCSStarRatingView.h>

@interface SceneDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelSceneName;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRatingView;

@end

@implementation SceneDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelSceneName.text = self.sceneItem.name;
    [self.starRatingView setValue:self.sceneItem.rating.floatValue];
    [self.imageView sd_setImageWithURL:_sceneItem.thumbnailImageURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
