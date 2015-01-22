
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#include <regex.h>

@interface  NSString(Extras)

+(id) tryStringWithCString:(const char*)cString encoding:(NSStringEncoding)enc;
-(NSString*) stringWithPercentEscape;
-(NSString*) MD5Hash;

+(NSString*) TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key;
-(NSString*) TripleDES;

-(NSArray*) substringsMatchingRegularExpression:(NSString*)pattern count:(int)nmatch options:(int)options ranges:(NSArray**)ranges error:(NSError**)error;
-(BOOL) grep:(NSString*)pattern options:(int)options;
-(NSMutableArray*) substringByRegular:(NSString*)regular;

-(float) getWidth:(UIFont*)font limit:(float)limit; // if limit=0 means no limit

//-(NSString*) getCurArriveTime;
//-(NSString*) getCurArriveTime_2;
-(int) getStringNumber;

-(NSString*) UnicodeToGB2312;
-(NSString*) encodeToPercentEscapeString;
-(NSString*) URLDecodedString;

-(NSString*) append:(NSString*)str;
-(NSString*) subString:(NSString*)beginStr;
-(NSString*) beforeString:(NSString*)beginStr;

@end
