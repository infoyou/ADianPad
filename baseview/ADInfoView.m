//
//  ADInfoView.m
//  ADianTaste
//
//  Created by 陈 超 on 14-3-5.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADInfoView.h"
#import "UIView_Extras.h"
#import "GDefine.h"
#import "GImageView.h"

#define KlabelDapW 115
#define KoffsetXw 30
#define KlabelDapH (KPeopleInfoViewHeiht-20-3*20)/2.0

@implementation ADInfoView
//@synthesize infoDic;
enum KNumLabelTag
{
    VIPNAMETAG=10,
    VIPFROM,
    VIPTIYANDAN,
    VIPTIYANCHE,
    VIPSHOUCANG,
    VIPZAIXIANDINGDAN,
    VIPZAIXIANGOUWUCHE,
    VIPHISTORY
};
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createInfoView];
    }
    return self;
}
- (CGSize)getString:(NSString *)string fontNum:(float)fontNum
{
    UIFont *font = [UIFont systemFontOfSize:fontNum];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(160, MAXFLOAT)];
    return size;
    
}
- (void)createInfoView
{
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:self.bounds];
    backImage.image = IMG(banner_info_back);
    [self addSubview:backImage];
    [backImage release];

    [self buildImage:@"" frame:CGRectMake(10+KoffsetXw, 10, 90,90) defaultimg:IMG(peoplo_default)];
    GImageView *imageHead = (GImageView*)[self viewWithTag:KTagGImageView];
    if (imageHead) {
        imageHead.layer.masksToBounds = YES;
        imageHead.layer.cornerRadius = 45.0;
    }
    
    CGSize nameSize = [self getString:LTXT(TKN_VIPNICHENG) fontNum:18];
    UILabel *vipNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110+2*KoffsetXw, 10, nameSize.width, 20)];
    vipNameLabel.textColor = [UIColor whiteColor];
    vipNameLabel.font = [UIFont systemFontOfSize:18.0];
    vipNameLabel.textAlignment = NSTextAlignmentLeft;
    vipNameLabel.backgroundColor = [UIColor clearColor];
    vipNameLabel.text = LTXT(TKN_VIPNICHENG);
    [self addSubview:vipNameLabel];
    [vipNameLabel release];
    
    UILabel *vipName = [[UILabel alloc]initWithFrame:CGRectMake(110+2*KoffsetXw+nameSize.width, 10, 100, 20)];
    vipName.textColor = KSystemYellow;
    vipName.tag = VIPNAMETAG;
    vipName.font = [UIFont systemFontOfSize:18.0];
    vipName.textAlignment = NSTextAlignmentLeft;
    vipName.backgroundColor = [UIColor clearColor];
//    vipName.text = @"11";
    [self addSubview:vipName];
    [vipName release];
    
    CGSize fromSize = [self getString:LTXT(TKN_VIPFROM) fontNum:18];
    UILabel *vipFromLabel = [[UILabel alloc]initWithFrame:CGRectMake(110+2*KoffsetXw+nameSize.width+KlabelDapW+18.0, 10, fromSize.width, 20)];
    vipFromLabel.textColor = [UIColor whiteColor];
    vipFromLabel.font = [UIFont systemFontOfSize:18.0];
    vipFromLabel.textAlignment = NSTextAlignmentLeft;
    vipFromLabel.backgroundColor = [UIColor clearColor];
    vipFromLabel.text = LTXT(TKN_VIPFROM);
    [self addSubview:vipFromLabel];
    [vipFromLabel release];
    
    UILabel *vipFrom = [[UILabel alloc]initWithFrame:CGRectMake(vipFromLabel.origin.x+fromSize.width, 10, 300, 20)];
    vipFrom.textColor = KSystemYellow;
    vipFrom.tag = VIPFROM;
    vipFrom.font = [UIFont systemFontOfSize:18.0];
    vipFrom.textAlignment = NSTextAlignmentLeft;
    vipFrom.backgroundColor = [UIColor clearColor];
