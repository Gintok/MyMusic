//
//  ViewController.m
//  Music
//
//  Created by 户其修 on 2018/3/24.
//  Copyright © 2018年 户其修. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "MusicTool.h"
#import "Music.h"
#import "AudioTools.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+TimeExtension.h"
#import "CALayer+PauseAimate.h"
#import "LrcView.h"
#import "LrcLabel.h"

@interface ViewController () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;/** 滑块控件*/ 
@property (weak, nonatomic) IBOutlet UIImageView *albumView;/** 歌手背景图片*/
@property (weak, nonatomic) IBOutlet UIImageView *iconView;/** 歌手头像*/
@property (weak, nonatomic) IBOutlet UILabel *songName;/** 歌曲名称*/
@property (weak, nonatomic) IBOutlet UILabel *songer;/** 歌手名字*/
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;/** 当前播放时间*/
@property (weak, nonatomic) IBOutlet UILabel *totleTimeLabel;/** 歌曲总时间*/
@property (weak, nonatomic) IBOutlet LrcLabel *lrcLabel;/** 主界面的一行歌词*/
- (IBAction)start;
- (IBAction)end;
- (IBAction)progressValueChange;
- (IBAction)sliderClick:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIButton *playOrPause;
- (IBAction)playOrPauseAction;
- (IBAction)nextSong;
- (IBAction)lastSong;
/** 歌词页--scrollView*/
@property (weak, nonatomic) IBOutlet LrcView *lrcView;
/** 当前正在播放歌曲的播放器*/
@property(nonatomic, strong) AVAudioPlayer *currentPlayer;
/** 记录歌曲已播放时间的计时器，一秒刷新1次请求*/
@property(nonatomic, strong) NSTimer *progressTimer;
/** 用于跟踪歌词位置的计时器，一秒刷新60次请求*/
@property(nonatomic, strong) CADisplayLink *lrcTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //    添加毛玻璃效果
    [self setBlur];
    //    改变slider滑块图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    //    添加圆角效果
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = [UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:1.0].CGColor;
    self.iconView.layer.borderWidth = 8;
    //    开始播放音乐
    [self startPlayingMusic];
    //    设置歌词view
    self.lrcView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    self.lrcView.lrcLabel = self.lrcLabel;
}

#pragma mark - ********************* 开始播放音乐
-(void)startPlayingMusic {
    self.lrcLabel.text = nil;
    //    拿到当前正在播放歌曲的模型信息
    Music *playingMusic = [MusicTool playingMusic];
    //    根据模型信息设置首页显示内容
    self.albumView.image = [UIImage imageNamed:playingMusic.icon];
    self.iconView.image = [UIImage imageNamed:playingMusic.icon];
    self.songName.text = playingMusic.name;
    self.songer.text = playingMusic.singer;
    //    根据歌曲名字拿到对应的播放器
    self.currentPlayer = [AudioTools startSongsWithSongname:playingMusic.filename];
    self.currentTimeLabel.text = [NSString stringWithTime:_currentPlayer.currentTime];
    self.totleTimeLabel.text = [NSString stringWithTime:_currentPlayer.duration];
    //    设置播放或暂停按钮
    self.playOrPause.selected = self.currentPlayer.isPlaying;
    //    设置歌词
    self.lrcView.lrcName = playingMusic.lrcname;
    self.lrcView.duration = self.currentPlayer.duration;
    //    开启定时器,先将之前的定时器移除
    [self removeProgressTimer];
    [self addProgressTimer];
    [self removeLrcTimer];
    [self addLrcTimer];
    //    添加iconView的动画
    [self addIconViewAnimate];
}

