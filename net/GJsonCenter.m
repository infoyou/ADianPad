
#import "GJsonCenter.h"
#import "Reachability.h"
#import "JsonNetManager.h"
#import "JsonNetManager2.h"
#import "GDefine.h"
#import "NSString_Extras.h"
#import "ADAppDelegate.h"

#define RETURN_DICT(cmd) return [GJsonCenter getJsonRequest:@"" #cmd "" withData:data jsonDelegate:delegate];
#define RETURN_DICT_ID(cmd,cid) return [GJsonCenter getJsonRequest:@"" #cmd "" customid:cid withData:data jsonDelegate:delegate];
#define RETURN_DICT2(cmd) return [GJsonCenter getJsonRequest:@"" #cmd "" withData:data];
#define RETURN_DICT_ID2(cmd,cid) return [GJsonCenter getJsonRequest:@"" #cmd "" customid:cid withData:data];

@implementation GJsonCenter

+(JsonRequestItem*) getJsonRequest:(NSString*)cmd withData:(NSDictionary*)data JSON_DELEGATE
{
    return [JsonManager requestJson:data type:cmd jsonDelegate:delegate];
}

+(JsonRequestItem*) getJsonRequest:(NSString*)cmd customid:(NSString*)customid withData:(NSDictionary*)data JSON_DELEGATE
{
    return [JsonManager requestJson:data type:cmd customid:customid jsonDelegate:delegate];
}

+(JsonRequestItem*) User_Login_Phone:(NSString*)phone password:(NSString*)password JSON_DELEGATE
{
    NSDictionary* data=[NSDictionary dictionaryWithObjectsAndKeys:phone,@"login_name", password,@"password", nil];
    RETURN_DICT(wuadian_pad_login);
}

+(JsonRequestItem*) wuADianPadGetCustomerInfo:(NSString *)offset num:(NSString *)numString JSON_DELEGATE
{
    NSDictionary* data=[NSDictionary dictionaryWithObjectsAndKeys:offset,@"offset", numString,@"num",@[@"2",@"10"],@"status", nil];
    RETURN_DICT(wuadian_pad_getcustomerinfo);
    
}
+(JsonRequestItem*) wuAdian_member_get_shoppingCarList:(NSString *)offset num:(NSString *)numString cartType:(NSString *)cartTypeString JSON_DELEGATE
{
    NSDictionary* data=[NSDictionary dictionaryWithObjectsAndKeys:offset,@"offset", numString,@"num",cartTypeString,@"cart_type", nil];
    RETURN_DICT(wuadian_member_getshoppingcartlist);
    
}
+(JsonRequestItem*) wuAdian_member_getfavoriteslist:(NSString *)offset num:(NSString *)numString JSON_DELEGATE
{
    NSDictionary* data=[NSDictionary dictionaryWithObjectsAndKeys:offset,@"offset", numString,@"num", nil];
    RETURN_DICT(wuadian_member_getfavoriteslist);
    
}
+(JsonRequestItem*) wuAdian_member_getbrowsehistorylist:(NSString *)offset num:(NSString *)numString JSON_DELEGATE
{
    NSDictionary* data=[NSDictionary dictionaryWithObjectsAndKeys:offset,@"offset", numString,@"num", nil];
    RETURN_DICT(wuadian_member_getbrowsehistorylist);
    
    
}

+(JsonRequestItem*) wuAdian_pad_scanlist:(NSString *)offset num:(NSString *)numString store_id:(NSString *)sid JSON_DELEGATE
{
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:offset,@"offset", numString,@"num", sid,@"store_id", nil];
    RETURN_DICT(wuadian_pad_scanlist);
}

+(JsonRequestItem *) wuadian_message_getcontactlist:(NSString *)server_id offset:(NSString *)offset num:(NSString *)num JSON_DELEGATE
{
    NSDictionary* data=[NSDictionary dictionaryWithObjectsAndKeys:server_id,@"server_id",offset,@"offset", num,@"num", nil];
    RETURN_DICT(wuadian_message_getcontactlist);
}

+(JsonRequestItem *)wuadian_message_send:(NSString *)corporation_member_id message_id:(NSString *)message_id open_id:(NSString *)open_id content:(NSString *)content JSON_DELEGATE
{
    NSDictionary* data=[NSDictionary dictionaryWithObjectsAndKeys:corporation_member_id,@"corporation_member_id",message_id,@"message_id",open_id,@"open_id",content,@"content",  nil];
    RETURN_DICT(wuadian_message_send);
}

+(JsonRequestItem *)wuadian_message_getconversationlist:(NSString*)offset num:(NSString *)numString server_id:(NSString *)server_id_str member_id:(NSString *)member_id open_id:(NSString *)open_id JSON_DELEGATE
{
    NSDictionary* data=[NSDictionary dictionaryWithObjectsAndKeys:server_id_str,@"server_id",member_id,@"member_id",open_id,@"open_id",offset,@"offset", numString,@"num", nil];
    RETURN_DICT(wuadian_message_getconversation);
    
}

+(JsonRequestItem*) wuAdian_order_getdeffstatueorderlist:(NSString *)offset num:(NSString *)numString orderType:(NSString *)orderTypeString status:(NSArray *)statuArray cid:(NSString*)cidString JSON_DELEGATE
{
    NSDictionary* data=[NSDictionary dictionaryWithObjectsAndKeys:offset,@"offset", numString,@"num",orderTypeString,@"order_type",statuArray,@"status", nil];
    RETURN_DICT_ID(wuadian_order_getdeffstatusorders,cidString);
}

+(JsonRequestItem*) WuAdian_order_experience:(NSArray *)arrayData JSON_DELEGATE
{
    
    NSDictionary* data=[NSDictionary dictionaryWithObjectsAndKeys:arrayData,@"order_detail_ids", nil];
    RETURN_DICT(wuadian_order_experience);
}

+(JsonRequestItem*) wuAdian_pad_cartexperience:(NSArray*)arrayData JSON_DELEGATE
{
    NSDictionary* data=[NSDictionary dictionaryWithObjectsAndKeys:arrayData,@"carts", nil];
    RETURN_DICT(wuadian_pad_cartexperience);
}

+(JsonRequestItem*) wuAdian_pad_createorder:(NSArray *)dataArray delivery_mode:(NSString *)delivery_mode_string pay_type:(NSString *)pay_type_string store_id:(NSString *)store_id_string delivery_info:(NSDictionary *)dicInfo JSON_DELEGATE
{
    NSDictionary* data=[NSDictionary dictionaryWithObjectsAndKeys:dataArray,@"skus",
                        delivery_mode_string,@"delivery_mode",
                        pay_type_string,@"pay_type",
                        store_id_string,@"store_id",
                        dicInfo,@"delivery_info",
                        nil];
    RETURN_DICT(wuadian_pad_createorder);
    
}

@end
