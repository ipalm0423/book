//
//  CardView.m
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "CardView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setup {
    
}

+(CardView*)cardViewWithName:(NSString*)name imageURL:(NSString*)url{
    CardView *contentView =
    [[NSBundle mainBundle] loadNibNamed:@"CardView" owner:self options:nil][0];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor grayColor];
    
    // Corner Radius
    contentView.layer.cornerRadius = 10.0;
    contentView.clipsToBounds = YES;
    
    //setting
    contentView.labelName.text = name;
    [contentView.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    return contentView;
}
@end
