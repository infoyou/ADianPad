
#import "JsonUploadManager.h"
#import "GUtil.h"
#import "GDefine.h"
#import "ADAppDelegate.h"
#import "JSONKit.h"
#import "SoundNetManager.h"
#import "GJsonCenter.h"
#import "ImageNetManager.h"
#import "NSData_Extras.h"

#define LOG_SEND
#define LOG_GET

@implementation UploadItem
@synthesize upload,imgLocalName,audioLocalName,imgServerName,audioServerName;
@synthesize filter,lat,lon,poi,poiid;
@synthesize imgWidth,imgHeight,audioLength,metaSending;

-(void) dealloc
{
    [upload release];
    
    [imgLocalName release];
    [audioLocalName release];
    [imgServerName release];
    [audioServerName release];
    
    [filter release];
    [lat release];
    [lon release];
    [poi release];
    [poiid release];
    
    [super dealloc];
}

-(id) mutableCopyWithZone:(NSZone*)zone
{
    UploadItem* item=[[UploadItem alloc] init];
    
    item.imgLocalName=imgLocalName;
    item.audioLocalName=audioLocalName;
    item.imgServerName=imgServerName;
    item.audioServerName=audioServerName;
    
    item.filter=filter;
    item.lat=lat;
    item.lon=lon;
    item.poi=poi;
    item.poiid=poiid;
    
    item.imgWidth=imgWidth;
    item.imgHeight=imgHeight;
    item.audioLength=audioLength;
    
    return item;
}

-(void) clearUpload
{
    [upload release];
    upload=nil;
    self.metaSending=NO;
}

-(void) encodeWithCoder:(NSCoder*)encoder
{
//    [encoder encodeObject:imgLocalName forKey:@"imgLocalName"];
//    [encoder encodeObject:audioLocalName forKey:@"audioLocalName"];
//    [encoder encodeObject:imgServerName forKey:@"imgServerName"];
//    [encoder encodeObject:audioServerName forKey:@"audioServerName"];
//    
//    [encoder encodeObject:filter forKey:@"filter"];
//    [encoder encodeObject:lat forKey:@"lat"];
//    [encoder encodeObject:lon forKey:@"lon"];
//    [encoder encodeObject:poi forKey:@"poi"];
//    [encoder encodeObject:poiid forKey:@"poiid"];
//    
//    [encoder encodeObject:SFI(imgWidth) forKey:@"imgWidth"];
//    [encoder encodeObject:SFI(imgHeight) forKey:@"imgHeight"];
//    [encoder encodeObject:SFI(audioLength) forKey:@"audioLength"];
}

-(id) initWithCoder:(NSCoder*)decoder
{
    if((self=[super init]))
    {
//        self.imgLocalName=[decoder decodeObjectForKey:@"imgLocalName"];
//        self.audioLocalName=[decoder decodeObjectForKey:@"audioLocalName"];
//        self.imgServerName=[decoder decodeObjectForKey:@"imgServerName"];
//        self.audioServerName=[decoder decodeObjectForKey:@"audioServerName"];
//        
//        self.filter=[decoder decodeObjectForKey:@"filter"];
//        self.lat=[decoder decodeObjectForKey:@"lat"];
//        self.lon=[decoder decodeObjectForKey:@"lon"];
//        self.poi=[decoder decodeObjectForKey:@"poi"];
//        self.poiid=[decoder decodeObjectForKey:@"poiid"];
//        
//        self.imgWidth=[[decoder decodeObjectForKey:@"imgWidth"] intValue];
//        self.imgHeight=[[decoder decodeObjectForKey:@"imgHeight"] intValue];
//        self.audioLength=[[decoder decodeObjectForKey:@"audioLength"] intValue];
    }
    return self;
}

-(NSDictionary*) getItemData
{
    NSMutableDictionary* dict=[[NSMutableDictionary alloc] init];
    
    if(imgLocalName) [dict setObject:imgLocalName forKey:@"imgLocalName"];
    if(audioLocalName) [dict setObject:audioLocalName forKey:@"audioLocalName"];
    if(imgServerName) [dict setObject:imgServerName forKey:@"imgServerName"];
    if(audioServerName) [dict setObject:audioServerName forKey:@"audioServerName"];
    
    if(filter) [dict setObject:filter forKey:@"filter"];
    if(lat) [dict setObject:lat forKey:@"lat"];
    if(lon) [dict setObject:lon forKey:@"lon"];
    if(poi) [dict setObject:poi forKey:@"poi"];
    if(poiid) [dict setObject:poiid forKey:@"poiid"];
    
    if(imgWidth) [dict setObject:SFI(imgWidth) forKey:@"imgWidth"];
    if(imgHeight) [dict setObject:SFI(imgHeight) forKey:@"imgHeight"];
    if(audioLength) [dict setObject:SFI(audioLength) forKey:@"audioLength"];
    
    return [dict autorelease];
}

