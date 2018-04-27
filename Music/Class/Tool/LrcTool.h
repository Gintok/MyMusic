//
//  LrcTool.h
//  Music
//
//  Created by 户其修 on 2018/3/25.
//  Copyright © 2018年 户其修. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 处理歌词的工具类
 */
@interface LrcTool : NSObject
/** 根据歌词文件的名字返回歌词模型*/
+(NSArray *)lrcToolWithLrcName:(NSString *) lrcName;

@end
