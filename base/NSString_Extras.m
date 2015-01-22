
#import "NSString_Extras.h"
#import "CommonCrypto/CommonDigest.h"
#import "GTMBase64.h"
#import "GDefine.h"
#import "ADAppDelegate.h"

@implementation NSString(Extras)

+(id) tryStringWithCString:(const char*)cString encoding:(NSStringEncoding)enc
{
	if(cString)
	{
		return [NSString stringWithCString:cString encoding:enc];
	}
	else
	{
		return @"";
	}
}

-(NSString*) stringWithPercentEscape
{            
    return [(NSString*) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),kCFStringEncodingUTF8) autorelease];
}

-(NSString*) MD5Hash
{
    const char* cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
	
    CC_MD5( cStr, strlen(cStr), result );
	
    return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

#define KDesKey @"fddd5cf10529164eae7b0eef"
-(NSString*) TripleDES
{
    return [NSString TripleDES:self encryptOrDecrypt:kCCEncrypt key:KDesKey];
}

+(NSString*) TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if(encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void*)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void*)bufferPtr, 0x0, bufferPtrSize);
    // memset((void*) iv, 0x0, (size_t) sizeof(iv));
    
    NSString *initVec = nil;
    const void *vkey = (const void*) [key UTF8String];
    const void *vinitVec = (const void*) [initVec UTF8String];
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding|kCCOptionECBMode,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void*)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    if(ccStatus == kCCSuccess) ;//NSLog(@"SUCCESS");
    else
    {
        NSString* str=nil;
        
        if(ccStatus == kCCParamError) str=@"PARAM ERROR";
        else if(ccStatus == kCCBufferTooSmall) str=@"BUFFER TOO SMALL";
        else if(ccStatus == kCCMemoryFailure) str=@"MEMORY FAILURE";
        else if(ccStatus == kCCAlignmentError) str=@"ALIGNMENT";
        else if(ccStatus == kCCDecodeError) str=@"DECODE ERROR";
        else if(ccStatus == kCCUnimplemented) str=@"UNIMPLEMENTED";
        
        if(str!=nil)
        {
            free(bufferPtr);
            return str;
        }
    }
    
    NSString *result;
    
    if(encryptOrDecrypt == kCCDecrypt)
    {
        result = [[[NSString alloc] initWithData:[NSData dataWithBytes:(const void*)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding] autorelease];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void*)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    free(bufferPtr);
    return result;
}

-(NSArray*) substringsMatchingRegularExpression:(NSString*)pattern count:(int)nmatch options:(int)options ranges:(NSArray**)ranges error:(NSError**)error
{
	NSLog(@"NSString_RegEx - substringsMatchingRegularExpression");
	
	options |= REG_EXTENDED;
	if(error)
		*error = nil;
    
	int errcode = 0;
	regex_t preg;
	regmatch_t * pmatch = NULL;
	NSMutableArray * outMatches = nil;
	
	// Compile the regular expression
	errcode = regcomp(&preg, [pattern UTF8String], options);
	if(errcode != 0)
		goto catch_error;	// regcomp error
	
	// Match the regular expression against substring self
	pmatch = calloc(sizeof(regmatch_t), nmatch+1);
	errcode = regexec(&preg, [self UTF8String], (nmatch<0 ? 0 : nmatch+1), pmatch, 0);
    
	if(errcode != 0)
		goto catch_error;	// regexec error
    
	if(nmatch == -1)
	{
		outMatches = [NSArray arrayWithObject:self];
		goto catch_exit;	// simple match
	}
    
	// Iterate through pmatch
	outMatches = [NSMutableArray array];
	if(ranges)
		*ranges = [NSMutableArray array];
	int i;
	for (i=0; i<nmatch+1; i++)
	{
		if(pmatch[i].rm_so == -1 || pmatch[i].rm_eo == -1)
			break;
        
		NSRange range = NSMakeRange(pmatch[i].rm_so, pmatch[i].rm_eo - pmatch[i].rm_so);
		NSString * substring = [self substringWithRange:range];
		[outMatches addObject:substring];
        
		if(ranges)
		{
			NSValue * value = [NSValue valueWithRange:range];
			[(NSMutableArray*)*ranges addObject:value];
		}
	}
    
catch_error:
	if(errcode != 0 && error)
	{
		// Construct error object
		NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
		char errbuf[256];
		int len = regerror(errcode, &preg, errbuf, sizeof(errbuf));
		if(len > 0)
			[userInfo setObject:[NSString stringWithUTF8String:errbuf] forKey:NSLocalizedDescriptionKey];
		*error = [NSError errorWithDomain:@"regerror" code:errcode userInfo:userInfo];
	}
    
catch_exit:
	if(pmatch)
		free(pmatch);
	regfree(&preg);
	return outMatches;
}

-(BOOL) grep:(NSString*)pattern options:(int)options
{
	//NSLog(@"NSString_RegEx - grep");
	
	NSArray * substrings = [self substringsMatchingRegularExpression:pattern count:-1 options:options ranges:NULL error:NULL];
	return (substrings && [substrings count] > 0);
}

