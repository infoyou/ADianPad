//
//  ADBarVIew.m
//  ADianTaste
//
//  Created by Keil on 14-3-4.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADBarVIew.h"
#import "GDefine.h"
#define KSelImageKey @"SelImage"
#define KUnSelImadeKey @"UnselImage"
#define KTitleImageKey @"TitleKey"

@implementation ADBarVIew

@synthesize delegate;
@synthesize flagIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        arrayData = [[NSMutableArray alloc] initWithObjects:
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:@"iconPeoploSel.png", KSelImageKey,
                      @"iconPeoplo.png",KUnSelImadeKey,@"在线购物",KTitleImageKey,nil],
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:@"iconPeoploSel.png", KSelImageKey,@"iconPeoplo.png",KUnSelImadeKey,LTXT(TKN_BAR_KEFU),KTitleImageKey,nil],
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:@"iconTimeSel.png", KSelImageKey,@"iconTime.png",KUnSelImadeKey,LTXT(TKN_BAR_HISTORY),KTitleImageKey,nil],
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:@"iconSetSel.png",
                         KSelImageKey,@"iconSet.png",KUnSelImadeKey,LTXT(TKN_BAR_SET_TITLE),KTitleImageKey,nil],
                     nil];
        
        self.backgroundColor = KBarBackColor;
        [self barView];
        flagIndex = 0;
    }
    
    return self;
}

- (CGSize)getString:(NSString *)string fontNum:(float)fontNum
{
    UIFont *font = [UIFont systemFontOfSize:fontNum];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(160, MAXFLOAT)];
    return size;
}

- (void)barView
{

    // Back
    UIImageView *reBack = [[UIImageView alloc]initWithFrame:CGRectMake(10, ios7H+(KBarWidthF-18)/2.0, 18, 18)];
    reBack.image = IMG(iconBack);
    [self addSubview:reBack];
    [reBack release];
    
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(12+18, ios7H+(KBarWidthF-20)/2.0, 50, 20)];
    backLabel.font = [UIFont systemFontOfSize:20.0];
    backLabel.text = LTXT(TKN_BACK_TITLE);
    backLabel.backgroundColor = [UIColor clearColor];
    backLabel.textColor = [UIColor whiteColor];
    [self addSubview:backLabel];
    [backLabel release];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.showsTouchWhenHighlighted = YES;
    backBtn.frame = CGRectMake(10, ios7H+(KBarWidthF-40)/2.0, 78.0, 40.0);
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    // Refresh
    UIImageView *reFresh = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenHeight/2.0-140, ios7H+(KBarWidthF-18)/2.0, 18, 18)];
    reFresh.image = IMG(iconRefresh);
    [self addSubview:reFresh];
    [reFresh release];
    CGSize freshSize = [self getString:LTXT(TKN_BAR_REFRESH) fontNum:20.0];
    UILabel *freshLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenHeight/2.0-120, ios7H+(KBarWidthF-20)/2.0, freshSize.width, 20)];
    freshLabel.font = [UIFont systemFontOfSize:20.0];
    freshLabel.text = LTXT(TKN_BAR_REFRESH);
    freshLabel.backgroundColor = [UIColor clearColor];
    freshLabel.textColor = [UIColor whiteColor];
    [self addSubview:freshLabel];
    [freshLabel release];
    
    UIButton *freshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    freshBtn.frame = CGRectMake(KScreenHeight/2.0-120, ios7H+(KBarWidthF-40)/2.0, freshSize.width+20.0, 40.0);
    freshBtn.showsTouchWhenHighlighted = YES;
//    freshBtn.backgroundColor = [UIColor redColor];
    [freshBtn addTarget:self action:@selector(refreshClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:freshBtn];
    
    //
    for (int i = 0; i < [arrayData count]; i++) {
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenHeight/2.0-120.0+freshSize.width+i*160, ios7H+(KBarWidthF-18)/2.0, 18, 18)];
        image.tag = 200+i;
        image.image = [UIImage imageNamed:[[arrayData objectAtIndex:i] objectForKey:KUnSelImadeKey]];
        [self addSubview:image];
        [image release];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(image.frame.origin.x+20, ios7H+(KBarWidthF-20)/2.0, 140, 20)];
        label.tag = 100+i;
        label.font = [UIFont systemFontOfSize:20.0];
        label.text = [[arrayData objectAtIndex:i] objectForKey:KTitleImageKey];
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        [label release];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(KScreenHeight/2.0-25+78.0+i*160, ios7H+(KBarWidthF-40)/2.0, 140, 40.0);
        button.tag = i;
