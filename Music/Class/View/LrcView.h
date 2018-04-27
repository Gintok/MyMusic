//
//  LrcView.h
//  Music
//
//  Created by 户其修 on 2018/3/25.
//  Copyright © 2018年 户其修. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LrcLabel;
@interface LrcView : UIScrollView

/** 歌词文件的名字*/
@property(nonatomic, copy) NSString *lrcName;
/** 当前播放器播放的时间*/
@property(nonatomic, assign) NSTimeInterval currentTime;
/** 主界面歌词label*/
@property(nonatomic, weak) LrcLabel *lrcLabel;
/** 当前播放器总时间时间 */
@property (nonatomic, assign) NSTimeInterval duration;

@end
