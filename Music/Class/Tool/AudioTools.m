//
//  AudioTools.m
//  AVFoundation
//
//  Created by 户其修 on 2018/3/24.
//  Copyright © 2018年 户其修. All rights reserved.
//

#import "AudioTools.h"
#import <AVFoundation/AVFoundation.h>

@implementation AudioTools

static NSMutableDictionary *_soundIDs;/** 存放音频ID的字典*/
static NSMutableDictionary *_songPlayers;/** 存放播放器的字典*/

/** 在类第一次加载之后对字典进行初始化*/
+(void)initialize {
    _soundIDs = [NSMutableDictionary dictionary];
    _songPlayers = [NSMutableDictionary dictionary];
}

+(AVAudioPlayer *)startSongsWithSongname:(NSString *)songname {
    AVAudioPlayer * player = nil;
    player = _songPlayers[songname];
    if (player == nil) {
        /** 生成对应音乐资源*/
        NSURL *url = [[NSBundle mainBundle] URLForResource:songname withExtension:nil];
        if (url == nil) return nil;
        /** 创建对应播放器*/
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        /** 保存到字典当中*/
        [_songPlayers setObject:player forKey:songname];
        /** 准备播放*/
        [player prepareToPlay];
    }
    [player play];
    return player;
}

+(void)pauseSongsWithSongname:(NSString *)songname {
    AVAudioPlayer * player = _songPlayers[songname];
    if (player) {
        [player pause];
    }
}

+(void)stopSongsWithSongname:(NSString *)songname {
    AVAudioPlayer * player = _songPlayers[songname];
    if (player) {
        [player stop];
        [_songPlayers removeObjectForKey:songname];
        player = nil;
    }
}

+(void)playSoundWithSoundname:(NSString *)soundname {
    
    //    1，先看看字典中是否存有想要的soundID
    SystemSoundID soundID = 0;
    soundID = [_soundIDs[soundname] unsignedIntValue];
    //   2，如果字典中不存在想要的soundID，则自己创建一个
    if (soundID == 0) {
        //2.1生成soundID
        CFURLRef url = (__bridge CFURLRef)([[NSBundle mainBundle] URLForResource:soundname withExtension:nil]);
        if (url == nil)  return;
        AudioServicesCreateSystemSoundID(url, &soundID);
        //2.2将soundID保存到字典中
        [_soundIDs setObject:@(soundID)  forKey:soundname];
    }
    //    3，播放音频
    AudioServicesPlaySystemSound(soundID);
}

@end
