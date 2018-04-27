//
//  XMGLrcCell.h
//  04-QQMusic
//
//  Created by xiaomage on 15/12/18.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LrcLabel;
@interface XMGLrcCell : UITableViewCell

/** lrcLabel */
@property (nonatomic, weak) LrcLabel *lrcLabel;

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;

@end