#pragma mark - ********************* 对已播放时间定时器进行处理
-(void)addProgressTimer {
    [self updateProgressInfo];
    self.progressTimer =   [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}
-(void)removeProgressTimer {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}
-(void)updateProgressInfo{
    //更新播放时间
    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    //更新slider控件的移动
    self.progressSlider.value = self.currentPlayer.currentTime / self.currentPlayer.duration;
}

#pragma mark - ********************* 对歌词定时器的处理
-(void)addLrcTimer {
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcInfo)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
-(void)removeLrcTimer{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}
- (void) updateLrcInfo {
    self.lrcView.currentTime = self.currentPlayer.currentTime;
}

#pragma mark - ********************* 添加iconView的转动动画效果
-(void)addIconViewAnimate {
    CABasicAnimation *rotateAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimate.fromValue = @(0);
    rotateAnimate.toValue = @(M_PI * 2);
    rotateAnimate.repeatCount = NSIntegerMax;
    rotateAnimate.duration = 40;
    [self.iconView.layer addAnimation:rotateAnimate forKey:nil];
}

#pragma mark - ********************* 设置毛玻璃效果
-(void) setBlur{
    /** 初始化toolbar*/
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [self.albumView addSubview:toolbar];
    toolbar.barStyle = UIBarStyleBlack;
    /** 添加约束*/
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.albumView);
    }];
}
#pragma mark - ********************* slider控件监控
- (IBAction)start {
    //    移除定时器
    [self removeProgressTimer];
}
- (IBAction)end {
    //    更新播放时间
    self.currentPlayer.currentTime = self.progressSlider.value * self.currentPlayer.duration;
    //    添加新的定时器
    [self addProgressTimer];
}
- (IBAction)progressValueChange {
    //    更新当前播放时间
    self.currentTimeLabel.text = [NSString stringWithTime:self.progressSlider.value * self.currentPlayer.duration];
}
- (IBAction)sliderClick:(UITapGestureRecognizer *)sender {
    //    获取滑动条点击范围
    CGPoint point = [sender locationInView:sender.view];
    //    获取点击位置的比例
    CGFloat ratio = point.x / self.progressSlider.bounds.size.width;
    //    更新player中的播放时间
    self.currentPlayer.currentTime = ratio * self.currentPlayer.duration;
    //    更新左侧显示正在播放时间和滑块点击之后所在的位置
    [self updateProgressInfo];
}

#pragma mark - ********************* 首页底部按钮点击事件处理
- (IBAction)playOrPauseAction {
    self.playOrPause.selected = !self.playOrPause.selected;
    if (self.currentPlayer.isPlaying) {
        //        停止iconView动画展示
        [self.iconView.layer pauseAnimate];
        //        暂停播放器
        [self.currentPlayer pause];
        //        移除定时器
        [self removeProgressTimer];
    } else {
        //        开始iconView动画展示
        [self.iconView.layer resumeAnimate];
        //        开始播放
        [self.currentPlayer play];
        //        添加定时器
        [self addProgressTimer];
    }
}
- (IBAction)nextSong {
    //    获取当前正在播放的歌曲并停止
    Music *currentSong =  [MusicTool playingMusic];
    [AudioTools stopSongsWithSongname:currentSong.filename];
    //    获取下一首歌曲的信息
    Music *nextSong = [MusicTool nextSong];
    //    设置下一首歌曲为默认播放歌曲
    [MusicTool setPlayingMusic:nextSong];
    //    开始播放
    [self startPlayingMusic];
}
- (IBAction)lastSong {
    //    获取当前正在播放的歌曲并停止
    Music *currentSong =  [MusicTool playingMusic];
    [AudioTools stopSongsWithSongname:currentSong.filename];
    //    获取上一首歌曲的信息
    Music *lastSong = [MusicTool lastSong];
    //    设置下一首歌曲为默认播放歌曲
    [MusicTool setPlayingMusic:lastSong];
    //    开始播放
    [self startPlayingMusic];
}

#pragma mark - ********************* 改变状态栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - ********************* scrollView的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    获取滑动偏移量
    CGPoint point = scrollView.contentOffset;
    //    获取滑动比例
    CGFloat alpha = 1 - point.x / self.view.bounds.size.width;
    //    设置alpha
    self.iconView.alpha = alpha;
    self.lrcLabel.alpha = alpha;
}

@end