//    vipFrom.text = @"12";
    [self addSubview:vipFrom];
    [vipFrom release];
    
    
    CGSize tiYanDanSize = [self getString:LTXT(TKN_VIPTIYANDAN) fontNum:18];
    UILabel *vipTiYanDanLabel = [[UILabel alloc]initWithFrame:CGRectMake(110+2*KoffsetXw, 10+20+KlabelDapH, tiYanDanSize.width, 20)];
    vipTiYanDanLabel.textColor = [UIColor whiteColor];
    vipTiYanDanLabel.font = [UIFont systemFontOfSize:18.0];
    vipTiYanDanLabel.textAlignment = NSTextAlignmentLeft;
    vipTiYanDanLabel.backgroundColor = [UIColor clearColor];
    vipTiYanDanLabel.text = LTXT(TKN_VIPTIYANDAN);
    [self addSubview:vipTiYanDanLabel];
    [vipTiYanDanLabel release];
    
    UILabel *tiYanDanName = [[UILabel alloc]initWithFrame:CGRectMake(110+2*KoffsetXw+tiYanDanSize.width, 10+20+KlabelDapH, 100, 20)];
    tiYanDanName.textColor = [UIColor yellowColor];
    tiYanDanName.tag = VIPTIYANDAN;
    tiYanDanName.font = [UIFont systemFontOfSize:18.0];
    tiYanDanName.textAlignment = NSTextAlignmentLeft;
    tiYanDanName.backgroundColor = [UIColor clearColor];
//    tiYanDanName.text = @"13";
    [self addSubview:tiYanDanName];
    [tiYanDanName release];
    
    CGSize tiYanChenSize = [self getString:LTXT(TKN_VIPTIYANCHE) fontNum:18];
    UILabel *vipTiYanChenLabel = [[UILabel alloc]initWithFrame:CGRectMake(110+2*KoffsetXw+tiYanDanSize.width+KlabelDapW, 10+20+KlabelDapH, tiYanChenSize.width, 20)];
    vipTiYanChenLabel.textColor = [UIColor whiteColor];
    vipTiYanChenLabel.font = [UIFont systemFontOfSize:18.0];
    vipTiYanChenLabel.textAlignment = NSTextAlignmentLeft;
    vipTiYanChenLabel.backgroundColor = [UIColor clearColor];
    vipTiYanChenLabel.text = LTXT(TKN_VIPTIYANCHE);
    [self addSubview:vipTiYanChenLabel];
    [vipTiYanChenLabel release];
    
    UILabel *tiYanChenName = [[UILabel alloc]initWithFrame:CGRectMake(110+2*KoffsetXw+tiYanDanSize.width+KlabelDapW+tiYanChenSize.width, 10+20+KlabelDapH, 100, 20)];
    tiYanChenName.textColor = [UIColor yellowColor];
    tiYanChenName.tag = VIPTIYANCHE;
    tiYanChenName.font = [UIFont systemFontOfSize:18.0];
    tiYanChenName.textAlignment = NSTextAlignmentLeft;
    tiYanChenName.backgroundColor = [UIColor clearColor];
//    tiYanChenName.text = @"14";
    [self addSubview:tiYanChenName];
    [tiYanChenName release];
    
    CGSize shouCangSize = [self getString:LTXT(TKN_VIPSHOUCANG) fontNum:18];
    UILabel *vipShouCangLabel = [[UILabel alloc]initWithFrame:CGRectMake(110+2*KoffsetXw+tiYanDanSize.width+KlabelDapW+tiYanChenSize.width+KlabelDapW, 10+20+KlabelDapH, shouCangSize.width, 20)];
    vipShouCangLabel.textColor = [UIColor whiteColor];
    vipShouCangLabel.font = [UIFont systemFontOfSize:18.0];
    vipShouCangLabel.textAlignment = NSTextAlignmentLeft;
    vipShouCangLabel.backgroundColor = [UIColor clearColor];
    vipShouCangLabel.text = LTXT(TKN_VIPSHOUCANG);
    [self addSubview:vipShouCangLabel];
    [vipShouCangLabel release];
    
    UILabel *shouCangName = [[UILabel alloc]initWithFrame:CGRectMake(vipShouCangLabel.origin.x+shouCangSize.width, 10+20+KlabelDapH, 100, 20)];
    shouCangName.textColor = [UIColor yellowColor];
    shouCangName.tag = VIPSHOUCANG;
    shouCangName.font = [UIFont systemFontOfSize:18.0];
    shouCangName.textAlignment = NSTextAlignmentLeft;
    shouCangName.backgroundColor = [UIColor clearColor];
