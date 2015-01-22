//
//  ADOrderFormCell.m
//  ADianTaste
//
//  Created by Keil on 14-3-12.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADOrderFormCell.h"
#import "GView.h"
#import "GDefine.h"
#import "UIView_Extras.h"
#import "ADProductBottomView.h"
#import "ADPurchaseViewController.h"
#define KlabelOffY (KProductCellH-20-20*4)/3.0

@implementation ADOrderFormCell

-(int) getCellHeight
{
    NSMutableArray *array =[NSMutableArray arrayWithArray:[[cellData objectForKey:@"orderDetail"] objectForKey:@"lists"]];

    if ([array count]>0) {
        return KProductCellH *[array count]+20.0+64.0;
    }else{
        return KProductCellH;

    }
}

-(void)dealloc
{
    [super dealloc];
}

-(GView*) createCell
{

    GView* view=[[GView alloc] initWithFrame:CGRectMake(0, 0, KProductCellW, [self getCellHeight])];
    UILabel *orderNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KProductCellW, 20)];
    orderNumLabel.textColor = [UIColor whiteColor];
    orderNumLabel.text = [NSString stringWithFormat:@" %@%@",LTXT(TKN_ORDER_FORM_TITLE),[cellData objectForKey:@"order_code"]];
    orderNumLabel.backgroundColor = [UIColor darkGrayColor];
    orderNumLabel.font = [UIFont systemFontOfSize:18.0];
    orderNumLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:orderNumLabel];
    [orderNumLabel release];
    
    if ([[[cellData objectForKey:@"orderDetail"] objectForKey:@"lists"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *array =[NSMutableArray arrayWithArray:[[cellData objectForKey:@"orderDetail"] objectForKey:@"lists"]];
        for (int i= 0; i<[array count]; i++) {
            ADOrderProduct *cellView = [[ADOrderProduct alloc] initWithFrame:CGRectMake(0, KProductCellH*i+20.0, KProductCellW, KProductCellH)];
            cellView.arrayCell = selArrayData;
            [cellView creatViewCell:[array objectAtIndex:i]];
            cellView.delegate = self;
            [view addSubview:cellView];
            [cellView release];
            
        }
//        ADProductBottomView *bottomView = [[ADProductBottomView alloc]initWithFrame:CGRectMake(0, KProductCellH*[array count]+20.0, KProductCellW, 64)];
//        bottomView.delegate = self;
//        [view addSubview:bottomView];
//        [bottomView release];

    }
    

    
    return [view autorelease];



}
#pragma mark bottomdelegate
- (void)clikeTasteEvent{


}
- (void)clikeShoppingEvent;
{
    ADPurchaseViewController *con = [[ADPurchaseViewController alloc]init];
    [appDelegate setBarAddLeftDelegate:con];
    con.dataArray = [NSMutableArray arrayWithArray:selArrayData];
    [appDelegate.navController pushViewController:con animated:YES];
    [con release];

}
-(void)selCellProduct:(NSMutableDictionary *)dic isDelete:(BOOL)selFlag
{
    if (selFlag==YES) {
        [selArrayData addObject:dic];

    }else{
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:selArrayData];
        for (NSDictionary *dict in tempArray) {
            if ([[dict objectForKey:@"id"] isEqualToString:[dic objectForKey:@"id"]]) {
                [selArrayData removeObject:dict];
            }
        }
    
    }

    NSLog(@"selArrayData====%@",selArrayData);


}

@end


@implementation ADOrderProduct
@synthesize dataDic;
@synthesize delegate;
@synthesize isSelFlag;
@synthesize arrayCell;
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;


}
-(void)dealloc
{
    [dataDic release];
    [super dealloc];
}