+(UploadItem*) createItem:(NSDictionary*)dict
{
    UploadItem* item=[[UploadItem alloc] init];
    
    item.imgLocalName=[dict objectForKey:@"imgLocalName"];
    item.audioLocalName=[dict objectForKey:@"audioLocalName"];
    item.imgServerName=[dict objectForKey:@"imgServerName"];
    item.audioServerName=[dict objectForKey:@"audioServerName"];
    
    item.filter=[dict objectForKey:@"filter"];
    item.lat=[dict objectForKey:@"lat"];
    item.lon=[dict objectForKey:@"lon"];
    item.poi=[dict objectForKey:@"poi"];
    item.poiid=[dict objectForKey:@"poiid"];
    
    item.imgWidth=[[dict objectForKey:@"imgWidth"] intValue];
    item.imgHeight=[[dict objectForKey:@"imgHeight"] intValue];
    item.audioLength=[[dict objectForKey:@"audioLength"] intValue];
    
    return [item autorelease];
}

@end

@implementation UploadItem2
@synthesize uploadDict,eventControl,key,type;

-(void) dealloc
{
    [uploadDict release];
    [key release];
    
    [super dealloc];
}

@end

static EventUpload* _sharedEventUpload=nil;
@implementation EventUpload
@synthesize upload;

