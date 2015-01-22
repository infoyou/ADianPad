
#import "GUtil.h"
#import <math.h>
#import "GDefine.h"
#import "NSString_Extras.h"
#import "ADAppDelegate.h"

#define USE_GYPSII
//#define USE_TEST
//#define USE_DEV
//#define USE_INNER
//#define USE_PRE_RELEASE

#define KFlowName @"flow.dat" // for json
#define KFlowName2 @"flow2.dat" // for image

NSMutableDictionary* flowdata=nil;
NSMutableDictionary* flowdata2=nil;
NSDateFormatter* flowFormat=nil;
NSDateFormatter* flowFormat2=nil;

@implementation GUtil

+ (NSString*) getJsonServerUrl
{
    
    return HOST_URL;
}

+ (NSString*) getUserAgent
{
	NSString * customerIDString=[NSString stringWithFormat:@"customerid=%@", GP_CustomID];
	NSString * variantString=[NSString stringWithFormat:@"variant=%@", GP_Variant];
	NSString * wholeString=[NSString stringWithFormat:@"(%@,%@)", customerIDString, variantString];
	
	return [NSString stringWithFormat:KUserAgent,
			[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
			wholeString];
}

+(NSData*) dataBase64:(NSData*)theData
{
	const uint8_t* input=(const uint8_t*)[theData bytes];
	NSInteger length=[theData length];
	
    static char table[]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData* data=[NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output=(uint8_t*)data.mutableBytes;
	
	NSInteger i;
    for (i=0; i < length; i += 3)
    {
        NSInteger value=0;
		NSInteger j;
        for (j=i; j < (i + 3); j++)
        {
            value <<= 8;
            if(j < length)
                value |= (0xFF & input[j]);
        }
		
        NSInteger theIndex=(i / 3) * 4;
        output[theIndex + 0]=                   table[(value >> 18) & 0x3F];
        output[theIndex + 1]=                   table[(value >> 12) & 0x3F];
        output[theIndex + 2]=(i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3]=(i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return data;
}

+(void) setInfo:(id)value withKey:(NSString*)key
{

    [GUtil removeInfo:key];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+(void) removeInfo:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

+(id) getInfo:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(void) setInfoWithUid:(id)value withKey:(NSString*)key
{
    if(appDelegate.uid)
    {
        key = [NSString stringWithFormat:@"%@_%@",appDelegate.uid,key];
    }
    [GUtil removeInfo:key];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+(void) removeInfoWithUid:(NSString*)key
{
    if(appDelegate.uid)
    {
        key = [NSString stringWithFormat:@"%@_%@",appDelegate.uid,key];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

+(id) getInfoWithUid:(NSString*)key
{
    if(appDelegate.uid)
    {
        key = [NSString stringWithFormat:@"%@_%@",appDelegate.uid,key];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];

}

+(UIAlertView*) alert:(NSString*)msg
{	
	UIAlertView* alert=[[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:LTXT(PP_OK) otherButtonTitles:nil, nil] autorelease];
	[alert show];
    return alert;
}

+(void) removeFile:(NSString*)filename
{
    NSFileManager* file=[NSFileManager defaultManager];
    NSError* err=nil;
    [file removeItemAtPath:filename error:&err];
}

+(NSString*) getUUID
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return [(NSString*)string autorelease];
}

+(NSString*) getCachePath:(NSString*)name
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	return [basePath stringByAppendingPathComponent:name];
}

+(NSString*) getDocPath:(NSString*)name
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	return [basePath stringByAppendingPathComponent:name];
}

+(BOOL) phoneNumCheck:(NSString*)phone
{
	
	NSString*  phoneExpression=[NSString stringWithUTF8String:"^[0-9]{8,16}$"];
	if ([phone grep:phoneExpression options:REG_ICASE]) {
		return YES;
	}else {
		return NO;
	}
}

+(NSString*) processPhoneNumber:(NSString*)input trimOrAppend:(BOOL)trimsuffix
{
	NSString* phonenum = nil;
	if (trimsuffix) {
        phonenum = [input stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
        
	}else {
		if ([input length] == 11) {
			phonenum = [NSString stringWithFormat:@"86%@", input];
		} else {
			phonenum = input;
		}
	}
	return phonenum;
}

+(UIImage*) thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

NSDate* startDate=nil;
+(void) markNow
{
    [startDate release];
    startDate=[[NSDate date] retain];
}

+(void) logPassTime
{
    NSDate* date=[NSDate date];
    NSTimeInterval time=[date timeIntervalSinceDate:startDate];
    NSLog(@"time pass micro second: %f",time*1000);
}

+(NSString*) getFlowDataFileName
{
    NSArray* paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
	NSString* documentsDirectory=[paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:KFlowName];
}

+(NSString*) getFlowDataFileName2
{
    NSArray* paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
	NSString* documentsDirectory=[paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:KFlowName2];
}

+(void) initFlowData
{
    if(flowdata==nil)
    {
        flowFormat=[[NSDateFormatter alloc] init];
        [flowFormat setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
        [flowFormat setDateFormat:@"yyyy-MMM-d"];
        
        flowFormat2=[[NSDateFormatter alloc] init];
        [flowFormat2 setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
        [flowFormat2 setDateFormat:@"MMM"];
        
        flowdata=[[NSMutableDictionary dictionary] retain];
        NSDictionary* dict=[NSDictionary dictionaryWithContentsOfFile:[self getFlowDataFileName]];
        
        if(ValidDict(dict))
            [flowdata setDictionary:dict];
        
        flowdata2=[[NSMutableDictionary dictionary] retain];
        dict=[NSDictionary dictionaryWithContentsOfFile:[self getFlowDataFileName2]];
        
        if(ValidDict(dict))
            [flowdata2 setDictionary:dict];
    }
}

+(void) checkNewMonth
{
    if([flowdata count]>0) // no today | need check new month to clearFlowData
    {
        NSDate* date=[flowFormat dateFromString:[[flowdata allKeys] objectAtIndex:0]];
        
        NSString* curmonth=[flowFormat2 stringFromDate:[NSDate date]];
        NSString* oldmonth=[flowFormat2 stringFromDate:date];
        
        if(![curmonth isEqualToString:oldmonth])
        {
            [self clearFlowData];
        }
    }
}

+(void) checkNewMonth2
{
    if([flowdata2 count]>0) // no today | need check new month to clearFlowData
    {
        NSDate* date=[flowFormat dateFromString:[[flowdata2 allKeys] objectAtIndex:0]];
        
        NSString* curmonth=[flowFormat2 stringFromDate:[NSDate date]];
        NSString* oldmonth=[flowFormat2 stringFromDate:date];
        
        if(![curmonth isEqualToString:oldmonth])
        {
            [self clearFlowData];
        }
    }
}

+(void) addFlow:(double)flowRate
{
    
    double curvalue=flowRate;
    NSString* curday=[flowFormat stringFromDate:[NSDate date]];
    
    if([[flowdata allKeys] containsObject:curday])
    {
        curvalue+=[[flowdata objectForKey:curday] doubleValue];
    }
    else
    {
        [self checkNewMonth];
    }
    
    [flowdata setObject:[NSNumber numberWithDouble:curvalue] forKey:curday];
    [flowdata writeToFile:[self getFlowDataFileName] atomically:YES];
}

+(void) addFlow2:(double)flowRate
{
//    if(appDelegate.internetConnectionStatus==kReachableViaWiFi)
//        return;
    
    double curvalue=flowRate;
    NSString* curday=[flowFormat stringFromDate:[NSDate date]];
    
    if([[flowdata2 allKeys] containsObject:curday])
    {
        curvalue+=[[flowdata2 objectForKey:curday] doubleValue];
    }
    else
    {
        [self checkNewMonth2];
    }
    
    [flowdata2 setObject:[NSNumber numberWithDouble:curvalue] forKey:curday];
    [flowdata2 writeToFile:[self getFlowDataFileName2] atomically:YES];
}

+(double) getFlowDataWithDay:(int)before
{
    double res=0;
    NSString* curday=[flowFormat stringFromDate:[NSDate date]];
    NSDate* date=[flowFormat dateFromString:curday];
    
    NSTimeInterval time=[date timeIntervalSince1970];
    time-=KSecond_Day*before;
    NSString* keyday=[flowFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    
    if([[flowdata allKeys] containsObject:keyday])
    {
        res=[[flowdata objectForKey:keyday] doubleValue];
    }
    
    return res;
}

+(double) getFlowDataWithDay2:(int)before
{
    double res=0;
    NSString* curday=[flowFormat stringFromDate:[NSDate date]];
    NSDate* date=[flowFormat dateFromString:curday];
    
    NSTimeInterval time=[date timeIntervalSince1970];
    time-=KSecond_Day*before;
    NSString* keyday=[flowFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    
    if([[flowdata2 allKeys] containsObject:keyday])
    {
        res=[[flowdata2 objectForKey:keyday] doubleValue];
    }
    
    return res;
}

+(double) getFlowDataWithMonth
{
    double res=0;
    [self checkNewMonth];
    
    for(NSNumber* value in [flowdata allValues])
    {
        res+=[value doubleValue];
    }
    
    return res;
}

+(double) getFlowDataWithMonth2
{
    double res=0;
    [self checkNewMonth2];
    
    for(NSNumber* value in [flowdata2 allValues])
    {
        res+=[value doubleValue];
    }
    
    return res;
}

+(void) clearFlowData
{
    [flowdata removeAllObjects];
    [self removeFile:[self getFlowDataFileName]];
    
    [flowdata2 removeAllObjects];
    [self removeFile:[self getFlowDataFileName2]];
}

+(NSString *) getTimeIntervalFrom1970:(NSString*)timeStr
{
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
    //Wed, 31 Oct 2012 10:14:00 +0800
    NSDate *time=[dateFormatter dateFromString:timeStr];
    NSString *timeSp = [NSString stringWithFormat:@"%f", [time timeIntervalSince1970]];
    return timeSp;
}

+(NSDate*) getDateFromStandTime:(NSString*)timestr
{
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
    //Wed, 31 Oct 2012 10:14:00 +0800
    NSDate *time=[dateFormatter dateFromString:timestr];
    
    return time;
}

+(NSDate*) getDateFrom1970:(NSString*)timestr
{
    double timed = [timestr doubleValue];
    NSDate *time=[NSDate dateWithTimeIntervalSince1970:timed];
    
    return time;
}

@end
