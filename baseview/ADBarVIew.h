//
//  ADBarVIew.h
//  ADianTaste
//
//  Created by Keil on 14-3-4.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBarAddLeftEventProtocol.h"
@interface ADBarVIew : UIView
{
    id <ADBarAddLeftEventProtocol> delegate;
    NSMutableArray *arrayData;
    int flagIndex;
    
}
@property (nonatomic,assign)id <ADBarAddLeftEventProtocol> delegate;
@property (nonatomic,assign)int flagIndex;
- (void)barView;
- (void)resumeView;
@end
