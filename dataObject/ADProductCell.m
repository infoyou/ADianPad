//
//  ADProductCell.m
//  ADianTaste
//
//  Created by Keil on 14-3-7.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADProductCell.h"
#import "GView.h"
#import "GDefine.h"
#import "UIView_Extras.h"
#import "ADSessionInfo.h"
#import "UIView_Extras.h"
#import "GUtil.h"

#define KlabelOffY (KProductCellH-20-20*4)/3.0
@implementation ADProductCell
@synthesize isSel;
@synthesize isNeedHead;
@synthesize noNeedBtn;
@synthesize isBackBtn;
@synthesize delegate;
@synthesize indexCell;
- (CGSize)getString:(NSString *)string fontNum:(float)fontNum
{
    UIFont *font = [UIFont systemFontOfSize:fontNum];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(160, MAXFLOAT)];
    return size;
    
}
-(GView*) createCell
{

    GView* view=[[GView alloc] initWithFrame:CGRectMake(0, 20.0, KProductCellW, KProductCellH)];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, KProductCellW, 20)];
    titleView.backgroundColor = KCellTitleBackColr;
    [view addSubview:titleView];
    [titleView release];
    
    UILabel *productLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, KProductCellH-20, 20)];
    productLabel.text = @"商品";
    productLabel.font = [UIFont boldSystemFontOfSize:18.0];
    productLabel.textColor = [UIColor darkGrayColor];
    productLabel.textAlignment =NSTextAlignmentCenter;
    [titleView addSubview:productLabel];
    [productLabel release];
    
    UILabel *productInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(30+ KProductCellH-20+30, 0, KProductCellW-(10+ KProductCellH-20+8)-360, 20)];
    productInfoLabel.text = @"商品信息";
    productInfoLabel.font = [UIFont boldSystemFontOfSize:18.0];
    productInfoLabel.textColor = [UIColor darkGrayColor];
    productInfoLabel.textAlignment =NSTextAlignmentCenter;
    [titleView addSubview:productInfoLabel];
    [productInfoLabel release];
    
    view.backgroundColor = KCellBackColr;
    [view buildImage:[[[cellData objectForKey:@"product_detail"] objectForKey:@"thumbnail_url"] stringByAppendingString:@"s_80.jpg"] frame:CGRectMake(30, 8,  KProductCellH-20, KProductCellH-20) defaultimg:IMG(peoplo_default)];
    UILabel *productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30+ KProductCellH-20+30, 8, KProductCellW-(10+ KProductCellH-20+8)-60, 20)];
    productNameLabel.font = [UIFont systemFontOfSize:18.0];
    productNameLabel.textAlignment = NSTextAlignmentLeft;
    productNameLabel.text = [[cellData objectForKey:@"product_detail"] objectForKey:@"product_name"];
    productNameLabel.backgroundColor = [UIColor clearColor];
    productNameLabel.textColor = [UIColor darkGrayColor];
    [view addSubview:productNameLabel];
    [productNameLabel release];
    
    UILabel *pingPaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(30+ KProductCellH-20+30, productNameLabel.origin.y+20+KlabelOffY, [self getString:LTXT(TKN_PINGPAI) fontNum:18.0].width, 20)];
    pingPaiLabel.textColor = [UIColor darkGrayColor];
    pingPaiLabel.text = LTXT(TKN_PINGPAI);
    pingPaiLabel.font = [UIFont systemFontOfSize:18.0];
    pingPaiLabel.textAlignment = NSTextAlignmentLeft;
    pingPaiLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:pingPaiLabel];
    [pingPaiLabel release];
    
    UILabel *pingpaiInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(pingPaiLabel.origin.x+pingPaiLabel.size.width+2.0, productNameLabel.origin.y+20+KlabelOffY, [self getString:[[cellData objectForKey:@"product_detail"] objectForKey:@"specification_value"] fontNum:18.0].width, 20)];
    pingpaiInfoLabel.textColor= [UIColor redColor];
    pingpaiInfoLabel.text = [[cellData objectForKey:@"product_detail"] objectForKey:@"specification_value"];
    pingpaiInfoLabel.font = [UIFont systemFontOfSize:18.0];
    pingpaiInfoLabel.textAlignment = NSTextAlignmentLeft;
    pingpaiInfoLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:pingpaiInfoLabel];
    [pingpaiInfoLabel release];
    
    BOOL isHaveColr = YES;
    if ([[cellData objectForKey:@"product_detail"] objectForKey:@"spcifical_value"]==nil||[[[cellData objectForKey:@"product_detail"] objectForKey:@"spcifical_value"] isEqualToString:@""]) {
        isHaveColr = NO;
    }else{
        isHaveColr = YES;
        
    }
    
    UILabel *colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(30+ KProductCellH-20+30, productNameLabel.origin.y+(20+KlabelOffY)*2, [self getString:LTXT(TKN_YANSE) fontNum:18.0].width, 20)];
    colorLabel.textColor = [UIColor darkGrayColor];
    if (isHaveColr) {
        colorLabel.hidden = NO;
    }else{
        colorLabel.hidden = YES;
    }
    colorLabel.text = LTXT(TKN_YANSE);
    colorLabel.font = [UIFont systemFontOfSize:18.0];
    colorLabel.textAlignment = NSTextAlignmentLeft;
    colorLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:colorLabel];
    [colorLabel release];
    
    
    UILabel *colorInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(colorLabel.origin.x+colorLabel.size.width+2.0, productNameLabel.origin.y+(20+KlabelOffY)*2, [self getString:[cellData objectForKey:@""] fontNum:18.0].width, 20)];
    colorInfoLabel.textColor= [UIColor redColor];
    if (isHaveColr) {
        colorInfoLabel.hidden = NO;
    }else{
        colorInfoLabel.hidden = YES;
    }
    colorInfoLabel.text = [cellData objectForKey:@""];
    colorInfoLabel.font = [UIFont systemFontOfSize:18.0];
    colorInfoLabel.textAlignment = NSTextAlignmentLeft;
    colorInfoLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:colorInfoLabel];
    [colorInfoLabel release];
    
    UILabel *guigeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30+ KProductCellH-20+30+140, productNameLabel.origin.y+(20+KlabelOffY)*2, [self getString:LTXT(TKN_GUIGE) fontNum:18.0].width, 20)];
    guigeLabel.textColor = [UIColor darkGrayColor];
    if (isHaveColr==NO) {
        guigeLabel.frame = CGRectMake(colorLabel.frame.origin.x, colorLabel.frame.origin.y, [self getString:LTXT(TKN_GUIGE) fontNum:18.0].width, 20);
    }
    guigeLabel.text = LTXT(TKN_GUIGE);
    guigeLabel.font = [UIFont systemFontOfSize:18.0];
    guigeLabel.textAlignment = NSTextAlignmentLeft;
    guigeLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:guigeLabel];
    [guigeLabel release];
    
    UILabel *guigeInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(guigeLabel.origin.x+guigeLabel.size.width+2.0, productNameLabel.origin.y+(20+KlabelOffY)*2, [self getString:[cellData objectForKey:@"size"] fontNum:18.0].width, 20)];
    guigeInfoLabel.textColor= [UIColor redColor];
    if (isHaveColr==NO) {
        guigeInfoLabel.frame = CGRectMake(colorInfoLabel.frame.origin.x, colorInfoLabel.frame.origin.y,[self getString:[cellData objectForKey:@"size"] fontNum:18.0].width, 20);
    }
    guigeInfoLabel.text = [cellData objectForKey:@"size"];
    guigeInfoLabel.font = [UIFont systemFontOfSize:18.0];
    guigeInfoLabel.textAlignment = NSTextAlignmentLeft;
    guigeInfoLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:guigeInfoLabel];
    [guigeInfoLabel release];
    
    UILabel *jiageLabel = [[UILabel alloc]initWithFrame:CGRectMake(30+ KProductCellH-20+30, productNameLabel.origin.y+(20+KlabelOffY)*3, [self getString:LTXT(TKN_JIAGE) fontNum:18.0].width, 20)];
    jiageLabel.textColor = [UIColor darkGrayColor];
    jiageLabel.text = LTXT(TKN_JIAGE);
    jiageLabel.font = [UIFont systemFontOfSize:18.0];
    jiageLabel.textAlignment = NSTextAlignmentLeft;
    jiageLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:jiageLabel];
    [jiageLabel release];
    
    UILabel *jiageInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(jiageLabel.origin.x+jiageLabel.size.width+2.0, productNameLabel.origin.y+(20+KlabelOffY)*3, [self getString:[[cellData objectForKey:@"product_detail"] objectForKey:@"price"] fontNum:18.0].width, 20)];
    jiageInfoLabel.textColor= [UIColor redColor];
    jiageInfoLabel.text = [[cellData objectForKey:@"product_detail"] objectForKey:@"price"];
    jiageInfoLabel.font = [UIFont systemFontOfSize:18.0];
    jiageInfoLabel.textAlignment = NSTextAlignmentLeft;
    jiageInfoLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:jiageInfoLabel];
    [jiageInfoLabel release];
    
    selImage = [[UIImageView alloc]initWithFrame:CGRectMake(KProductCellW-50, (KProductCellH-17.0)/2.0, 17.0, 17.0)];
    if (isSel==YES) {
        selImage.image = IMG(gouwu_sel);
    }else{
        selImage.image = IMG(gouwu_unsel);
    }
    if (noNeedBtn ==YES) {
        selImage.hidden =YES;
    }
    [view addSubview:selImage];
    
    if (isBackBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [btn setTitle:@"加入到店体验车" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(KProductCellW-140-20, (KProductCellH-40)/2.0, 140, 40);
        [btn addTarget:self action:@selector(clickAdd:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, KProductCellH-1, KProductCellW, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [view addSubview:lineView];
    [lineView release];
    
    return [view autorelease];
}

- (void)getCustomerInfo:(NSNumber *)issuccess{
    if ([issuccess boolValue]) {
        if ([delegate respondsToSelector:@selector(removeTTTIndex:)]) {
            [delegate removeTTTIndex:indexCell];
        }
        Alert0(@"加入成功");

    }else{
        Alert0(@"加入失败");
    }
}

- (void)clickAdd:(id)sender
{
    @autoreleasepool {
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[cellData objectForKey:@"product_detail"] objectForKey:@"product_id"],@"product_id",[[cellData objectForKey:@"product_detail"] objectForKey:@"sku_id"],@"sku_id",@"1",@"sku_qty", @"1",@"cart_type",@"fav",@"from",[cellData  objectForKey:@"size"],@"size",nil];
        NSDictionary *dic = [JsonRequestItem requestSyncJson:data withCmd:@"wuadian_member_addtoshoppingcart" withPost:YES];
        NSLog(@"dic=====%@",dic);
        if ([[dic objectForKey:@"rsp"] intValue]==1) {
            [self performSelectorOnMainThread:@selector(getCustomerInfo:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:NO];
        }else{
            [self performSelectorOnMainThread:@selector(getCustomerInfo:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:NO];
        }
    }
}

- (void)setSelImage
{
    if (isSel==NO) {
        selImage.image = IMG(gouwu_sel);
        isSel = YES;
    }else if (isSel==YES){
        selImage.image = IMG(gouwu_unsel);
        isSel = NO;
    }
}
-(int) getCellHeight
{
    return KProductCellH+20.0;
}
-(void)dealloc
{
    [selImage release];
    [super dealloc];
}
@end