- (CGSize)getString:(NSString *)string fontNum:(float)fontNum
{
    UIFont *font = [UIFont systemFontOfSize:fontNum];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(160, MAXFLOAT)];
    return size;
    
}
-(BOOL)isHaveSel:(NSMutableDictionary *)dataCDic
{
    NSLog(@"isHaveSel===arrayCell=%@",self.arrayCell);
    NSLog(@"dataCDic===%@",dataCDic);
    for (NSDictionary *dic in self.arrayCell) {
        if ([[dataCDic objectForKey:@"id"] isEqualToString:[dic objectForKey:@"id"]]) {
            return YES;
        }
    }
    
    return NO;
}
- (void)creatViewCell:(NSMutableDictionary *)productData
{
    
    self.dataDic = productData;
    [self buildImage:[productData objectForKey:@"thumbnail_url"] frame:CGRectMake(10, 8,  KProductCellH-20, KProductCellH-20) defaultimg:IMG(peoplo_default)];
    UILabel *productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+ KProductCellH-20+8, 8, KProductCellW-(10+ KProductCellH-20+8)-60, 20)];
    productNameLabel.font = [UIFont systemFontOfSize:18.0];
    productNameLabel.textAlignment = NSTextAlignmentLeft;
    productNameLabel.text = [productData objectForKey:@"product_name"];
    productNameLabel.backgroundColor = [UIColor clearColor];
    productNameLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:productNameLabel];
    [productNameLabel release];
    
    UILabel *pingPaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+ KProductCellH-20+8, productNameLabel.origin.y+20+KlabelOffY, [self getString:LTXT(TKN_PINGPAI) fontNum:18.0].width, 20)];
    pingPaiLabel.textColor = [UIColor darkGrayColor];
    pingPaiLabel.text = LTXT(TKN_PINGPAI);
    pingPaiLabel.font = [UIFont systemFontOfSize:18.0];
    pingPaiLabel.textAlignment = NSTextAlignmentLeft;
    pingPaiLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:pingPaiLabel];
    [pingPaiLabel release];
    
    UILabel *pingpaiInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(pingPaiLabel.origin.x+pingPaiLabel.size.width+2.0, productNameLabel.origin.y+20+KlabelOffY, [self getString:[productData objectForKey:@"specification_value"] fontNum:18.0].width, 20)];
    pingpaiInfoLabel.textColor= KGreenTitleColor;
    pingpaiInfoLabel.text = [productData objectForKey:@"specification_value"];
    pingpaiInfoLabel.font = [UIFont systemFontOfSize:18.0];
    pingpaiInfoLabel.textAlignment = NSTextAlignmentLeft;
    pingpaiInfoLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:pingpaiInfoLabel];
    [pingpaiInfoLabel release];
    
    UILabel *colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+ KProductCellH-20+8, productNameLabel.origin.y+(20+KlabelOffY)*2, [self getString:LTXT(TKN_YANSE) fontNum:18.0].width, 20)];
    colorLabel.textColor = [UIColor darkGrayColor];
    colorLabel.text = LTXT(TKN_YANSE);
    colorLabel.font = [UIFont systemFontOfSize:18.0];
    colorLabel.textAlignment = NSTextAlignmentLeft;
    colorLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:colorLabel];
    [colorLabel release];
    
    
    UILabel *colorInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(colorLabel.origin.x+colorLabel.size.width+2.0, productNameLabel.origin.y+(20+KlabelOffY)*2, [self getString:[productData objectForKey:@""] fontNum:18.0].width, 20)];
    colorInfoLabel.textColor= KGreenTitleColor;
    colorInfoLabel.text = [productData objectForKey:@""];
    colorInfoLabel.font = [UIFont systemFontOfSize:18.0];
    colorInfoLabel.textAlignment = NSTextAlignmentLeft;
    colorInfoLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:colorInfoLabel];
    [colorInfoLabel release];
    
    UILabel *guigeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+ KProductCellH-20+8+140, productNameLabel.origin.y+(20+KlabelOffY)*2, [self getString:LTXT(TKN_GUIGE) fontNum:18.0].width, 20)];
    guigeLabel.textColor = [UIColor darkGrayColor];
    guigeLabel.text = LTXT(TKN_GUIGE);
    guigeLabel.font = [UIFont systemFontOfSize:18.0];
    guigeLabel.textAlignment = NSTextAlignmentLeft;
    guigeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:guigeLabel];
    [guigeLabel release];
    
    UILabel *guigeInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(guigeLabel.origin.x+guigeLabel.size.width+2.0, productNameLabel.origin.y+(20+KlabelOffY)*2, [self getString:[productData objectForKey:@"size"] fontNum:18.0].width, 20)];
    guigeInfoLabel.textColor= KGreenTitleColor;
    guigeInfoLabel.text = [productData objectForKey:@"size"];
    guigeInfoLabel.font = [UIFont systemFontOfSize:18.0];
    guigeInfoLabel.textAlignment = NSTextAlignmentLeft;
    guigeInfoLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:guigeInfoLabel];
    [guigeInfoLabel release];
    
    UILabel *jiageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+ KProductCellH-20+8, productNameLabel.origin.y+(20+KlabelOffY)*3, [self getString:LTXT(TKN_JIAGE) fontNum:18.0].width, 20)];
    jiageLabel.textColor = [UIColor darkGrayColor];
    jiageLabel.text = LTXT(TKN_JIAGE);
    jiageLabel.font = [UIFont systemFontOfSize:18.0];
    jiageLabel.textAlignment = NSTextAlignmentLeft;
    jiageLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:jiageLabel];
    [jiageLabel release];
    
    UILabel *jiageInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(jiageLabel.origin.x+jiageLabel.size.width+2.0, productNameLabel.origin.y+(20+KlabelOffY)*3, [self getString:[productData objectForKey:@"sku_product_price"] fontNum:18.0].width, 20)];
    jiageInfoLabel.textColor= [UIColor redColor];
    jiageInfoLabel.text = [productData objectForKey:@"sku_product_price"];
    jiageInfoLabel.font = [UIFont systemFontOfSize:18.0];
    jiageInfoLabel.textAlignment = NSTextAlignmentLeft;
    jiageInfoLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:jiageInfoLabel];
    [jiageInfoLabel release];
    
    UIImageView *selImage = [[UIImageView alloc]initWithFrame:CGRectMake(KProductCellW-50, (KProductCellH-17.0)/2.0, 17.0, 17.0)];
    selImage.tag =234;
    if ([self isHaveSel:productData]) {
        selImage.image = IMG(gouwu_sel);
    }else{
        selImage.image = IMG(gouwu_unsel);
    }
    [self addSubview:selImage];
    [selImage release];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, KProductCellH-1, KProductCellW, 1)];
    lineView.backgroundColor = KGreenTitleColor;
    [self addSubview:lineView];
    [lineView release];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height);
    if ([self isHaveSel:productData]) {
        btn.selected = YES;
    }else{
        btn.selected = NO;
    }
    [btn  addTarget:self action:@selector(selProduct:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];


}
-(void)selProduct:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UIImageView *selImage = (UIImageView *)[self viewWithTag:234];
    if (btn.selected ==NO) {
        selImage.image =  IMG(gouwu_sel);
        btn.selected = YES;
        isSelFlag = YES;
    }else{
        selImage.image =  IMG(gouwu_unsel);
        btn.selected = NO;
        isSelFlag = NO;
    
    }
    if ([delegate respondsToSelector:@selector(selCellProduct:isDelete:)]) {
        [delegate selCellProduct:self.dataDic isDelete:btn.selected];
    }

}
@end
