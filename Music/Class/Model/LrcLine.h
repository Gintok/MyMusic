//
//  LrcLine.h
//  Music
//
//  Created by 户其修 on 2018/3/25.
//  Copyright © 2018年 户其修. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcLine : NSObject
/** 每行的歌词内容*/
@property(nonatomic, copy) NSString *text;
/** 每行歌词对应的时间*/
@property(nonatomic, assign) NSTimeInterval time;

-(instancetype) initWithLrcLineString: (NSString *)lrcString;
+(instancetype)lrcLineString:(NSString *)lrcString;
@end
