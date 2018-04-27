//
//  LrcView.m
//  Music
//
//  Created by 户其修 on 2018/3/25.
//  Copyright © 2018年 户其修. All rights reserved.
//

#import "LrcView.h"
#import "Masonry.h"
#import "LrcTool.h"
#import "LrcLine.h"
#import "LrcLabel.h"
#import "XMGLrcCell.h"

@interface LrcView() <UITableViewDataSource>

/** 第二页歌词的tableview*/
@property(nonatomic, weak) UITableView *tableView;
/** 歌词数组*/
@property(nonatomic, strong) NSArray *list;
/** 记录歌词当前滚到哪行了*/
@property(nonatomic, assign) NSInteger currentIndex ;

@end

@implementation LrcView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupTableView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTableView];
    }
    return self;
}

#pragma mark - ********************* 初始化tableView
-(void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    [self addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
//    [self.tableView registerClass:[XMGLrcCell class] forCellReuseIdentifier:@"cell"];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    //    添加约束
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(self.mas_height);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left).offset(self.bounds.size.width);
        make.width.equalTo(self.mas_width);
    }];
    //    改变tableView的属性
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 40;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.bounds.size.height * 0.5, 0, self.tableView.bounds.size.height * 0.5, 0);
}

#pragma mark - ********************* UITableView数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMGLrcCell *cell = [XMGLrcCell lrcCellWithTableView:tableView];
    if (self.currentIndex == indexPath.row) {
        cell.lrcLabel.font = [UIFont systemFontOfSize:16];
    } else {
        cell.lrcLabel.font = [UIFont systemFontOfSize:14];
        cell.lrcLabel.progress = 0;
    }
    // 1.取出数据模型
    LrcLine *lrcLine = self.list[indexPath.row];
    // 2.设置数据
    cell.lrcLabel.text = lrcLine.text;
    return cell;
}


#pragma mark - ********************* 重写currentTime属性的set方法
-(void)setCurrentTime:(NSTimeInterval)currentTime {
    
//    记录当前播放时间
    _currentTime = currentTime;
//    判断显示哪句歌词
    NSInteger count = self.list.count;
    for (NSInteger i = 0; i < count; i++) {
        //取出当前歌词
        LrcLine *currentLrcLine = self.list[i];
        //取出下一句歌词
        NSInteger nextIndex = i + 1;
        LrcLine *nextLrcLine = nil;
        if (nextIndex < count) {
            nextLrcLine = self.list[nextIndex];
        }
        //用当前播放器的时间和当前歌词和下一句歌词的时间作对比
        if (self.currentIndex != i && currentTime >= currentLrcLine.time && currentTime < nextLrcLine.time) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSIndexPath *preIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            //记录当前刷新的某行
            self.currentIndex = i;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath, preIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            //将当前这句歌词滚动到中间
            
//            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            self.lrcLabel.text = currentLrcLine.text;
        }
        //获取当前正在播放歌词的进度，用来给歌词染色
        if (self.currentIndex == i) { // 当前这句歌词
            // 1.用当前播放器的时间减去当前歌词的时间除以(下一句歌词的时间-当前歌词的时间)
            CGFloat value = (currentTime - currentLrcLine.time) / (nextLrcLine.time - currentLrcLine.time);
            // 2.设置当前歌词播放的进度
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            XMGLrcCell *lrcCell = [self.tableView cellForRowAtIndexPath:indexPath];
            lrcCell.lrcLabel.progress = value;
            self.lrcLabel.progress = value;
        }
    }
    
}

#pragma mark - ********************* 重写歌词文件lrcName的set方法
-(void)setLrcName:(NSString *)lrcName {
    
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.bounds.size.height * 0.5) animated:NO];
    self.currentIndex = 0;
    //    记录歌词名
    _lrcName = [lrcName copy];
    //    解析歌词
    self.list = [LrcTool lrcToolWithLrcName:lrcName];
    //    设置第一句歌词
    LrcLine *firstLrcLine = self.list[0];
    self.lrcLabel.text = firstLrcLine.text;
    //    刷新表格
    [self.tableView reloadData];
}
@end





