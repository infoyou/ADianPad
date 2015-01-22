//
//  ADMainViewController.h
//  ADianTaste
//
//  Created by Keil on 14-3-4.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GController.h"
#import "ADTabView.h"
#import "ADInfoView.h"
#import "GTableViewV2.h"
#import "ADProductBottomView.h"
#import "ADOrderFormCell.h"
#import "ADProductCell.h"

@interface ADMainViewController : GController<changeTabDelegate,GTableViewDelegate,putInTiYanCheDelegate,bottomEventDelgegate>
{
    NSTimer *timer;
    GTableViewV2 *tiYanDanTable;
    GTableViewV2 *tiYanCheTable;
    GTableViewV2 *onLineTable;
    GTableViewV2 *didTiYanTable;
    GTableViewV2 *shouCangTable;
    GTableViewV2 *historyTable;
    
    ADInfoView *userInfoView;
    ADTabView *tabView;
    ADProductBottomView  *bottomView;
    BOOL isTiming;
    UIImageView *tableViewBackRect;
    
    NSMutableArray *gouMaiArray;
    BOOL isFirst;
    
    UILabel *alertLabel;
//    NSMutableArray *offsetArray;
}
- (void)stopLoop;
- (void)getCustomerInfo;
- (void)backRefreshQrcode;
@end
