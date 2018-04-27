//
//  AudioTools.h
//  AVFoundation
//
//  Created by 户其修 on 2018/3/24.
//  Copyright © 2018年 户其修. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/**
 播放音视频的工具类
 */
@interface AudioTools : NSObject

/** 播放音频*/
+(void)playSoundWithSoundname: (NSString *)soundname;
/** 播放视频*/
+(AVAudioPlayer *)startSongsWithSongname: (NSString *)songname;
+(void)pauseSongsWithSongname: (NSString *)songname;
+(void)stopSongsWithSongname: (NSString *)songname;

@end