//        button.backgroundColor = [UIColor redColor];
        [button addTarget:self action:@selector(clickBar:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        switch (i) {
            case 0:
            {
                image.frame = CGRectMake(KScreenHeight/2.0-120+freshSize.width+20.0+10.0, ios7H+(KBarWidthF-18)/2.0, 18, 18);
                label.frame = CGRectMake(image.frame.origin.x+20, ios7H+(KBarWidthF-20)/2.0, 140, 20);
                button.frame = CGRectMake(KScreenHeight/2.0-120+freshSize.width+20.0, ios7H+(KBarWidthF-40)/2.0, 120, 40.0);
//                button.backgroundColor = [UIColor redColor];

            }
                break;
            case 1:
            {
                CGSize size1 = [self getString:[[arrayData objectAtIndex:0] objectForKey:KTitleImageKey] fontNum:20.0];
                CGSize size2 = [self getString:[[arrayData objectAtIndex:1] objectForKey:KTitleImageKey] fontNum:20.0];
                image.frame = CGRectMake(KScreenHeight/2.0-120+freshSize.width+20.0+10.0+size1.width+20.0+10.0, ios7H+(KBarWidthF-18)/2.0, 10, 18);
                label.frame = CGRectMake(image.frame.origin.x+20, ios7H+(KBarWidthF-20)/2.0, size2.width, 20);
                button.frame = CGRectMake(image.frame.origin.x+20, ios7H+(KBarWidthF-40)/2.0,  size2.width , 40.0);
//                button.backgroundColor = [UIColor greenColor];

            }
                break;
            case 2:
            {
                CGSize size1 = [self getString:[[arrayData objectAtIndex:0] objectForKey:KTitleImageKey] fontNum:20.0];
                CGSize size2 = [self getString:[[arrayData objectAtIndex:1] objectForKey:KTitleImageKey] fontNum:20.0];
                CGSize size3 = [self getString:[[arrayData objectAtIndex:2] objectForKey:KTitleImageKey] fontNum:20.0];
                image.frame = CGRectMake(KScreenHeight/2.0-120+freshSize.width+20.0+10.0+size1.width+20.0+10.0+size2.width+30.0, ios7H+(KBarWidthF-18)/2.0, 18, 18);
                label.frame = CGRectMake(image.frame.origin.x+20, ios7H+(KBarWidthF-20)/2.0, size3.width, 20);
                button.frame = CGRectMake(image.frame.origin.x, ios7H+(KBarWidthF-40)/2.0,  size3.width + 20.0, 40.0);
//                button.backgroundColor = [UIColor yellowColor];

            }
                break;
            case 3:
            {
                CGSize size1 = [self getString:[[arrayData objectAtIndex:0] objectForKey:KTitleImageKey] fontNum:20.0];
                CGSize size2 = [self getString:[[arrayData objectAtIndex:1] objectForKey:KTitleImageKey] fontNum:20.0];
                CGSize size3 = [self getString:[[arrayData objectAtIndex:2] objectForKey:KTitleImageKey] fontNum:20.0];
                CGSize size4 = [self getString:[[arrayData objectAtIndex:3] objectForKey:KTitleImageKey] fontNum:20.0];
                image.frame = CGRectMake(KScreenHeight/2.0-120+freshSize.width+20.0+10.0+size1.width+20.0+10.0+size2.width+30.0+size3.width+30.0, ios7H+(KBarWidthF-18)/2.0, 18, 18);
                label.frame = CGRectMake(image.frame.origin.x+20, ios7H+(KBarWidthF-20)/2.0, size4.width, 20);
                button.frame = CGRectMake(image.frame.origin.x, ios7H+(KBarWidthF-40)/2.0,  size4.width + 20.0, 40.0);
//                button.backgroundColor = [UIColor whiteColor];

            }
                break;
            default:
                break;
        }
    }
}

- (void)clickBar:(id)sender
{
    @synchronized (self){
    
        UIButton *btn = (UIButton *)sender;
        int index = btn.tag;
        
        for (int i=0; i<[arrayData count]; i++) {
            UIImageView *image = (UIImageView *)[self viewWithTag:200+i];
            if (i==index&&i!=3) {
                image.image = [UIImage imageNamed:[[arrayData objectAtIndex:i] objectForKey:KSelImageKey]];
            }else{
                image.image = [UIImage imageNamed:[[arrayData objectAtIndex:i] objectForKey:KUnSelImadeKey]];
                
            }
            UILabel *label = (UILabel *)[self viewWithTag:100+i];
            if (i==index&&i!=3) {
                label.textColor = [UIColor blackColor];
            }else{
                label.textColor = [UIColor whiteColor];
                
            }
        }
        if ([delegate respondsToSelector:@selector(changeClikeEvent:)]) {
            [delegate changeClikeEvent:index];
        }
        flagIndex = index+1;
    }


}
- (void)refreshClick
{
    for (int i=0; i<[arrayData count]; i++) {
        UIImageView *image = (UIImageView *)[self viewWithTag:200+i];
        if (image) {
            image.image = [UIImage imageNamed:[[arrayData objectAtIndex:i] objectForKey:KUnSelImadeKey]];
        }
        UILabel *label = (UILabel *)[self viewWithTag:100+i];
        if (label) {
            label.textColor = [UIColor whiteColor];
        }
    }
    
    flagIndex = 0;
    if ([delegate respondsToSelector:@selector(barViewRefreshEvent)]) {
        [delegate barViewRefreshEvent];
    }
}

- (void)backClick {

    for (int i=0; i<[arrayData count]; i++) {
        UIImageView *image = (UIImageView *)[self viewWithTag:200+i];
        if (image) {
            image.image = [UIImage imageNamed:[[arrayData objectAtIndex:i] objectForKey:KUnSelImadeKey]];

        }
        UILabel *label = (UILabel *)[self viewWithTag:100+i];
        if (label) {
            label.textColor = [UIColor whiteColor];
        }

    }
    flagIndex = 0;
    if ([delegate respondsToSelector:@selector(barViewBackEvent)]) {
        [delegate barViewBackEvent];
    }
}

- (void)resumeView
{
    
    for (int i=0; i<[arrayData count]; i++) {
        UIImageView *image = (UIImageView *)[self viewWithTag:200+i];
        if (image) {
            image.image = [UIImage imageNamed:[[arrayData objectAtIndex:i] objectForKey:KUnSelImadeKey]];
            
        }
        UILabel *label = (UILabel *)[self viewWithTag:100+i];
        if (label) {
            label.textColor = [UIColor whiteColor];
        }
        
    }
    flagIndex = 0;


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
    [arrayData release];
    [super dealloc];
}
@end
