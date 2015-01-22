//
//  ADProductCell.h
//  ADianTaste
//
//  Created by Keil on 14-3-7.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "GDataObject.h"
@protocol putInTiYanCheDelegate;
@interface ADProductCell : GDataObject
{

    BOOL isSel;
    UIImageView *selImage;
    BOOL isNeedHead;
    BOOL noNeedBtn;
    
    BOOL isBackBtn;
    id <putInTiYanCheDelegate> delegate;

}
@property (nonatomic,assign)BOOL isSel;
@property (nonatomic,assign)BOOL isNeedHead;
@property (nonatomic,assign)BOOL noNeedBtn;
@property (nonatomic,assign)BOOL isBackBtn;
@property (nonatomic,assign)int indexCell;
@property (nonatomic,assign)id <putInTiYanCheDelegate> delegate;
- (void)setSelImage;
@end


@protocol putInTiYanCheDelegate <NSObject>

- (void)removeTTTIndex:(int )dataCell;

@end