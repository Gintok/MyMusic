//
//  LrcLine.m
//  Music
//
//  Created by 户其修 on 2018/3/25.
//  Copyright © 2018年 户其修. All rights reserved.
//

#import "LrcLine.h"

@implementation LrcLine

+(instancetype)lrcLineString:(NSString *)lrcString {
    return [[self alloc] initWithLrcLineString:lrcString];
}

-(instancetype)initWithLrcLineString:(NSString *)lrcString {
    self = [super init];
    if (self) {
        NSArray *lrcArray = [lrcString componentsSeparatedByString:@"]"];
        self.text = lrcArray[1];
        self.time = [self timeWithString:[lrcArray[0] substringFromIndex:1]];
    }
    return self;
}

-(NSTimeInterval)timeWithString:(NSString *) timeString{
    NSInteger min = [[timeString componentsSeparatedByString:@":"][0] integerValue];
    NSInteger sec = [[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSInteger hs = [[timeString componentsSeparatedByString:@"."][1] integerValue];
    return min * 60 + sec + hs * 0.01;
}
@end
