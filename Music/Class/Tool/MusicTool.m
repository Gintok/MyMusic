//
//  MusicTool.m
//  Music
//
//  Created by 户其修 on 2018/3/25.
//  Copyright © 2018年 户其修. All rights reserved.
//

#import "MusicTool.h"
#import "MJExtension.h"
#import "Music.h"

@implementation MusicTool

static NSMutableArray* _musics;
static Music* _playingMusic;

+(void)initialize {
    if (_musics == nil) {
        _musics = [Music mj_objectArrayWithFilename:@"Musics.plist"];
        
    }
    if (_playingMusic == nil) {
        _playingMusic = _musics[arc4random_uniform(6)];
    }
    
}

+(NSMutableArray *)getAllMusics {
    return _musics;
}

+(id)playingMusic {
    return _playingMusic;
}

+(void)setPlayingMusic:(Music *)playingMusic {
    _playingMusic = playingMusic;
}

+(Music *)lastSong {
    //    获取当前正在播放音乐的下标值
    NSInteger currentSongIndex = [_musics indexOfObject:_playingMusic];
    //    算出上一首音乐的下标值
    NSInteger lastSongIndex = --currentSongIndex;
    Music *lastSong = nil;
    if (lastSongIndex < 0) {
        lastSongIndex = _musics.count - 1;
    }
    lastSong = _musics[lastSongIndex];
    return lastSong;
}

+(Music *)nextSong {
    //    获取当前正在播放音乐的下标值
    NSInteger currentSongIndex = [_musics indexOfObject:_playingMusic];
    //    算出下一首音乐的下标值
    NSInteger nextSongIndex = ++currentSongIndex;
    Music *nextSong = nil;
    if (nextSongIndex >= _musics.count) {
        nextSongIndex = 0;
    }
    nextSong = _musics[nextSongIndex];
    return nextSong;
    
}
@end







