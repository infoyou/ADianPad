//
//  ADSessionInfo.h
//  ADianTaste
//
//  Created by Keil on 14-3-4.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADSessionInfo : NSObject
{
    NSString *corporation_member_id;//操作员id
    NSString *corporation_id;//商户id
    NSString *store_id;//门店id
    NSString *nick_name;//操作员姓名
    NSString *store_name;//门店名称
    NSString *store_address;//门店地址
    NSString *store_telephone;//门店电话
    NSString *store_mobilephone;//门店手机
    //二维码信息:
    NSString *qrcode_url;//二维码缩略图
    NSString *scene_id;//场景id(轮询)
    NSString *creat_time;//创建时间(轮询)
    NSString *qrcode_type;//二维码类型
    
    NSString *member_id_string;


}
@property (nonatomic,retain)NSString *corporation_member_id;
@property (nonatomic,retain)NSString *corporation_id;
@property (nonatomic,retain)NSString *store_id;
@property (nonatomic,retain)NSString *nick_name;
@property (nonatomic,retain)NSString *store_name;
@property (nonatomic,retain)NSString *store_address;
@property (nonatomic,retain)NSString *store_telephone;
@property (nonatomic,retain)NSString *store_mobilephone;


@property (nonatomic,retain)NSString *qrcode_url;
@property (nonatomic,retain)NSString *scene_id;
@property (nonatomic,retain)NSString *creat_time;
@property (nonatomic,retain)NSString *qrcode_type;

@property (nonatomic,retain)NSString *member_id_string;
+ (ADSessionInfo *)sharedSessionInfo;
@end
