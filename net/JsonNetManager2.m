
#import "JsonNetManager2.h"
#import "NSString_Extras.h"
#import "GUtil.h"
#import "GDefine.h"
#import "JSONKit.h"
#import "ADAppDelegate.h"
#import "NSData_Extras.h"

static JsonNetManager2* _sharedJsonNetManager=nil;
const static int KJsonRequestNum=2;
const static int KJsonTimeOutValue=30;

#define KJsonCache2Name @"jsonCache2.dat"

#define LOG_SEND
#define LOG_GET

@implementation JsonRequestItem2
@synthesize type,json,netstatus,data,custom;

-(id) init
{
    if((self=[super init]))
    {
        self.netstatus=KJNS2_None;
        return self;
    }
    return nil;
}

-(NSDictionary*) getItemData
{
    NSMutableDictionary* dict=[[NSMutableDictionary alloc] init];
    
    if(type) [dict setObject:type forKey:@"type"];
    if(json) [dict setObject:json forKey:@"json"];
    if(custom) [dict setObject:custom forKey:@"custom"];
    
    return [dict autorelease];
}

+(JsonRequestItem2*) createItem:(NSDictionary*)dict
{
    JsonRequestItem2* item=[[JsonRequestItem2 alloc] init];
    
    item.type=[dict objectForKey:@"type"];
    item.json=[dict objectForKey:@"json"];
    item.custom=[dict objectForKey:@"custom"];
    
    return [item autorelease];
}

-(void) startRequest
{
    if(netstatus==KJNS2_None)
    {
        netstatus=KJNS2_Running;
        
        NSURL* url=[NSURL URLWithString:[GUtil getJsonServerUrl]];
        NSMutableURLRequest* req=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KJsonTimeOutValue];
        
        NSString* jsonstring=[self buildSendString];
        NSData* senddata=[jsonstring dataUsingEncoding:NSUTF8StringEncoding];
        sendlength=senddata.length;
        [req setHTTPBody:senddata];
        
        NSDictionary* headers=[NSDictionary dictionaryWithObjectsAndKeys:@"keep-alive",@"Connection",URLENCODEDCONTENT,@"Content-type",[GUtil getUserAgent],@"X-Gypsii-UA",nil];
        [req setAllHTTPHeaderFields:headers];
        
        [req setHTTPMethod:@"POST"];
        NSURLConnection* con=[NSURLConnection connectionWithRequest:req delegate:self];
        [con start];
    }
}

