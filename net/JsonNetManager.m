
#import "JsonNetManager.h"
#import "NSString_Extras.h"
#import "GUtil.h"
#import "GDefine.h"
#import "JSONKit.h"
#import "ADAppDelegate.h"
#import "NSData_Extras.h"
#import "ADSessionInfo.h"
static JsonNetManager* _sharedJsonNetManager=nil;
const static int KJsonRequestNum=2;
const static int KJsonTimeOutValue=30;
#define JSON_MEMORYCACHESIZE 1500
#define KJsonTimeCheckDel 1800

#define KJsonCachePathName @"jsonCache"
#define KJsonCacheDateSignName @".dat"

#define LOG_SEND
#define LOG_GET

@implementation JsonRequestItem
@synthesize type,json,netstatus,jsonDelegate,data,key,custom,jsonurl,commend;
@synthesize subType;
-(id) init
{
    if((self=[super init]))
    {
        self.netstatus=KJNS_None;
        return self;
    }
    return nil;
}
-(NSData*) reqSync:(BOOL)bepost
{
    NSURL* url=[NSURL URLWithString:[GUtil getJsonServerUrl]];
    NSMutableURLRequest* req=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KJsonTimeOutValue];
    
    NSString* jsonstring=[self buildAsySendBase];
    if(bepost)
    {
        [req setHTTPMethod:@"POST"];
        NSData* senddata=[jsonstring dataUsingEncoding:NSUTF8StringEncoding];
        sendlength=senddata.length;
        [req setHTTPBody:senddata];
    }
    else
    {
        [req setHTTPMethod:@"GET"];
        [req setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",[GUtil getJsonServerUrl],jsonstring]]];
    }
    
    NSDictionary* headers=[NSDictionary dictionaryWithObjectsAndKeys:@"keep-alive",@"Connection",URLENCODEDCONTENT,@"Content-type",[GUtil getUserAgent],@"X-Gypsii-UA",nil];
    [req setAllHTTPHeaderFields:headers];
    
    return [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
}
+(NSDictionary*) requestSyncJson:(NSDictionary*)json withCmd:(NSString*)type withPost:(BOOL)bePost
{
    JsonRequestItem* item=[[JsonRequestItem alloc] init];
    item.type=type;
    item.json=json;
    
    NSData* data=[[item reqSync:bePost] retain];
//    [GUtil addFlow:(KJsonHttpHeaderSendLength+KJsonHttpHeaderRecvLength+40+data.length)]; // 100 is send length
    
    NSString* content0=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    NSString* content0=[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSISOLatin1StringEncoding];
    NSString* content=UrlDecode2(content0);
    
    NSRange range=[content rangeOfString:@"{"];
    if(content.length<=5 || range.location>200000)
    {
        LOGA(@"===========-----------range out!");
        if(content!=nil)
            LOGA(content);
        
        [content0 release];
        return nil;

    }
    NSString *tem = [content stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    tem = [tem stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    content = [tem stringByReplacingOccurrencesOfString:@"}{" withString:@","];

    [content0 release];
    [data release];
    [item release];
    
    NSData* jsondata=[[content substringFromIndex:range.location] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dict=[jsondata objectFromJSONDataWithParseOptions:JKParseOptionStrict error:nil];
    return dict;
}



-(void) startRequest
{
    if(netstatus==KJNS_None)
    {
        netstatus=KJNS_Running;
        NSURL* url=[NSURL URLWithString:[GUtil getJsonServerUrl]];
        NSMutableURLRequest* req=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KJsonTimeOutValue];
        
        NSString* jsonstring=[self buildSendString];
        NSLog(@"jsonstring===%@结束",jsonstring);
        NSData* senddata=[jsonstring dataUsingEncoding:NSUTF8StringEncoding];
        sendlength=senddata.length;
        [req setHTTPBody:senddata];
        
        NSDictionary* headers=[NSDictionary dictionaryWithObjectsAndKeys:@"close",@"Connection",URLENCODEDCONTENT,@"Content-type",[GUtil getUserAgent],@"X-Gypsii-UA",@"utf-8",@"Accept-Charset",nil];
        [req setAllHTTPHeaderFields:headers];
        
        [req setHTTPMethod:@"POST"];
        NSURLConnection* con=[NSURLConnection connectionWithRequest:req delegate:self];
        [con start];
    }
}

-(void) realRequest
{
    if(/*json!=nil &&*/ netstatus==KJNS_None)
    {
        NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
        netstatus=KJNS_Running;
        
        NSString *urlstr = [GUtil getJsonServerUrl];
        NSURL* url=[NSURL URLWithString:urlstr];
        NSMutableURLRequest* req=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KJsonTimeOutValue];
        
        NSString* jsonstring=[self buildSendString];
        [req setHTTPBody:[jsonstring dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSDictionary* headers=[NSDictionary dictionaryWithObjectsAndKeys:@"close",@"Connection",URLENCODEDCONTENT,@"Content-type",[GUtil getUserAgent],@"X-Gypsii-UA",nil];
        [req setAllHTTPHeaderFields:headers];
        
        [req setHTTPMethod:@"POST"];
        NSURLConnection* con=[NSURLConnection connectionWithRequest:req delegate:self];
        [con start];
        
        done=NO;
        if(con!=nil)
        {
            do
            {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];   
            }
            while(!done);
        }
        [pool release];
    }
}

-(void) startRequest2
{
    [NSThread detachNewThreadSelector:@selector(realRequest) toTarget:self withObject:nil];
}
-(NSString*) buildAsySendBase
{
    NSDictionary* head=[NSDictionary dictionaryWithObjectsAndKeys:Application_Server_Language, @"lang",@"",@"open_id",@"",@"plat",[ADSessionInfo sharedSessionInfo].corporation_id,@"cid",[ADSessionInfo sharedSessionInfo].member_id_string,@"user_id",nil];
    NSDictionary* jsonall=[NSDictionary dictionaryWithObjectsAndKeys:type,@"route",head,@"base",json,@"data", nil];
#ifdef LOG_SEND
    NSLog(@"%@",jsonall);
#endif
    NSString* jsonstr=[[[NSString alloc] initWithData:[jsonall JSONData] encoding:NSUTF8StringEncoding] autorelease];
    return [NSString stringWithFormat:@"cmd=%@",jsonstr];


}
-(NSString*) buildSendString
{
    NSDictionary* head=[NSDictionary dictionaryWithObjectsAndKeys:Application_Server_Language, @"lang",@"",@"open_id",@"",@"plat",[ADSessionInfo sharedSessionInfo].corporation_id,@"cid",[ADSessionInfo sharedSessionInfo].member_id_string,@"user_id",nil];
    NSDictionary* jsonall=[NSDictionary dictionaryWithObjectsAndKeys:type,@"route",head,@"base",json,@"data", nil];
#ifdef LOG_SEND
    NSLog(@"%@",jsonall);
#endif
    NSString* jsonstr=[[[NSString alloc] initWithData:[jsonall JSONData] encoding:NSUTF8StringEncoding] autorelease];
    return [NSString stringWithFormat:@"cmd=%@",jsonstr];
}

-(BOOL) checkUseBuffer
{
    if([self.type isEqualToString:@"ailingdi_events"])
    {
        NSDictionary* dict=[JsonManager getRequestBuffer:self];
        if(dict!=nil)
        {
            if([(NSObject*)jsonDelegate respondsToSelector:@selector(jsonRequestFinish:requestItem:)])
            {
                [jsonDelegate jsonRequestFinish:dict requestItem:self];
                [JsonManager checkRunNext:self];
            }
            return YES;
        }
    }
    
    return NO;
}

-(void) connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    self.data=[NSMutableData data];
}

-(void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)getdata
{
	[self.data appendData:getdata];
}

-(void) connectionDidFinishLoading:(NSURLConnection*)connection
{
	NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
//    [GUtil addFlow:(KJsonHttpHeaderSendLength+KJsonHttpHeaderRecvLength+sendlength+[data compressGZip].length)];
    
//    NSString* content0=[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
//    NSString* content0=[[NSString alloc] initWithData:self.data encoding:NSUnicodeStringEncoding];

    NSStringEncoding encoding = NSISOLatin1StringEncoding;
    NSString *IANAEncoding = @"gbk";
    if (IANAEncoding) {
        CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)IANAEncoding);
        if (cfEncoding != kCFStringEncodingInvalidId) {
            encoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
        }
    }
        NSString* content0=[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:encoding];
//    NSString* content0=[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSISOLatin1StringEncoding];
    NSString* content=UrlDecode2(content0);
    #ifdef LOG_GET
    NSLog(@"res===%@",content);
    #endif
    NSRange range=[content rangeOfString:@"{"];
    if(content.length<5 || range.location>200000)
    {
        LOGA(@"===========-----------range out!");
        [self jsonRequestError];
        if(content0!=nil)
            LOGA(content0);
        
        [content0 release];
        [pool release];
        return;
    }
    NSString *tem = [content stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    tem = [tem stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    content = [tem stringByReplacingOccurrencesOfString:@"}{" withString:@","];
    NSData* jsondata=[[content substringFromIndex:range.location] dataUsingEncoding:NSUTF8StringEncoding];
    NSError* outError=nil;
//    NSDictionary* dict=[[CJSONDeserializer deserializer] deserialize:jsondata error:&outError];
    NSDictionary* dict=[jsondata objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&outError];
#ifdef LOG_GET
    NSLog(@"%@",dict);
#endif
    
    if(dict!=nil && [(NSObject*)jsonDelegate respondsToSelector:@selector(jsonRequestFinish:requestItem:)])
    {
        [jsonDelegate jsonRequestFinish:dict requestItem:self];
        [JsonManager checkRunNext:self];
    }
    else
    {
        NSLog(@"JsonNetManager: get data error");
        if(outError!=nil)
            LOGA(outError);
        
        [self jsonRequestError];
    }
    
//    [dict release];
    [content0 release];
	[pool release];
    [self resetConnection];
}

-(void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog(@"JsonNetManager: json net error : %@",error);
    [self jsonRequestError];
}

-(void) jsonRequestError
{
    NSLog(@"json request err: %@ | %@",type,json);
    
    if(jsonDelegate!=nil && [(NSObject*)jsonDelegate respondsToSelector:@selector(jsonRequestFailed:)])
    {
        [jsonDelegate jsonRequestFailed:self];
        [JsonManager checkRunNext:self];
    }
    
    [self resetConnection];
}

-(void) resetConnection
{
    done=YES;
    if(connect!=nil)
    {
        [connect cancel];
        [connect release];
        connect=nil;
    }
}

-(void) dealloc
{
    [self resetConnection];
    self.type=nil;
    self.json=nil;
    self.jsonDelegate=nil;
    self.data=nil;
    self.key=nil;
    self.custom=nil;
    self.jsonurl = nil;
    self.commend = nil;
    [super dealloc];
}
@end

@implementation JsonNetManager
@synthesize jsonCache,frombuffer;

+(JsonNetManager*) sharedJsonNetManager
{
	if(_sharedJsonNetManager==nil)
    {
		_sharedJsonNetManager=[[JsonNetManager alloc] init];
	}
	return _sharedJsonNetManager;
}

-(id) init
{
	if((self=[super init]))
    {
        [self initJsonPath];
        runcount=0;
		jsonCache=[[NSMutableArray alloc] initWithCapacity:10];
	}
	return self;
}

-(JsonRequestItem*) requestJson:(NSDictionary*)json type:(NSString*)type customid:(NSString*)customid jsonDelegate:(id<JsonRequestDelegate>)delegate
{
    if(type==nil || [type length]<=0 || delegate==nil)
        return nil;
    
    if([self checkJson:json type:type jsonDelegate:delegate])
    {
        JsonRequestItem* item=[[JsonRequestItem alloc] init];
        item.type=type;
        item.json=json;
        item.jsonDelegate=delegate;
        item.key=[delegate getKey:type];
        item.subType=customid;
        
        if([delegate respondsToSelector:@selector(checkJsonRequestBuffer:)])
        {
            [delegate checkJsonRequestBuffer:item];
        }
        
        [jsonCache addObject:item];
        if(KJsonRequestNum>runcount)
        {
            [item startRequest];
            runcount++;
        }
        [item release];
        
        if([delegate respondsToSelector:@selector(startScroll)])
        {
            [delegate startScroll];
        }
        
        return item;
    }
    
    return nil;
}

-(JsonRequestItem*) requestJson:(NSDictionary*)json type:(NSString*)type commend:(NSString*)commend jsonurl:(NSString*)jsonurl jsonDelegate:(id<JsonRequestDelegate>)delegate
{
    if(type==nil || [type length]<=0 || delegate==nil || commend == nil || jsonurl == nil)
    {
        return nil;
    }
    
    if([self checkJson:json type:type jsonDelegate:delegate])
    {
        JsonRequestItem* item=[[JsonRequestItem alloc] init];
        item.type=type;
        item.json=json;
        item.jsonDelegate=delegate;
        item.jsonurl = jsonurl;
        item.commend = commend;
        item.key=[delegate getKey:type];
        
        if([delegate respondsToSelector:@selector(checkJsonRequestBuffer:)])
        {
            [delegate checkJsonRequestBuffer:item];
        }
        
        [jsonCache addObject:item];
        if(KJsonRequestNum>runcount)
        {
            [item startRequest];
            runcount++;
        }
        [item release];
        
        if([delegate respondsToSelector:@selector(startScroll)])
        {
            [delegate startScroll];
        }
        
        return item;
    }
    
    return nil;
    
}
-(JsonRequestItem*) requestJson:(NSDictionary*)json type:(NSString*)type jsonDelegate:(id<JsonRequestDelegate>)delegate
{
    return [self requestJson:json type:type customid:nil jsonDelegate:delegate];
}


-(BOOL) checkJson:(NSDictionary*)json type:(NSString*)type jsonDelegate:(id<JsonRequestDelegate>)delegate
{
//    NSString* key=[delegate getKey:type];
//    for(JsonRequestItem* item in jsonCache)
//    {
//        NSLog(@"jsonCache.item:%@,%@",item.type,item.key);
//        if([item.type isEqualToString:type] && [key isEqualToString:item.key] && item.jsonDelegate==delegate)
//        {
//            return NO;
//        }
//    }
    
    return YES; // need add to array
}

-(void) removeDelegate:(id<JsonRequestDelegate>)delegate
{
    for(int k=[jsonCache count]-1;k>=0;k--)
    {
        JsonRequestItem* item=[jsonCache objectAtIndex:k];
        if(item.jsonDelegate==delegate)
        {
            item.jsonDelegate=nil;
            if(item.netstatus==KJNS_Running)
                runcount--;
            
            [jsonCache removeObject:item];
        }
    }
    
    [self checkRunNext:nil];
}

-(void) checkRunNext:(JsonRequestItem*)item
{
    if(item!=nil) // remove old item
    {
        for(JsonRequestItem* item2 in jsonCache)
        {
            if(item==item2)
            {
                [jsonCache removeObject:item];
                break;
            }
        }
        runcount--;
    }
    
    if(KJsonRequestNum>runcount) // run next
    {
        for(JsonRequestItem* item2 in jsonCache)
        {
            if(item2.netstatus==KJNS_None)
            {
                [item2 startRequest];
                break;
            }
        }
    }
}

-(NSString*) jsonFilename:(NSString*)data
{
    NSArray* paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
	NSString* documentsDirectory=[paths objectAtIndex:0];
	
	NSString* directory=[documentsDirectory stringByAppendingPathComponent:KJsonCachePathName];
    NSString* allfilename=nil;
    
    if(data!=nil)
    {
        NSString* filename=[data MD5Hash];
        allfilename=[NSString stringWithFormat:@"%@/%@",directory,filename];
    }
    else
        allfilename=[NSString stringWithFormat:@"%@",directory];
    
	return allfilename;
}

-(void) initJsonPath
{
    NSFileManager* file=[NSFileManager defaultManager];
    NSError* err=nil;
    
    NSString* path=[self jsonFilename:nil];
    NSArray* dirContents=[file contentsOfDirectoryAtPath:path error:&err];
    
    if(dirContents==nil)
        [file createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
}

-(void) saveRequestBuffer:(JsonRequestItem*)item response:(NSDictionary*)dict
{
    NSString* filename=[self jsonFilename:item.key];
    [dict writeToFile:filename atomically:YES];
    
    NSError* err=nil;
    NSString* datefile=[filename stringByAppendingString:KJsonCacheDateSignName];
    NSDate* date=[NSDate date];
    NSTimeInterval ti=[date timeIntervalSince1970];
    NSString* str=[NSString stringWithFormat:@"%f",ti];
    [str writeToFile:datefile atomically:YES encoding:NSASCIIStringEncoding error:&err];
    
    [self checkClearCache];
}

-(NSDictionary*) getRequestBuffer:(JsonRequestItem*)item
{
    return [self getRequestBufferFromKey:item.key];
}

-(NSDictionary*) getRequestBufferFromKey:(NSString*)key
{
    NSString* filename=[self jsonFilename:key];
    NSDictionary* data=nil;
    if(FileExsit(filename))
    {
        data=[NSDictionary dictionaryWithContentsOfFile:filename];
	}
    return data;
}

-(void) checkClearCache
{
    NSFileManager* file=[NSFileManager defaultManager];
    NSError* err=nil;
    
    NSString* path=[self jsonFilename:nil];
    NSArray* filearray=[file contentsOfDirectoryAtPath:path error:&err];
    
    if([filearray count]<JSON_MEMORYCACHESIZE)
        return;
    
    NSTimeInterval now=[[NSDate date] timeIntervalSince1970];
    for(NSString* filename in filearray)
    {
        if([filename hasSuffix:KJsonCacheDateSignName])
        {
            NSString* fullname=[NSString stringWithFormat:@"%@/%@",path,filename];
            NSString* content=[NSString stringWithContentsOfFile:fullname encoding:NSASCIIStringEncoding error:&err];
            
            bool needdel=false;
            if(content==nil || [content isEqualToString:@""])
            {
                needdel=true;
            }
            else
            {
                NSTimeInterval ti=[content doubleValue];
                if(now>ti+KJsonTimeCheckDel)
                    needdel=true;
            }
            
            if(needdel)
            {
                NSRange ran={0,[fullname length]-[KJsonCacheDateSignName length]};
                NSString* jsonfullname=[fullname substringWithRange:ran];
                
                [file removeItemAtPath:fullname error:&err];
                [file removeItemAtPath:jsonfullname error:&err];
            }
        }
    }
}

-(void) clearAllCache
{
    NSFileManager* file=[NSFileManager defaultManager];
    NSError* err=nil;
    
    NSString* path=[self jsonFilename:nil];
    NSArray* filearray=[file contentsOfDirectoryAtPath:path error:&err];
    
    for(NSString* filename in filearray)
    {
        NSString* fullname=[NSString stringWithFormat:@"%@/%@",path,filename];
        [file removeItemAtPath:fullname error:&err];
    }
}

-(void) dealloc
{
    [jsonCache removeAllObjects];
    [jsonCache release];
    _sharedJsonNetManager=nil;
    
	[super dealloc];
}

@end