-(id) init
{
    if((self=[super init]))
    {
        uploads=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [uploads release];
    self.upload=nil;
    
    [super dealloc];
}

+(EventUpload*) sharedEventUpload
{
    if(_sharedEventUpload==nil)
    {
        _sharedEventUpload=[[EventUpload alloc] init];
    }
    
    return _sharedEventUpload;
}
-(void) appendUploadItem:(NSString*)key control:(EventController*)event uploadData:(NSDictionary*)data
{
    [self appendUploadItem:key control:event uploadData:data type:0];
}

-(void) appendUploadItem:(NSString*)key control:(EventController*)event uploadData:(NSDictionary*)data type:(int)type
{
    UploadItem2* item=[[UploadItem2 alloc] init];
    item.uploadDict=data;
    item.eventControl=event;
    item.key=key;
    item.type=type;
    
    [uploads addObject:item];
    [item release];
    
    if(!uploading)
        [NSThread detachNewThreadSelector:@selector(checkUploadNext) toTarget:self withObject:nil];
}

-(void) checkUploadNext
{
    NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
    
    if(!uploading && uploads.count>0)
    {
        UploadItem2* item=[uploads objectAtIndex:0];
        NSData* imgdata=[NSData data];
        NSData* sounddata=[NSData data];
        if (item.type==1) { //type==1  --- photo
            UIImage* photo=[[UIImage alloc] initWithContentsOfFile:[[ImageNetManager sharedImageNetManager] imgFilename:item.key]];
            imgdata=UIImageJPEGRepresentation(photo,KJpgQuality);
        }
        else{
            sounddata=[NSData dataWithContentsOfFile:[SoundManager soundFilename:item.key]];
        }
        if(sounddata.length>0||imgdata.length>0)
        {
            self.upload=[[[JsonUploadManager alloc] init] autorelease];
            upload.customid=item.key;
            
            uploading=YES;
//            [upload asyncUpload:imgdata sounddata:sounddata delegate:self type:@"photo_comment" uploadData:item.uploadDict]; // todo
        }
        else
        {
            [uploads removeObjectAtIndex:0];
            [NSThread detachNewThreadSelector:@selector(checkUploadNext) toTarget:self withObject:nil];
        }
    }
    
    [pool release];
}

-(void) uploadFinished:(NSDictionary*)ndict manager:(JsonUploadManager*)manager
{
    if(uploads.count>0)
    {
        UploadItem2* item=[uploads objectAtIndex:0];
        NSDictionary* newdict=[ndict objectForKey:@"data"];
        if (ValidStr([newdict objectForKey:@"audio"])) {
            [SoundManager renameFile:item.key withNewFileName:[newdict objectForKey:@"audio"]];
        }
        else{
            [[ImageNetManager sharedImageNetManager] renameFile:item.key withNewFileName:[newdict objectForKey:@"thumb_url_m"]];
        }
        [item.eventControl uploadFinished:ndict manager:manager];
        [uploads removeObjectAtIndex:0];
    }
    
    uploading=NO;
    [NSThread detachNewThreadSelector:@selector(checkUploadNext) toTarget:self withObject:nil];
}

-(void) clearEvent:(EventController*)event
{
    for(UploadItem2* item in uploads)
    {
        if(item.eventControl==event)
            item.eventControl=nil;
    }
}

@end

@implementation JsonUploadManager
@synthesize imageData,soundData,uploadData,cmdType,delegate,photoName,customid;

-(void) dealloc
{
    [self cancelUpload];
    
    [super dealloc];
}

// cmd: @"im_upload" | @"user_setimages" (sina avatar) | @"user_uploadavatar" (lingdi avatar) | @"user_uploadcustombg" | @"place_addcheckin" | @"place_addphoto" (no use)
-(NSMutableDictionary*) buildJsonString
{
    NSMutableDictionary* data = (uploadData==nil) ? [NSMutableDictionary dictionaryWithObjectsAndKeys:GID,@"uid", nil] : (NSMutableDictionary *)uploadData;
	
    NSString* session=UrlEncode(GSession);
    NSDictionary* head=[NSDictionary dictionaryWithObjectsAndKeys:[GUtil getUserAgent], @"ua",AppServerLang, @"lang",appDelegate.platform,@"platform",nil];
	NSMutableDictionary* json=[NSMutableDictionary dictionaryWithObjectsAndKeys:cmdType, @"cmd", head, @"headers", data, @"data", Str(session),@"sid",customid,@"id", nil];
    
#ifdef LOG_SEND
    LOGA(json);
#endif
    return json;
}

-(NSDictionary*) doUpload
{
    NSString *uri = [NSString stringWithFormat:@"%@/upload",[GUtil getJsonServerUrl]];
    NSURL* url=[NSURL URLWithString:uri];
    NSMutableURLRequest* req=[[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:@"POST"];
    
//    NSString* jsonstring=[[CJSONSerializer serializer] serializeDictionary:[self buildJsonString]];
//    NSString* jsonstring=[[[NSString alloc] initWithData:[[self buildJsonString] JSONData] encoding:NSUTF8StringEncoding] autorelease];
    NSString* boundary=@"0xKhTmLbOuNdArY";
    
    NSDictionary* headers=[NSDictionary dictionaryWithObjectsAndKeys:@"keep-alive",@"Connection",
                           [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary],@"Content-type",
                           [GUtil getUserAgent],@"X-Gypsii-UA",@"Accept-Charset",@"ISO-8859-1",nil];
    [req setAllHTTPHeaderFields:headers];
    
    NSMutableData* postData=[[NSMutableData alloc]init];
    NSDictionary *commonDic = [NSDictionary dictionaryWithObjectsAndKeys:KAppVersion,@"version",appDelegate.loginname,@"loginname",@"1",@"command", nil];
    NSString *jsonheadstr = [[NSString alloc] initWithData:[commonDic JSONData] encoding:NSUTF8StringEncoding];
    [postData appendData:[jsonheadstr dataUsingEncoding:NSUTF8StringEncoding]];//[ JSONRepresentation]];
    [jsonheadstr release];
    [postData appendData:[@"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
//    [postData appendData:imageData];
    
    if(imageData!=nil&&imageData.length>0)
    {
//        NSString* name=ValidStr(self.photoName)?self.photoName: @"photo";
//        NSString* pathname=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSString* filename=[NSString stringWithFormat:@"%@/%@",pathname,name];
//        
//        [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type:image/webp\r\n\r\n",name,filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:imageData];
    }
    
    if(soundData!=nil&&soundData.length>0)
    {
        NSString* name=@"audio";
        NSString* pathname=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* filename=[NSString stringWithFormat:@"%@/%@",pathname,name];
        
        [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type:sound/aac\r\n\r\n",name,filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:soundData];
    }
//    
//    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [req setHTTPBody:postData];
    sendlength = [postData length];
    [postData release];
    
    if(beSync)
    {
        NSData* returnData=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
//        NSString* returnString=[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//        NSDictionary* dict=[NSDictionary dictionaryWithJSONData:[returnString dataUsingEncoding:NSUTF8StringEncoding] error:nil];
//        [returnString release];
        
        NSError* outError=nil;
        NSDictionary* dict=[returnData objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&outError];
        if(outError!=nil)
            LOGA(outError);
        [req release];
        
        return dict;
    }
    else
    {
        NSURLConnection* con=[NSURLConnection connectionWithRequest:req delegate:self];
        [req release];
     
        connect = con;
        
        [con scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [con start];
        
        done=NO;
        do
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];   
        }
        while(!done);
//        [NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:120]];

        return nil;
    }
}

-(NSDictionary*) startUpload
{
    beSync=YES;
    return [self doUpload];
}
-(void) asyncUpload:(NSData*)imgdata delegate:(id<JsonUploadManagerDelegate>)uploaddelegate type:(NSString*)type photoName:(NSString*)pname
{
    self.delegate=uploaddelegate;
    self.imageData=imgdata; 
    self.cmdType=type;
    self.photoName=pname;
    beSync=NO;
    
    [self doUpload];
}
-(void) asyncUpload:(NSData*)imgdata sounddata:(NSData*)sounddata delegate:(id<JsonUploadManagerDelegate>)uploaddelegate type:(NSString*)type uploadData:(NSDictionary*)data
{
    self.delegate=uploaddelegate;
    self.imageData=imgdata; 
    self.soundData=sounddata;
    self.cmdType=type;
    self.uploadData=data;
    beSync=NO;
    
    [self doUpload];
}

-(void) connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    [recvdata release];
    recvdata=nil;
    recvdata=[[NSMutableData data] retain];
}

-(void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)getdata
{
	[recvdata appendData:getdata];
}

-(void) connectionDidFinishLoading:(NSURLConnection*)connection
{
//    NSString* str=[[NSString alloc] initWithData:recvdata encoding:NSUTF8StringEncoding];
//    NSDictionary* dict=[NSDictionary dictionaryWithJSONData:[str dataUsingEncoding:NSUTF8StringEncoding] error:nil];
//    [str release];
    
    NSError* outError=nil;
    NSStringEncoding encoding = NSISOLatin1StringEncoding;
    NSString *IANAEncoding = @"gbk";
    if (IANAEncoding) {
        CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)IANAEncoding);
        if (cfEncoding != kCFStringEncodingInvalidId) {
            encoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
        }
    }
    NSString* content0=[[NSString alloc] initWithBytes:[recvdata bytes] length:[recvdata length] encoding:encoding];
    //    NSString* content0=[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSISOLatin1StringEncoding];
    NSString* content=UrlDecode2(content0);
    
    
    NSRange range=[content rangeOfString:@"{"];
    if(content.length<5 || range.location>200000)
    {
        LOGA(@"===========-----------range out!");
//        [self jsonRequestError];
        [delegate uploadFinished:nil manager:self];
        if(content0!=nil)
            LOGA(content0);
        
        [content0 release];
//        [pool release];
        return;
    }
    
    NSString *tem = [content stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    tem = [tem stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    content = [tem stringByReplacingOccurrencesOfString:@"}{" withString:@","];

    NSData* jsondata=[[content substringFromIndex:range.location] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* dict=[jsondata objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&outError];
//    NSDictionary* dict=[recvdata objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&outError];
    if(outError!=nil)
        LOGA(outError);
    
#ifdef LOG_GET
    LOGA(dict);
#endif
    
//    [GUtil addFlow:(KJsonHttpHeaderSendLength+KJsonHttpHeaderRecvLength+sendlength+[recvdata compressGZip].length)];
    if([(NSObject*)delegate respondsToSelector:@selector(uploadFinished:manager:)])
    {
        [delegate uploadFinished:dict manager:self];
    }
    
    [self cancelUpload];
}

-(void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    if([(NSObject*)delegate respondsToSelector:@selector(uploadFinished:manager:)])
    {
        [delegate uploadFinished:nil manager:self];
    }
    
    [self cancelUpload];
}

-(void) connection:(NSURLConnection*)connection didSendBodyData:(NSInteger)bytes totalBytesWritten:(NSInteger)totalWritten totalBytesExpectedToWrite:(NSInteger)totalBytes
{
    LOG(@"upload: %d : %d : %d",bytes,totalWritten,totalBytes);
    if([(NSObject*)delegate respondsToSelector:@selector(uploadProcess:manager:)])
    {
        float process= (float)totalWritten/totalBytes;
        [delegate uploadProcess:process manager:self];
    }
}

-(void) cancelUpload
{
    [connect cancel];
    connect=nil;
    
    [recvdata release];
    recvdata=nil;
    delegate=nil;
    
    self.imageData=nil;
    self.soundData=nil;
    self.uploadData=nil;
    self.cmdType=nil;
    self.customid=nil;
    done=YES;
}

@end
