//
//  NSString+TimeExtension.h
//  Music
//
//  Created by 户其修 on 2018/3/25.
//  Copyright © 2018年 户其修. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeExtension)
/** 将播放器中取得的时间转换为 00：00类型字符串*/ 
+(NSString *)stringWithTime:(NSTimeInterval)time;

@end