//    shouCangName.text = @"15";
    [self addSubview:shouCangName];
    [shouCangName release];
    
    
    CGSize zaiXianDingDanSize = [self getString:LTXT(TKN_VIPZAIXIAN) fontNum:18];
    UILabel *zaiXianDingDanLabel = [[UILabel alloc]initWithFrame:CGRectMake(110+2*KoffsetXw, 10+(20+KlabelDapH)*2, zaiXianDingDanSize.width, 20)];
    zaiXianDingDanLabel.textColor = [UIColor whiteColor];
    zaiXianDingDanLabel.font = [UIFont systemFontOfSize:18.0];
    zaiXianDingDanLabel.textAlignment = NSTextAlignmentLeft;
    zaiXianDingDanLabel.backgroundColor = [UIColor clearColor];
    zaiXianDingDanLabel.text = LTXT(TKN_VIPZAIXIAN);
    [self addSubview:zaiXianDingDanLabel];
    [zaiXianDingDanLabel release];
    
    UILabel *zaiXianDingDanName = [[UILabel alloc]initWithFrame:CGRectMake(110+2*KoffsetXw+zaiXianDingDanSize.width, 10+(20+KlabelDapH)*2, 100, 20)];
    zaiXianDingDanName.textColor = [UIColor yellowColor];
    zaiXianDingDanName.tag = VIPZAIXIANDINGDAN;
    zaiXianDingDanName.font = [UIFont systemFontOfSize:18.0];
    zaiXianDingDanName.textAlignment = NSTextAlignmentLeft;
    zaiXianDingDanName.backgroundColor = [UIColor clearColor];
//    zaiXianDingDanName.text = @"16";
    [self addSubview:zaiXianDingDanName];
    [zaiXianDingDanName release];
    
    CGSize gouWuCheSize = [self getString:LTXT(TKN_VIPGOUWUCHE) fontNum:18];
    UILabel *gouWuCheLabel = [[UILabel alloc]initWithFrame:CGRectMake(110+2*KoffsetXw+zaiXianDingDanSize.width+KlabelDapW+18.0, 10+(20+KlabelDapH)*2 ,gouWuCheSize.width, 20)];
    gouWuCheLabel.textColor = [UIColor whiteColor];
    gouWuCheLabel.font = [UIFont systemFontOfSize:18.0];
    gouWuCheLabel.textAlignment = NSTextAlignmentLeft;
    gouWuCheLabel.backgroundColor = [UIColor clearColor];
    gouWuCheLabel.text = LTXT(TKN_VIPGOUWUCHE);
    [self addSubview:gouWuCheLabel];
    [gouWuCheLabel release];
    
    UILabel *gouWuCheName = [[UILabel alloc]initWithFrame:CGRectMake(gouWuCheLabel.origin.x+gouWuCheSize.width, 10+(20+KlabelDapH)*2, 100, 20)];
    gouWuCheName.textColor = [UIColor yellowColor];
    gouWuCheName.tag = VIPZAIXIANGOUWUCHE;
    gouWuCheName.font = [UIFont systemFontOfSize:18.0];
    gouWuCheName.textAlignment = NSTextAlignmentLeft;
    gouWuCheName.backgroundColor = [UIColor clearColor];
//    gouWuCheName.text = @"17";
    [self addSubview:gouWuCheName];
    [gouWuCheName release];
    
    CGSize historySize = [self getString:LTXT(TKN_VIPHISTORY) fontNum:18];
    UILabel *historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(gouWuCheLabel.origin.x+zaiXianDingDanSize.width+KlabelDapW+18.0, 10+(20+KlabelDapH)*2, historySize.width, 20)];
    historyLabel.textColor = [UIColor whiteColor];
    historyLabel.font = [UIFont systemFontOfSize:18.0];
    historyLabel.textAlignment = NSTextAlignmentLeft;
    historyLabel.backgroundColor = [UIColor clearColor];
    historyLabel.text = LTXT(TKN_VIPHISTORY);
    [self addSubview:historyLabel];
    [historyLabel release];
    
    UILabel *historyName = [[UILabel alloc]initWithFrame:CGRectMake(historyLabel.origin.x+historySize.width, 10+(20+KlabelDapH)*2, 100, 20)];
    historyName.textColor = [UIColor yellowColor];
    historyName.tag = VIPHISTORY;
    historyName.font = [UIFont systemFontOfSize:18.0];
    historyName.textAlignment = NSTextAlignmentLeft;
    historyName.backgroundColor = [UIColor clearColor];
