//
//  ADPeopleCell.m
//  ADianTaste
//
//  Created by Keil on 14-3-7.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADPeopleCell.h"
#import "GView.h"
#import "GDefine.h"
#import "UIView_Extras.h"
#import "GImageView.h"

#define KlabelDapW 115
#define KoffsetXw 30
#define KlabelDapH (KPeopleInfoViewHeiht-20-3*20)/2.0
@implementation ADPeopleCell
- (CGSize)getString:(NSString *)string fontNum:(float)fontNum
{
    UIFont *font = [UIFont systemFontOfSize:fontNum];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(160, MAXFLOAT)];
    return size;
    
}
-(GView*) createCell
{
    NSMutableDictionary *infoDic = [cellData objectForKey:@"member"];
    
    if ([@"" isEqualToString:[cellData objectForKey:@"member"]]) {
        return nil;
    }
    
    GView* view=[[GView alloc] initWithFrame:CGRectMake(0, 0,  KScreenHeight-KLeftWidthStoreViewW, [self getCellHeight])];
    [view buildImage:[infoDic objectForKey:@"thumbnail_url"] frame:CGRectMake(10+KoffsetXw, 10, 90,90) defaultimg:IMG(peoplo_default)];
    GImageView *imageHead = (GImageView*)[view viewWithTag:KTagGImageView];
    if (imageHead) {
        imageHead.layer.masksToBounds = YES;
        imageHead.layer.cornerRadius = 45.0;
    }
    
    CGSize nameSize = [self getString:LTXT(TKN_VIPNICHENG) fontNum:18];
    UILabel *vipNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110+KoffsetXw*2, 10, nameSize.width, 20)];
    vipNameLabel.textColor = [UIColor darkGrayColor];
    vipNameLabel.font = [UIFont systemFontOfSize:18.0];
    vipNameLabel.textAlignment = NSTextAlignmentLeft;
    vipNameLabel.backgroundColor = [UIColor clearColor];
    vipNameLabel.text = LTXT(TKN_VIPNICHENG);
    [view addSubview:vipNameLabel];
    [vipNameLabel release];
    
    UILabel *vipName = [[UILabel alloc]initWithFrame:CGRectMake(110+KoffsetXw*2+nameSize.width, 10, 100, 20)];
    vipName.textColor = [UIColor darkGrayColor];
    vipName.font = [UIFont systemFontOfSize:18.0];
    vipName.textAlignment = NSTextAlignmentLeft;
    vipName.backgroundColor = [UIColor clearColor];
    vipName.text = [infoDic objectForKey:@"nick_name"];
    [view addSubview:vipName];
    [vipName release];
    
    CGSize fromSize = [self getString:LTXT(TKN_VIPFROM) fontNum:18];
    UILabel *vipFromLabel = [[UILabel alloc]initWithFrame:CGRectMake(110+KoffsetXw*2+nameSize.width+KlabelDapW+18.0, 10, fromSize.width, 20)];
    vipFromLabel.textColor = [UIColor darkGrayColor];
    vipFromLabel.font = [UIFont systemFontOfSize:18.0];
    vipFromLabel.textAlignment = NSTextAlignmentLeft;
    vipFromLabel.backgroundColor = [UIColor clearColor];
    vipFromLabel.text = LTXT(TKN_VIPFROM);
    [view addSubview:vipFromLabel];
    [vipFromLabel release];
    
    UILabel *vipFrom = [[UILabel alloc]initWithFrame:CGRectMake(vipFromLabel.origin.x+fromSize.width, 10, 200, 20)];
    vipFrom.textColor = [UIColor darkGrayColor];
    vipFrom.font = [UIFont systemFontOfSize:18.0];
    vipFrom.textAlignment = NSTextAlignmentLeft;
    vipFrom.backgroundColor = [UIColor clearColor];
    
    if ([[infoDic objectForKey:@"weixin_address"] isKindOfClass:[NSDictionary class]]) {
        vipFrom.text = [NSString stringWithFormat:@"%@ %@",[[infoDic objectForKey:@"weixin_address"] objectForKey:@"province"],[[infoDic objectForKey:@"weixin_address"] objectForKey:@"city"]];
    } else {
        vipFrom.text = [NSString stringWithFormat:@"%@ %@",[infoDic objectForKey:@"province"],[infoDic objectForKey:@"city"]];
    }

    [view addSubview:vipFrom];
    [vipFrom release];
    
    CGSize tiYanDanSize = [self getString:LTXT(TKN_VIPTIYANDAN) fontNum:18];
    UILabel *vipTiYanDanLabel = [[UILabel alloc]initWithFrame:CGRectMake(110+KoffsetXw*2, 10+20+KlabelDapH, tiYanDanSize.width, 20)];
    vipTiYanDanLabel.textColor = [UIColor darkGrayColor];
    vipTiYanDanLabel.font = [UIFont systemFontOfSize:18.0];
    vipTiYanDanLabel.textAlignment = NSTextAlignmentLeft;
    vipTiYanDanLabel.backgroundColor = [UIColor clearColor];
    vipTiYanDanLabel.text = LTXT(TKN_VIPTIYANDAN);
    [view addSubview:vipTiYanDanLabel];
    [vipTiYanDanLabel release];
    
    UILabel *tiYanDanName = [[UILabel alloc]initWithFrame:CGRectMake(110+KoffsetXw*2+tiYanDanSize.width, 10+20+KlabelDapH, 100, 20)];
    tiYanDanName.textColor = [UIColor darkGrayColor];
    tiYanDanName.font = [UIFont systemFontOfSize:18.0];
    tiYanDanName.textAlignment = NSTextAlignmentLeft;
    tiYanDanName.backgroundColor = [UIColor clearColor];
    tiYanDanName.text = [[infoDic objectForKey:@"extend"] objectForKey:@"to_store_experience_order_count"];
    [view addSubview:tiYanDanName];
    [tiYanDanName release];
    
    CGSize tiYanChenSize = [self getString:LTXT(TKN_VIPTIYANCHE) fontNum:18];
    UILabel *vipTiYanChenLabel = [[UILabel alloc]initWithFrame:CGRectMake(110+KoffsetXw*2+tiYanDanSize.width+KlabelDapW, 10+20+KlabelDapH, tiYanChenSize.width, 20)];
    vipTiYanChenLabel.textColor = [UIColor darkGrayColor];
    vipTiYanChenLabel.font = [UIFont systemFontOfSize:18.0];
    vipTiYanChenLabel.textAlignment = NSTextAlignmentLeft;
    vipTiYanChenLabel.backgroundColor = [UIColor clearColor];
    vipTiYanChenLabel.text = LTXT(TKN_VIPTIYANCHE);
    [view addSubview:vipTiYanChenLabel];
    [vipTiYanChenLabel release];
    
    UILabel *tiYanChenName = [[UILabel alloc]initWithFrame:CGRectMake(110+KoffsetXw*2+tiYanDanSize.width+KlabelDapW+tiYanChenSize.width, 10+20+KlabelDapH, 100, 20)];
    tiYanChenName.textColor = [UIColor darkGrayColor];
    tiYanChenName.font = [UIFont systemFontOfSize:18.0];
    tiYanChenName.textAlignment = NSTextAlignmentLeft;
    tiYanChenName.backgroundColor = [UIColor clearColor];
    tiYanChenName.text = [[infoDic objectForKey:@"extend"] objectForKey:@"storecart_count"];
    [view addSubview:tiYanChenName];
    [tiYanChenName release];
    
    CGSize shouCangSize = [self getString:LTXT(TKN_VIPSHOUCANG) fontNum:18];
    UILabel *vipShouCangLabel = [[UILabel alloc]initWithFrame:CGRectMake(110+KoffsetXw*2+tiYanDanSize.width+KlabelDapW+tiYanChenSize.width+KlabelDapW, 10+20+KlabelDapH, shouCangSize.width, 20)];
    vipShouCangLabel.textColor = [UIColor darkGrayColor];
    vipShouCangLabel.font = [UIFont systemFontOfSize:18.0];
    vipShouCangLabel.textAlignment = NSTextAlignmentLeft;
    vipShouCangLabel.backgroundColor = [UIColor clearColor];
    vipShouCangLabel.text = LTXT(TKN_VIPSHOUCANG);
    [view addSubview:vipShouCangLabel];
    [vipShouCangLabel release];
    
    UILabel *shouCangName = [[UILabel alloc]initWithFrame:CGRectMake(vipShouCangLabel.origin.x+shouCangSize.width, 10+20+KlabelDapH, 100, 20)];
    shouCangName.textColor = [UIColor darkGrayColor];
    shouCangName.font = [UIFont systemFontOfSize:18.0];
    shouCangName.textAlignment = NSTextAlignmentLeft;
    shouCangName.backgroundColor = [UIColor clearColor];
    shouCangName.text = [[infoDic objectForKey:@"extend"] objectForKey:@"favorite_count"];
    [view addSubview:shouCangName];
    [shouCangName release];
    
    CGSize zaiXianDingDanSize = [self getString:LTXT(TKN_VIPZAIXIAN) fontNum:18];
    UILabel *zaiXianDingDanLabel = [[UILabel alloc]initWithFrame:CGRectMake(110+KoffsetXw*2, 10+(20+KlabelDapH)*2, zaiXianDingDanSize.width, 20)];
    zaiXianDingDanLabel.textColor = [UIColor darkGrayColor];
    zaiXianDingDanLabel.font = [UIFont systemFontOfSize:18.0];
    zaiXianDingDanLabel.textAlignment = NSTextAlignmentLeft;
    zaiXianDingDanLabel.backgroundColor = [UIColor clearColor];
    zaiXianDingDanLabel.text = LTXT(TKN_VIPZAIXIAN);
    [view addSubview:zaiXianDingDanLabel];
    [zaiXianDingDanLabel release];
    
    UILabel *zaiXianDingDanName = [[UILabel alloc]initWithFrame:CGRectMake(110+KoffsetXw*2+zaiXianDingDanSize.width, 10+(20+KlabelDapH)*2, 100, 20)];
    zaiXianDingDanName.textColor = [UIColor darkGrayColor];
    zaiXianDingDanName.font = [UIFont systemFontOfSize:18.0];
    zaiXianDingDanName.textAlignment = NSTextAlignmentLeft;
    zaiXianDingDanName.backgroundColor = [UIColor clearColor];
    zaiXianDingDanName.text = [[infoDic objectForKey:@"extend"] objectForKey:@"non_payment_order_count"];
    [view addSubview:zaiXianDingDanName];
    [zaiXianDingDanName release];
    
    CGSize gouWuCheSize = [self getString:LTXT(TKN_VIPGOUWUCHE) fontNum:18];
    UILabel *gouWuCheLabel = [[UILabel alloc]initWithFrame:CGRectMake(110+KoffsetXw*2+zaiXianDingDanSize.width+KlabelDapW+18.0, 10+(20+KlabelDapH)*2 ,gouWuCheSize.width, 20)];
    gouWuCheLabel.textColor = [UIColor darkGrayColor];
    gouWuCheLabel.font = [UIFont systemFontOfSize:18.0];
    gouWuCheLabel.textAlignment = NSTextAlignmentLeft;
    gouWuCheLabel.backgroundColor = [UIColor clearColor];
    gouWuCheLabel.text = LTXT(TKN_VIPGOUWUCHE);
    [view addSubview:gouWuCheLabel];
    [gouWuCheLabel release];
    
    UILabel *gouWuCheName = [[UILabel alloc]initWithFrame:CGRectMake(gouWuCheLabel.origin.x+gouWuCheSize.width, 10+(20+KlabelDapH)*2, 100, 20)];
    gouWuCheName.textColor = [UIColor darkGrayColor];
    gouWuCheName.font = [UIFont systemFontOfSize:18.0];
    gouWuCheName.textAlignment = NSTextAlignmentLeft;
    gouWuCheName.backgroundColor = [UIColor clearColor];
    gouWuCheName.text = [[infoDic objectForKey:@"extend"] objectForKey:@"shoppingcart_count"];
    [view addSubview:gouWuCheName];
    [gouWuCheName release];
    
    CGSize historySize = [self getString:LTXT(TKN_VIPHISTORY) fontNum:18];
    UILabel *historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(gouWuCheLabel.origin.x+zaiXianDingDanSize.width+KlabelDapW+18.0, 10+(20+KlabelDapH)*2, historySize.width, 20)];
    historyLabel.textColor = [UIColor darkGrayColor];
    historyLabel.font = [UIFont systemFontOfSize:18.0];
    historyLabel.textAlignment = NSTextAlignmentLeft;
    historyLabel.backgroundColor = [UIColor clearColor];
    historyLabel.text = LTXT(TKN_VIPHISTORY);
    [view addSubview:historyLabel];
    [historyLabel release];
    
    UILabel *historyName = [[UILabel alloc]initWithFrame:CGRectMake(historyLabel.origin.x+historySize.width, 10+(20+KlabelDapH)*2, 100, 20)];
    historyName.textColor = [UIColor darkGrayColor];
    historyName.font = [UIFont systemFontOfSize:18.0];
    historyName.textAlignment = NSTextAlignmentLeft;
    historyName.backgroundColor = [UIColor clearColor];
    historyName.text = [[infoDic objectForKey:@"extend"] objectForKey:@"browse_count"];
    [view addSubview:historyName];
    [historyName release];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, KPeopleInfoViewHeiht-1,  KScreenHeight-KLeftWidthStoreViewW, 1)];
    lineView.backgroundColor = KSystemYellow;
    [view addSubview:lineView];
    [lineView release];
    
    return [view autorelease];
}

-(int) getCellHeight
{
    return KPeopleInfoViewHeiht;
}

-(void)dealloc
{
    [super dealloc];
}
@end
