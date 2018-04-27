//
//  NSString+TimeExtension.m
//  Music
//
//  Created by 户其修 on 2018/3/25.
//  Copyright © 2018年 户其修. All rights reserved.
//

#import "NSString+TimeExtension.h"

@implementation NSString (TimeExtension)

#pragma mark - ********************* 将播放器中取得的时间转换为 00：00类型字符串
+(NSString *)stringWithTime:(NSTimeInterval)time {
    NSInteger min = time / 60;
    NSInteger sec = (int)round(time) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", min, sec];
}
@end
