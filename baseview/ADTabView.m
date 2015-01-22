//
//  ADTabView.m
//  ADianTaste
//
//  Created by Keil on 14-3-5.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADTabView.h"
#import "GDefine.h"
#define KUnselHeiht 49.0
#define KSelWidth 58.0
#define KTabBtnW 107.0
#define Xoff 35
#define KdapW (KScreenHeight-200-70-6*107)/5.0
@implementation ADTabView
@synthesize delegate;
@synthesize indexSel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KSystemBlue;
        dataTitle = [[NSMutableArray alloc]initWithObjects:LTXT(TKN_YUYUETIYANDAN),LTXT(TKN_YUYUETIYANCHE), LTXT(TKN_ZAIXIANDINGDAN),LTXT(TKN_YITIYANSHANGPING),LTXT(TKN_SHOUCANG),LTXT(TKN_LIULANLISHI),nil];
        btnArray = [[NSMutableArray alloc] init];
        for (int i = 0; i <[dataTitle count]; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            [btn setTitle:[dataTitle objectAtIndex:i] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
            btn.frame = CGRectMake(Xoff+i*(KdapW + KTabBtnW),0, KTabBtnW, KUnselHeiht);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if (i<[dataTitle count]-1) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Xoff+i*(KdapW + KTabBtnW)+KTabBtnW+10.0, (58.0-18)/2.0, 1, 18)];
                imageView.image = IMG(tabGabLine);
                [self addSubview:imageView];
                [imageView release];
            }

            
            if (i==0) {
                indexSel = 0;
//                btn.frame = CGRectMake(Xoff+i*(KdapW + KTabBtnW), 0, KTabBtnW, KSelWidth);
//                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"tabSelNew.png"] forState:UIControlStateNormal];

            }else{
//                [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"tabUnSelNull.png"] forState:UIControlStateNormal];

            
            }
            [btn addTarget:self action:@selector(toucheTabViewEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [btnArray addObject:btn];
        }
        
    }
    return self;
}
- (void)toucheTabViewEvent:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int index = btn.tag;
    for (int i = 0; i < [btnArray count]; i++) {
        UIButton *btnTemp = (UIButton*)[btnArray objectAtIndex:i];
        if (btnTemp) {
            if (i==index) {
//                btnTemp.frame = CGRectMake(Xoff+i*(KdapW + KTabBtnW), 0, KTabBtnW, KSelWidth);
//                [btnTemp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnTemp setBackgroundImage:[UIImage imageNamed:@"tabSelNew.png"] forState:UIControlStateNormal];
            }else{
//                btnTemp.frame = CGRectMake(Xoff+i*(KdapW + KTabBtnW), KSelWidth - KUnselHeiht, KTabBtnW, KUnselHeiht);
//                [btnTemp setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                [btnTemp setBackgroundImage:[UIImage imageNamed:@"tabUnSelNull.png"] forState:UIControlStateNormal];
            }
        }

    }

    if ([delegate respondsToSelector:@selector(changeTabClike:)]) {
        indexSel = index;
        [delegate changeTabClike:index];
    }
    


}
- (void)setIndex:(int)tagDex
{
    for (int i = 0; i < [btnArray count]; i++) {
        UIButton *btnTemp = (UIButton*)[btnArray objectAtIndex:i];
        if (btnTemp) {
            if (i==tagDex) {
//                btnTemp.frame = CGRectMake(Xoff+i*(KdapW + KTabBtnW), 0, KTabBtnW, KSelWidth);
//                [btnTemp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnTemp setBackgroundImage:[UIImage imageNamed:@"tabSelNew.png"] forState:UIControlStateNormal];
            }else{
//                btnTemp.frame = CGRectMake(Xoff+i*(KdapW + KTabBtnW), KSelWidth - KUnselHeiht, KTabBtnW, KUnselHeiht);
//                [btnTemp setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                [btnTemp setBackgroundImage:[UIImage imageNamed:@"tabUnSelNull.png"] forState:UIControlStateNormal];
            }
        }
        
    }
    indexSel = tagDex;

}
-(void)dealloc
{
    [dataTitle release];
    [btnArray release];
    [super dealloc];
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
