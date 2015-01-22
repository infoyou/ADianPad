
@protocol JsonRequestDelegate;

@class JsonRequestItem;
@class JsonRequestItem2;

#define JSON_DELEGATE jsonDelegate:(id<JsonRequestDelegate>)delegate

@interface GJsonCenter : NSObject 


+(JsonRequestItem*) User_Login_Phone:(NSString*)phone password:(NSString*)password JSON_DELEGATE;
+(JsonRequestItem*) wuADianPadGetCustomerInfo:(NSString *)offset num:(NSString *)numString JSON_DELEGATE;
//预约体验车接口：
+(JsonRequestItem*) wuAdian_member_get_shoppingCarList:(NSString *)offset num:(NSString *)numString cartType:(NSString *)cartTypeString JSON_DELEGATE;
+(JsonRequestItem*) wuAdian_member_getfavoriteslist:(NSString *)offset num:(NSString *)numString JSON_DELEGATE;
+(JsonRequestItem*) wuAdian_member_getbrowsehistorylist:(NSString *)offset num:(NSString *)numString JSON_DELEGATE;
+(JsonRequestItem*) wuAdian_pad_scanlist:(NSString *)offset num:(NSString *)numString store_id:(NSString *)sid JSON_DELEGATE;
+(JsonRequestItem*) wuAdian_order_getdeffstatueorderlist:(NSString *)offset num:(NSString *)numString orderType:(NSString *)orderTypeString status:(NSArray *)statuArray cid:(NSString*)cidString JSON_DELEGATE;
+(JsonRequestItem*) WuAdian_order_experience:(NSArray *)arrayData JSON_DELEGATE;
+(JsonRequestItem*) wuAdian_pad_cartexperience:(NSArray*)arrayData JSON_DELEGATE;
+(JsonRequestItem*) wuAdian_pad_createorder:(NSArray *)dataArray delivery_mode:(NSString *)delivery_mode_string pay_type:(NSString *)pay_type_string store_id:(NSString *)store_id_string delivery_info:(NSDictionary *)dicInfo JSON_DELEGATE;
+(JsonRequestItem *) wuadian_message_getcontactlist:(NSString *)server_id offset:(NSString *)offset num:(NSString *)num JSON_DELEGATE;
+(JsonRequestItem *)wuadian_message_getconversationlist:(NSString*)offset num:(NSString *)numString server_id:(NSString *)server_id_str member_id:(NSString *)member_id open_id:(NSString *)open_id JSON_DELEGATE;
+(JsonRequestItem *)wuadian_message_send:(NSString *)corporation_member_id message_id:(NSString *)message_id open_id:(NSString *)open_id content:(NSString *)content JSON_DELEGATE;

@end
