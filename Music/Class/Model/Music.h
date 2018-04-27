//
//  Music.h
//  Music
//
//  Created by 户其修 on 2018/3/25.
//  Copyright © 2018年 户其修. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject
/** 歌曲名*/
@property(nonatomic, copy) NSString *name;
/** 歌曲文件名称*/
@property(nonatomic, copy) NSString *filename;
/** 歌词名*/
@property(nonatomic, copy) NSString *lrcname;
/** 歌手*/
@property(nonatomic, copy) NSString *singer;
/** 歌手头像*/
@property(nonatomic, copy) NSString *singerIcon;
/** 歌曲背部模糊图片*/
@property(nonatomic, copy) NSString *icon;

@end
