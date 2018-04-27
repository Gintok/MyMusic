//
//  LrcTool.m
//  Music
//
//  Created by 户其修 on 2018/3/25.
//  Copyright © 2018年 户其修. All rights reserved.
//

#import "LrcTool.h"
#import "LrcLine.h"

@implementation LrcTool
#pragma mark - ********************* 根据歌词文件的名字返回歌词模型
+(NSArray *)lrcToolWithLrcName:(NSString *)lrcName {
    // 获取歌词文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:lrcName ofType:nil];
    // 获取歌词文件中的每行歌词
    NSString *lrcString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // 转化为歌词数组
    NSArray *lrcArray = [lrcString componentsSeparatedByString:@"\n"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *lrcLineString in lrcArray) {
        // 首先过滤不需要的字符串
        if ([lrcLineString hasPrefix:@"[ti"] ||  [lrcLineString hasPrefix:@"[ar"] || [lrcLineString hasPrefix:@"[al"] || ![lrcLineString hasPrefix:@"["]) {
            continue;
        }
        // 将歌词转化为模型
        LrcLine *lrcLine = [LrcLine lrcLineString:lrcLineString];
        [tempArray addObject: lrcLine];
    }
    return tempArray;
}
@end
