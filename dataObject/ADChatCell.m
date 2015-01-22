//
//  ADChatCell.m
//  ADianTaste
//
//  Created by 陈 超 on 14-5-5.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADChatCell.h"
#import "GView.h"
#import "GDefine.h"
#import "UIView_Extras.h"
#import "GImageView.h"

@implementation ADChatCell
@synthesize isSelfUser;
- (CGSize)getString:(NSString *)string fontNum:(float)fontNum
{
    float w = 250.0;
    if (isSelfUser) {
        w = 250.0;
    }else{
        w = 300.0;

    }

    UIFont *font = [UIFont systemFontOfSize:fontNum];
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(w, MAXFLOAT)];
    return size;
    
}
-(GView*) createCell{
    GView* view=[[GView alloc] initWithFrame:CGRectMake(0, 0,  520.0, [self getCellHeight])];
    view.backgroundColor =  [UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0];
    NSString *str = nil;
    if ([[cellData objectForKey:@"content"] isKindOfClass:[NSString class]]) {
        str = [cellData objectForKey:@"content"];
    }else{
        str = @"";
    }
    CGSize size = [self getString:str  fontNum:18.0];
    UIImageView *labelImage = [[UIImageView alloc]initWithFrame:CGRectMake(60.0, 15.0, size.width+20.0, size.height+10.0)];
    if (isSelfUser==NO) {
        labelImage.frame = CGRectMake(520.0-60.0-(size.width+20.0), 15.0, size.width+20.0, size.height+10.0);
    }
    if (isSelfUser==NO) {
        labelImage.image = [[UIImage imageNamed:@"customer_chat_back.png"] stretchableImageWithLeftCapWidth:20.0 topCapHeight:5.0];

    }else{
    
        labelImage.image = [[UIImage imageNamed:@"s_user_chat_back.png"] stretchableImageWithLeftCapWidth:20.0 topCapHeight:5.0];

    }
    [view addSubview:labelImage];
    [labelImage release];
        
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.0, 5.0, size.width, size.height)];
    if (isSelfUser==NO) {
        contentLabel.frame = CGRectMake(5.0, 5.0, size.width, size.height);
    }
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:18.0];
    contentLabel.numberOfLines = 0;
    contentLabel.text =str ;
    [labelImage addSubview:contentLabel];
    [contentLabel release];
        
    GImageView *headImage = [[GImageView alloc]initWithFrame:CGRectMake(10.0, size.height-15.0, 46.0, 46.0)];
    if (isSelfUser==NO) {
        headImage.frame = CGRectMake(520.0-46.0-10.0, size.height-15.0, 46.0, 46.0);
    }
    if ([[cellData objectForKey:@"fromuser"] isEqualToString:@"1"]) {
        [headImage loadImage:[[cellData objectForKey:@"sender_summary"] objectForKey:@"thumbnail_url"] defalutImage:IMG(peoplo_default)];

    }else{
        [headImage loadImage:nil defalutImage:IMG(peoplo_default)];

    }
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 5.0;
    [view addSubview:headImage];
    [headImage release];
    
    return view;

}
-(int) getCellHeight
{
    float height = 0;
    NSString *str = nil;
    if ([[cellData objectForKey:@"content"] isKindOfClass:[NSString class]]) {
        str = [cellData objectForKey:@"content"];
    }else{
        str = @"";
    }
    CGSize size = [self getString:str  fontNum:18.0];
    height +=size.height;
    height += 15.0 +10.0+15.0;
    return height;
}
-(void)dealloc
{
    [super dealloc];
}
@end