-(void) realRequest
{
    if(/*json!=nil &&*/ netstatus==KJNS2_None)
    {
        NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
        netstatus=KJNS2_Running;
        
        NSURL* url=[NSURL URLWithString:[GUtil getJsonServerUrl]];
        NSMutableURLRequest* req=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KJsonTimeOutValue];
        
        NSString* jsonstring=[self buildSendString];
        [req setHTTPBody:[jsonstring dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSDictionary* headers=[NSDictionary dictionaryWithObjectsAndKeys:@"keep-alive",@"Connection",URLENCODEDCONTENT,@"Content-type",[GUtil getUserAgent],@"X-Gypsii-UA",nil];
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

-(NSString*) buildSendString
{
    NSString* session=@"";
    if(ValidStr(GSession))
    {
        session=UrlEncode(GSession);
    }
    
    NSDictionary* head=[NSDictionary dictionaryWithObjectsAndKeys:[GUtil getUserAgent], @"ua",Application_Server_Language, @"lang",appDelegate.platform,@"platform",nil];
    NSDictionary* jsonall=[NSDictionary dictionaryWithObjectsAndKeys:type,@"cmd",Str(session),@"sid",head,@"headers",json,@"data",custom,@"id", nil];
#ifdef LOG_SEND
    NSLog(@"%@",jsonall);
#endif
    NSString* jsonstr=[[[NSString alloc] initWithData:[jsonall JSONData] encoding:NSUTF8StringEncoding] autorelease];
    return [NSString stringWithFormat:@"json=%@",UrlEncode(jsonstr)];
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
    
    NSString* content0=[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSString* content=UrlDecode2(content0);
    
    NSRange range=[content rangeOfString:@"{"];
    if(content.length<20 || range.location>200000)
    {
        LOGA(@"===========-----------range out!");
        [self jsonRequestError];
        if(content0!=nil)
            LOGA(content0);
        
        [content0 release];
        [pool release];
        return;
    }
    
    NSData* jsondata=[[content substringFromIndex:range.location] dataUsingEncoding:NSUTF8StringEncoding];
    NSError* outError=nil;
    NSDictionary* dict=[jsondata objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&outError];
#ifdef LOG_GET
    NSLog(@"%@",dict);
#endif
    
    if(dict!=nil)
    {
        // need check data??
        [JsonManager2 checkRunNext:self];
    }
    else
    {
        NSLog(@"JsonNetManager2: get data error");
        if(outError!=nil)
            LOGA(outError);
        
        [self jsonRequestError];
    }
    
    [content0 release];
	[pool release];
    [self resetConnection];
}

-(void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog(@"JsonNetManager2: json net error : %@",error);
//    [self jsonRequestError];
    
    [JsonManager2 checkRunNext:nil]; // can't del this json item
    [self resetConnection];
}

-(void) jsonRequestError
{
    NSLog(@"json request err: %@ | %@",type,json);
    
    {
        // need do something??
        [JsonManager2 checkRunNext:self];
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
    self.data=nil;
    self.custom=nil;
    
    [super dealloc];
}
@end

@implementation JsonNetManager2
@synthesize jsonCache,frombuffer;

+(JsonNetManager2*) sharedJsonNetManager
{
	if(_sharedJsonNetManager==nil)
    {
		_sharedJsonNetManager=[[JsonNetManager2 alloc] init];
	}
	return _sharedJsonNetManager;
}

-(id) init
{
	if((self=[super init]))
    {
        runcount=0;
		jsonCache=[[NSMutableArray alloc] initWithCapacity:10];
	}
	return self;
}

-(JsonRequestItem2*) requestJson:(NSDictionary*)json type:(NSString*)type customid:(NSString*)customid
{
    if(type==nil || [type length]<=0)
        return nil;
    
    JsonRequestItem2* item=[[JsonRequestItem2 alloc] init];
    item.type=type;
    item.json=json;
    item.custom=customid;
    
    [jsonCache addObject:item];
    if(KJsonRequestNum>runcount)
    {
        [item startRequest];
        runcount++;
    }
    [item release];

    [self saveJsons];
    return item;
}

-(JsonRequestItem2*) requestJson:(NSDictionary*)json type:(NSString*)type
{
    return [self requestJson:json type:type customid:nil];
}

-(void) checkRunNext:(JsonRequestItem2*)item
{
    if(item!=nil) // remove old item
    {
        for(JsonRequestItem2* item2 in jsonCache)
        {
            if(item==item2)
            {
                [jsonCache removeObject:item];
                break;
            }
        }
        runcount--;
        [self saveJsons];
    }
    
    if(KJsonRequestNum>runcount) // run next
    {
        for(JsonRequestItem2* item2 in jsonCache)
        {
            if(item2.netstatus==KJNS2_None)
            {
                [item2 startRequest];
                break;
            }
        }
    }
}

-(void) dealloc
{
    [jsonCache removeAllObjects];
    [jsonCache release];
    _sharedJsonNetManager=nil;
    
	[super dealloc];
}

-(NSString*) jsonFilename
{
    NSArray* paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
	NSString* documentsDirectory=[paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:KJsonCache2Name];
}

-(void) saveJsons
{
    NSMutableArray* array=[NSMutableArray array];
    for(JsonRequestItem2* item in jsonCache)
    {
        NSDictionary* dt=[item getItemData];
        [array addObject:dt];
    }
    
    NSString* filename=[self jsonFilename];
    [array writeToFile:filename atomically:YES];
}

-(void) loadJsons
{
    NSString* filename=[self jsonFilename];
    NSArray* array=[NSArray arrayWithContentsOfFile:filename];
    
    if(ValidArray(array))
    {
        for(NSDictionary* dt in array)
        {
            JsonRequestItem2* item=[JsonRequestItem2 createItem:dt];
            
            if(item!=nil)
                [jsonCache addObject:item];
        }
        
        [self checkRunNext:nil];
    }
}

@end