//    historyName.text = @"18";
    [self addSubview:historyName];
    [historyName release];

//    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 109, KScreenHeight-KLeftWidthStoreViewW, 1)];
//    lineV.backgroundColor = KGreenTitleColor;
//    [self addSubview:lineV];
//    [lineV release];
}

- (void)updateInfoNum:(NSMutableDictionary *)infoDic
{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(KLeftWidthStoreViewW, KBarWidthF+ios7H, KScreenHeight-KLeftWidthStoreViewW, KPeopleInfoViewHeiht);
        
    } completion:^(BOOL finished) {
        GImageView *imageView = (GImageView *)[self viewWithTag:KTagGImageView];
        if (imageView) {
            [imageView loadImage:[infoDic objectForKey:@"thumbnail_url"] defalutImage:IMG(peoplo_default)];
        }
        UILabel *labelName = (UILabel *)[self viewWithTag:VIPNAMETAG];
        if (labelName) {
            labelName.text = [infoDic objectForKey:@"nick_name"];
        }
        
        UILabel *labelFrom = (UILabel *)[self viewWithTag:VIPFROM];
        if (labelFrom) {
            if ([[infoDic objectForKey:@"weixin_address"] isKindOfClass:[NSDictionary class]]) {
                labelFrom.text = [NSString stringWithFormat:@"%@ %@",[[infoDic objectForKey:@"weixin_address"] objectForKey:@"province"],[[infoDic objectForKey:@"weixin_address"] objectForKey:@"city"]];
            }else{
                labelFrom.text = [NSString stringWithFormat:@"%@ %@",[infoDic objectForKey:@"province"],[infoDic objectForKey:@"city"]];
            }
            
//            labelFrom.text = [NSString stringWithFormat:@"%@ %@",[[infoDic objectForKey:@"weixin_address"] objectForKey:@"province"],[[infoDic objectForKey:@"weixin_address"] objectForKey:@"city"]];
        }
        
        UILabel *labelTiYanDan = (UILabel *)[self viewWithTag:VIPTIYANDAN];
        if (labelTiYanDan) {
            labelTiYanDan.text = [[infoDic objectForKey:@"extend"] objectForKey:@"to_store_experience_order_count"];
        }
        UILabel *labelTiYanChe = (UILabel *)[self viewWithTag:VIPTIYANCHE];
        if (labelTiYanChe) {
            labelTiYanChe.text = [[infoDic objectForKey:@"extend"] objectForKey:@"storecart_count"];
        }
        UILabel *labelShouCang = (UILabel *)[self viewWithTag:VIPSHOUCANG];
        if (labelShouCang) {
            labelShouCang.text = [[infoDic objectForKey:@"extend"] objectForKey:@"favorite_count"];
        }
        UILabel *labelZXDingDan = (UILabel *)[self viewWithTag:VIPZAIXIANDINGDAN];
        if (labelZXDingDan) {
            labelZXDingDan.text = [[infoDic objectForKey:@"extend"] objectForKey:@"non_payment_order_count"];
        }
        UILabel *labelZXGWC = (UILabel *)[self viewWithTag:VIPZAIXIANGOUWUCHE];
        if (labelZXGWC) {
            labelZXGWC.text = [[infoDic objectForKey:@"extend"] objectForKey:@"shoppingcart_count"];
        }
        UILabel *labelHistory = (UILabel *)[self viewWithTag:VIPHISTORY];
        if (labelHistory) {
            labelHistory.text = [[infoDic objectForKey:@"extend"] objectForKey:@"browse_count"];
        }
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)dealloc
{
    [super dealloc];
}

@end
