//
//  LrcLabel.m
//  Music
//
//  Created by 户其修 on 2018/3/26.
//  Copyright © 2018年 户其修. All rights reserved.
//

#import "LrcLabel.h"

@implementation LrcLabel

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGRect fillRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
    [[UIColor greenColor] set];
    //    UIRectFill(fillRect);
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}


@end
