//
//  ADCustomerCell.m
//  ADianTaste
//
//  Created by 陈 超 on 14-5-5.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADCustomerCell.h"
#import "GView.h"
#import "GDefine.h"
#import "UIView_Extras.h"
#import "GImageView.h"

@implementation ADCustomerCell
@synthesize isYes;
@synthesize delegate;
- (CGSize)getString:(NSString *)string fontNum:(float)fontNum
{
    UIFont *font = [UIFont systemFontOfSize:fontNum];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 12.0)];
    return size;
    
}

-(GView*) createCell{
    GView* view=[[GView alloc] initWithFrame:CGRectMake(0, 0,  240.0, [self getCellHeight])];
    view.backgroundColor = [UIColor colorWithRed:21.0/255.0 green:93.0/255.0 blue:170.0/255.0 alpha:1.0];
    back = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 240, [self getCellHeight])];
    back.image= IMG(chat_customer_cell_sel);
    if (isYes) {
        back.hidden = YES;
    }else{
        back.hidden = NO;
    }
    [view addSubview:back];
    
    
    GImageView *headImage = [[GImageView alloc]initWithFrame:CGRectMake(10.0, 10.0, 46.0, 46.0)];
    [headImage loadImage:[[cellData objectForKey:@"member_summary"] objectForKey:@"thumbnail_url"] defalutImage:IMG(peoplo_default)];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 5.0;
    [view addSubview:headImage];
    [headImage release];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.6, 10.0, 240.0-66-10.0, 24.0)];
    nameLabel.text = [[cellData objectForKey:@"member_summary"] objectForKey:@"nick_name"];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:20.0];
    [view addSubview:nameLabel];
    [nameLabel release];
    
    UIImageView *imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(66.0, 34.0, 18.0, 18.0)];
    imageIcon.image = IMG(chat_icon2);
    [view addSubview:imageIcon];
    [imageIcon release];
    
    UILabel *left_rect = [[UILabel alloc]initWithFrame:CGRectMake(66.0+24.0, 32.0, 20.0, 20.0)];
    left_rect.textColor = [UIColor whiteColor];
    left_rect.backgroundColor = [UIColor clearColor];
    left_rect.text = @"(";
    left_rect.textAlignment = NSTextAlignmentLeft;
    left_rect.font = [UIFont systemFontOfSize:18.0];
    [view addSubview:left_rect];
    [left_rect release];
    
    CGSize size = [self getString:[cellData objectForKey:@"unread_count"] fontNum:18.0];
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(66.0+24.0+6.0,32.0 , size.width, 20.0)];
    numLabel.text = [cellData objectForKey:@"unread_count"];
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.textColor = [UIColor colorWithRed:223.0/255.0 green:118.0/255.0 blue:37.0/255.0 alpha:1.0];
    numLabel.font = [UIFont systemFontOfSize:18.0];
    numLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:numLabel];
    [numLabel release];
    
    UILabel *right_rect = [[UILabel alloc]initWithFrame:CGRectMake(66.0+24.0+6.0+size.width+1.0, 32.0, 20.0, 20.0)];
    right_rect.textColor = [UIColor whiteColor];
    right_rect.backgroundColor = [UIColor clearColor];
    right_rect.text = @")";
    right_rect.textAlignment = NSTextAlignmentLeft;
    right_rect.font = [UIFont systemFontOfSize:18.0];
    [view addSubview:right_rect];
    [right_rect release];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, [self getCellHeight]-1.0,240.0 , 1.0)];
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.alpha = 0.2;
    [view addSubview:lineView];
    [lineView release];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 240.0, [self getCellHeight]);
    [btn addTarget:self action:@selector(clickSelfEvent) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return  view;

}
- (void)hiddenBack:(BOOL)isHidden
{
    back.hidden = isHidden;
    isYes = isHidden;
}
-(void)clickSelfEvent
{
    if ([delegate respondsToSelector:@selector(clikeCustomerCellId:open_id:)]) {
        [delegate clikeCustomerCellId:[[cellData objectForKey:@"member_summary"] objectForKey:@"member_id"]open_id:[cellData objectForKey:@"open_id"]];
    }



}
-(int) getCellHeight
{
    return 66.0;
}

-(void)dealloc
{
    [back release];
    [super dealloc];
}
@end
