//
//  MusicTool.h
//  Music
//
//  Created by 户其修 on 2018/3/25.
//  Copyright © 2018年 户其修. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Music;

/**
 音乐相关的工具类
 */
@interface MusicTool : NSObject
/** 返回所有歌曲信息*/
+(NSMutableArray *)getAllMusics;
/** 返回当前正在播放音乐*/
+(Music *)playingMusic;
/** 设置当前播放音乐*/
+(void)setPlayingMusic:(Music *) playingMusic;
/** 获取上一首音乐的模型*/
+(Music *)lastSong;
/** 获取下一首音乐的模型*/
+(Music *)nextSong;
@end
