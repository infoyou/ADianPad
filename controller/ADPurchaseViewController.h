//
//  ADPurchaseViewController.h
//  ADianTaste
//
//  Created by 陈 超 on 14-3-13.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "GController.h"
#import "GTableViewV2.h"

@interface ADPurchaseViewController : GController<GTableViewDelegate,UITextFieldDelegate>
{
    GTableViewV2 *tablePurchase;
    NSMutableArray *dataArray;
    BOOL isOrderType;
    BOOL isPayType;

}
@property (nonatomic ,retain)NSMutableArray *dataArray;
@property (nonatomic, assign)BOOL isOrderType;
- (void)downLoginViewAnimation;
@end
