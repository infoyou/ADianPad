
#import <Foundation/Foundation.h>

@interface GUtil : NSObject

+(NSString*) getJsonServerUrl;
+(NSString*) getUserAgent;

+(NSData*) dataBase64:(NSData*)theData;

+(void) setInfo:(id)value withKey:(NSString*)key;
+(void) removeInfo:(NSString*)key;
+(id) getInfo:(NSString*)key;

+(void) setInfoWithUid:(id)value withKey:(NSString*)key;
+(void) removeInfoWithUid:(NSString*)key;
+(id) getInfoWithUid:(NSString*)key;

+(UIAlertView*) alert:(NSString*)str;
+(void) removeFile:(NSString*)filename;

+(NSString*) getUUID;
+(NSString*) getCachePath:(NSString*)name;
+(NSString*) getDocPath:(NSString*)name;
+(BOOL)phoneNumCheck:(NSString*)phone;
+(NSString*)processPhoneNumber:(NSString*)input trimOrAppend:(BOOL)trimsuffix;
+(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

+(void) markNow;
+(void) logPassTime;

+(void) initFlowData;
+(void) addFlow:(double)flowRate;
+(void) addFlow2:(double)flowRate;
+(double) getFlowDataWithDay:(int)before;
+(double) getFlowDataWithMonth;
+(double) getFlowDataWithDay2:(int)before;
+(double) getFlowDataWithMonth2;
+(void) clearFlowData;

+(NSString *) getTimeIntervalFrom1970:(NSString*)timeStr;
+(NSDate*) getDateFrom1970:(NSString*)timestr;
+(NSDate*) getDateFromStandTime:(NSString*)timestr;
@end


