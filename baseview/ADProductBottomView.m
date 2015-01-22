//
//  ADProductBottomView.m
//  ADianTaste
//
//  Created by Keil on 14-3-12.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADProductBottomView.h"
#import "GDefine.h"
#define KTiYanBtnTag 232
@implementation ADProductBottomView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createBottomView];
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
}
- (CGSize)getString:(NSString *)string fontNum:(float)fontNum
{
    UIFont *font = [UIFont boldSystemFontOfSize:fontNum];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(160, MAXFLOAT)];
    return size;
    
}
- (void)createBottomView
{

    
    UIButton *tiyanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tiyanBtn.tag = KTiYanBtnTag;
    tiyanBtn.frame = CGRectMake(100+159*2, (self.frame.size.height-54)/2.0, 159, 54);
    tiyanBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [tiyanBtn setBackgroundImage:[UIImage imageNamed:@"btnOrange.png"] forState:UIControlStateNormal];
    [tiyanBtn setTitle:LTXT(TKN_TIYAN_BTN_TITLE) forState:UIControlStateNormal];
    [tiyanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tiyanBtn addTarget:self action:@selector(clickTaste) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tiyanBtn];
    
    UIButton *gouMaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gouMaiBtn.frame = CGRectMake(100 +159*3 +40, (self.frame.size.height-54)/2.0, 159, 54);
    gouMaiBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [gouMaiBtn setBackgroundImage:[UIImage imageNamed:@"btnGreen.png"] forState:UIControlStateNormal];
    [gouMaiBtn setTitle:LTXT(TKN_GOUMAI_BTN_TITLE) forState:UIControlStateNormal];
    [gouMaiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gouMaiBtn addTarget:self action:@selector(clickMai) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:gouMaiBtn];

    CGSize yixuanSize = [self getString:@"已选" fontNum:18.0];
    UILabel *yixuanLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, (self.frame.size.height-18.0)/2.0, yixuanSize.width, 18.0)];
    yixuanLabel.text = @"已选";
    yixuanLabel.textColor = [UIColor darkGrayColor];
    yixuanLabel.font = [UIFont boldSystemFontOfSize:18.0];
    yixuanLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:yixuanLabel];
    [yixuanLabel release];
    
    
    CGSize numLabelSize = [self getString:@"0" fontNum:18.0];
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(100+ yixuanSize.width, (self.frame.size.height-20.0)/2.0, numLabelSize.width, 20)];
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.tag = 998;
    numLabel.text = @"0";
    numLabel.textColor = KSystemBlue;
    numLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self addSubview:numLabel];
    [numLabel release];
    
    UILabel *shangpinLabel = [[UILabel alloc]initWithFrame:CGRectMake(100+ yixuanSize.width+numLabelSize.width, (self.frame.size.height-18.0)/2.0, 60.0, 18.0)];
    shangpinLabel.text = @"件商品";
    shangpinLabel.textColor = [UIColor darkGrayColor];
    shangpinLabel.tag = 1006;
    shangpinLabel.font = [UIFont boldSystemFontOfSize:18.0];
    shangpinLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:shangpinLabel];
    [shangpinLabel release];
    
    


}
- (void)updateNumLabel:(NSString *)numString
{
    UILabel *label1 = (UILabel *)[self viewWithTag:998];
    label1.text = numString;
    CGSize numSize = [self getString:numString fontNum:20.0];
    CGRect rect = label1.frame;
    label1.frame = CGRectMake(rect.origin.x, (self.frame.size.height-20.0)/2.0, numSize.width, 20.0);
    
    UILabel *shangpinLabel = (UILabel *)[self viewWithTag:1006];
    CGRect shangrect = shangpinLabel.frame;
    shangpinLabel.frame = CGRectMake(rect.origin.x+numSize.width, shangrect.origin.y, 60.0, 18.0);

}
- (void)hiddenTiyanBtn:(BOOL)isHidden
{

    UIButton *btn = (UIButton *)[self viewWithTag:KTiYanBtnTag];
    if (btn) {
        btn.hidden = isHidden;
    }


}
- (void)clickTaste
{
    if ([delegate respondsToSelector:@selector(clikeTasteEvent)]) {
        [delegate clikeTasteEvent];
    }


}
- (void)clickMai
{
    if ([delegate respondsToSelector:@selector(clikeShoppingEvent)]) {
        [delegate clikeShoppingEvent];
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
