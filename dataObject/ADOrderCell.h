//
//  ADOrderCell.h
//  ADianTaste
//
//  Created by 陈 超 on 14-3-15.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "GDataObject.h"

@interface ADOrderCell : GDataObject
{
    BOOL isSel;
    UIImageView *selImage;
    BOOL isNeedHead;
    NSString *dingdanHao;
    BOOL noNeedBtn;

}
@property (nonatomic,assign)BOOL isSel;
@property (nonatomic,assign)BOOL isNeedHead;
@property (nonatomic,retain)NSString *dingdanHao;
@property (nonatomic,assign)BOOL noNeedBtn;
- (void)setSelImage;
@end