-(NSMutableArray*) substringByRegular:(NSString*)regular
{
    NSString* reg=regular;
    NSRange r=[self rangeOfString:reg options:NSRegularExpressionSearch];
    NSMutableArray* arr=[NSMutableArray array];
    
    if(r.length!=NSNotFound && r.length!=0)
    {
        while(r.length!=NSNotFound && r.length!=0)
        {
            NSString* substr=[self substringWithRange:r];
            
            [arr addObject:substr];
            NSRange startr=NSMakeRange(r.location+r.length, [self length]-r.location-r.length);
            r=[self rangeOfString:reg options:NSRegularExpressionSearch range:startr];
        }
    }
    NSLog(@"%@",arr);
    return arr;
}

-(float) getWidth:(UIFont*)font limit:(float)limit // if limit=0 means no limit
{
	if(!self || [self length]<=0)
		return 0;
	
	CGSize temp = {900000, 30};
	CGSize txtSize = [self sizeWithFont:font constrainedToSize:temp];
	
	if(limit>0 && txtSize.width>limit)
		return limit;
	
	return txtSize.width;
}

//-(NSString*) getCurArriveTime
//{
////#define KSecond_Year    31536000
////#define KSecond_Week    604800
////#define KSecond_Day     86400
////#define KSecond_Hour    3600
////#define KSecond_Minute  60
//    
//    NSDate* createDate=[appDelegate.dateFormatter dateFromString:self];
//    NSTimeInterval time=[[NSDate date] timeIntervalSinceDate:createDate];
//    NSString* fs=nil;
//    
//    int num=0;
//    if(time>KSecond_Year)
//    {
//        fs=LTXT(PP_fYearBefore);
//        num=time/KSecond_Year;
//    }
//    else if(time>KSecond_Week)
//    {
//        fs=LTXT(PP_fWeekBefore);
//        num=time/KSecond_Week;
//    }
//    else if(time>KSecond_Day)
//    {
//        fs=LTXT(PP_fDayBefore);
//        num=time/KSecond_Day;
//    }
//    else if(time>KSecond_Hour)
//    {
//        fs=LTXT(PP_fHourBefore);
//        num=time/KSecond_Hour;
//    }
//    else if(time>KSecond_Minute)
//    {
//        fs=LTXT(PP_fMinuteBefore);
//        num=time/KSecond_Minute;
//    }
//    else
//    {
//        fs=LTXT(PP_fSecondBefore);
//        num=time;
//    }
//    
//    if(num<=0 || [self isEqualToString:@""])
//        num=1;
//    
//    return [NSString stringWithFormat:fs,num];
//}
//-(NSString*) getCurArriveTime_2
//{
//    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    
//    NSDate* createDate=[appDelegate.dateFormatter dateFromString:self];
//    NSString* cdate=[dateFormatter stringFromDate:createDate];
//    NSString* nowdate=[dateFormatter stringFromDate:[NSDate date]];
//    
//    
//    if(![cdate isEqualToString:nowdate])
//    { 
//        return cdate;
//    }
//    else
//    { 
//        [dateFormatter setDateFormat:@"HH:mm"];
//        return [dateFormatter stringFromDate:createDate];
//    }
//}
-(int) getStringNumber
{
    NSString* check=@"[^\\x00-\\xff]";
    NSRegularExpression* regex=[NSRegularExpression regularExpressionWithPattern:check options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger numberOfMatches=[regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    int num=(numberOfMatches+self.length+1)/2;
    return num;
}

-(NSString*) UnicodeToGB2312
{
	NSString* str=self;
	NSMutableString* sb=[[NSMutableString alloc] init];
    
	@try
    {
		while([str length]> 0)
        {
			if([self hasPrefix:@"\\u"])
            {
				char* cp = NULL;
				int x = [[str substringWithRange:NSMakeRange(2, 4)] intValue];
				char c = (char)x;
				cp[0] = c;
				[sb appendString:[NSString stringWithUTF8String:cp]];
				str = [str substringFromIndex:6];
			}
			else
            {
				[sb appendString:[str substringToIndex:1]];
				str = [str substringFromIndex:1];
			}
		}
	}
	@catch(NSException* e)
    {
		NSLog(@"exception - %@", e);
	}
    
	return [sb autorelease];
}

-(NSString*) encodeToPercentEscapeString
{
    NSString* outputStr=(NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    return [outputStr autorelease];
}

-(NSString*) URLDecodedString
{
    NSString* result=(NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self,CFSTR(""),kCFStringEncodingUTF8);
    return [result autorelease];
}

-(NSString*) append:(NSString*)str
{
    if(StrNull(str))
        return self;
    
    return [self stringByAppendingString:str];
}

-(NSString*) subString:(NSString*)beginStr // self=123ABC beginStr=A -> ABC
{
    NSRange range=[self rangeOfString:beginStr];
    if(range.location==NSNotFound)
        return @"";
    
    return [self substringFromIndex:range.location];
}

-(NSString*) beforeString:(NSString*)beginStr // self=123ABC beginStr=A -> 123
{
    NSRange range=[self rangeOfString:beginStr];
    if(range.location==NSNotFound)
        return @"";
    
    return [self substringToIndex:range.location];
}

@end