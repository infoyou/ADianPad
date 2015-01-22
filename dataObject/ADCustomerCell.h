//
//  ADCustomerCell.h
//  ADianTaste
//
//  Created by 陈 超 on 14-5-5.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "GDataObject.h"
@protocol clickCustomerCellDelegate;
@interface ADCustomerCell : GDataObject
{
    UIImageView *back;
    BOOL isYes;
    id <clickCustomerCellDelegate> delegate;

}
@property (nonatomic ,assign)BOOL isYes;
@property (nonatomic,assign)id <clickCustomerCellDelegate> delegate;

- (void)hiddenBack:(BOOL)isHidden;
@end


@protocol clickCustomerCellDelegate <NSObject>

- (void)clikeCustomerCellId:(NSString *)memberId open_id:(NSString *)open_id_str;

@end