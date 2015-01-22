//
//  ADBarAddLeftEventProtocol.h
//  ADianTaste
//
//  Created by 陈 超 on 14-3-4.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ADBarAddLeftEventProtocol <NSObject>
@optional
- (void)barViewBackEvent;
- (void)barViewRefreshEvent;
- (void)changeClikeEvent:(int)indexTag;
@end
