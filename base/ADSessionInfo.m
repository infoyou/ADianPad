//
//  ADSessionInfo.m
//  ADianTaste
//
//  Created by Keil on 14-3-4.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADSessionInfo.h"
static ADSessionInfo *sessionInfo = nil;
@implementation ADSessionInfo
@synthesize corporation_member_id,corporation_id,store_id,nick_name,store_name,store_address,store_telephone,store_mobilephone,qrcode_url,scene_id,creat_time,qrcode_type;
@synthesize member_id_string;

+ (ADSessionInfo *)sharedSessionInfo
{
    @synchronized(self){
    
        if (sessionInfo == nil) {
            sessionInfo = [[ADSessionInfo alloc] init];
        }
        return sessionInfo;
    }

}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (sessionInfo == nil)
        {
            sessionInfo = [super allocWithZone:zone];
            return  sessionInfo;
        }
    }
    
    return  nil;
}

- (void)dealloc
{
    [super dealloc];
}

@end
