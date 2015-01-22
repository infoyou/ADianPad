
#import "SoundNetManager.h"
#import "NsObject_Extras.h"
#import "CommonCrypto/CommonDigest.h"

#define LOGSOUND(f) //NSLog(f)
#define LOGSOUND2(f,a) //NSLog(f,a)
#define StrNull(f) (f==nil || ![f isKindOfClass:[NSString class]] || ([f isKindOfClass:[NSString class]] && [f isEqualToString:@""]))

#define MEMORYCACHESIZE 80
#define KDownSoundNum 2
#define FileExsit(name) [[NSFileManager defaultManager] fileExistsAtPath:name]
#define KTimeCheckDel 300

#define KSoundCachePathName @"soundNetCache"
#define KSoundCacheDateSignName @".dat"
#define KSoundTimeOutValue 50

static SoundNetManager* _sharedSoundNetManager=nil;

@implementation SoundDownloadItem
@synthesize url,netstatus,delegateArray,data,needProcess,totalSize,getSize;

-(id) init
{
    if((self=[super init]))
    {
         delegateArray=[[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

-(void) startDownload
{
    if(url!=nil)
    {
        netstatus=KSNS_Downloading;
        
        NSURLRequest* req=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KSoundTimeOutValue];
        connect=[[NSURLConnection alloc] initWithRequest:req delegate:self];
        
        [req release];
        self.data=[NSMutableData data];
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    LOGSOUND2(@"connection didReceiveResponse: %@",url);
	totalSize=response.expectedContentLength;
//     NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//    int code = [httpResponse statusCode];
    if(totalSize<=50)
    {
        NSLog(@"response.expectedContentLength: 0 !!");
        //[self getSoundError];
    }
	getSize=0;
}

-(void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)pdata
{
    LOGSOUND2(@"connection didReceiveData: %@",url);
	[data appendData:pdata];
	if(!needProcess)
        return;
    
    getSize+=[pdata length];
    double val=0;
    if(totalSize>0)
        val=getSize/totalSize;
    NSNumber* num=[NSNumber numberWithDouble:val];
    
    for(id<SoundDownloadDelegate> delegate in delegateArray)
    {
        if(delegate!=nil && [(NSObject*)delegate respondsToSelector:@selector(soundDownloadProgress:)])
        {
            [delegate soundDownloadProgress:num];
        }
	}
}

-(void) connectionDidFinishLoading:(NSURLConnection*)connection 
{
    LOGSOUND2(@"connectionDidFinishLoading: %@",url);
    
    if(totalSize > 0)
    {
        if(data.length!=totalSize)
        {
            [self getSoundError];
            return;
        }
    }

	NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
    
    [SoundManager saveSound:data downloadItem:self];
    for(id<SoundDownloadDelegate> delegate in delegateArray)
    {
        if([(NSObject*)delegate respondsToSelector:@selector(soundDownloadFinish:downloadItem:)])
        {
            [delegate soundDownloadFinish:data downloadItem:self];
        }
    }
    
    self.data=nil;
    [self resetConnection];
    
	[pool release];
}

-(void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    LOGSOUND2(@"connection didFailWithError: %@",url);
    NSLog(@"SoundNetManager: Sound net error : %@",error);
    [self getSoundError];
}

-(void) getSoundError
{
    [SoundManager saveSound:nil downloadItem:self];
    
    for(id<SoundDownloadDelegate> delegate in delegateArray)
    {
        if([(NSObject*)delegate respondsToSelector:@selector(soundDownloadFailed:)])
        {
            [delegate soundDownloadFailed:self];
        }
    }
	
	self.data=nil;
    [self resetConnection];
}

-(void) resetConnection
{
    if(connect!=nil)
    {
        [connect cancel];
        [connect release];
        connect=nil;
    }
}

-(void) dealloc
{
    self.url=nil;
    [delegateArray removeAllObjects];
    [delegateArray release];
    [super dealloc];
}
@end

@implementation SoundNetManager
@synthesize soundCache;

+(SoundNetManager*) sharedSoundNetManager
{
	if(_sharedSoundNetManager==nil)
    {
		_sharedSoundNetManager=[[SoundNetManager alloc] init];
	}
	return _sharedSoundNetManager;
}

-(id) init
{
	if((self=[super init]))
    {
		soundCache=[[NSMutableArray alloc] initWithCapacity:MEMORYCACHESIZE];
        [self initSoundPath];
	}
	return self;
}

-(NSData*) reqSyncSound:(NSString*)url delegate:(id<SoundDownloadDelegate>)delegate
{
    if(StrNull(url) || url.length<=0)
        return nil;
    
    NSString* filename=[self soundFilename:url];
    if(FileExsit(filename))
    {
        [self writeSoundTimeSign:url]; // update time sign
		return [NSData dataWithContentsOfFile:filename];
    }
    else
    {
        [self getSoundFromNet:url delegate:delegate needProcess:NO];
        return nil;
    }
}

-(NSData*) reqSound:(NSString*)url delegate:(id<SoundDownloadDelegate>)delegate needProcess:(BOOL)need
{
    LOGSOUND2(@"reqSound: %@",url);
    if(StrNull(url) || url.length<=0)
        return nil;
        
    NSString* filename=[self soundFilename:url];
    if(FileExsit(filename))
        [self getSoundFromCache:url delegate:delegate];
    else
        [self getSoundFromNet:url delegate:delegate needProcess:need];
    
    return nil;
}

-(void) preloadSound:(NSString*)url
{
    [self reqSound:url delegate:nil needProcess:NO];
}

-(void) saveSound:(NSMutableData*)data downloadItem:(SoundDownloadItem*)item
{
    if(data!=nil)
    {
        NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
        if(YES!=[self writeSoundFile:item.url content:data])
        {
            NSLog(@"save fail");
        }
        else // write ok, create time sign
        {
            [self writeSoundTimeSign:item.url];
        }
        [pool release];
    }
    
    [soundCache removeObject:item];
    for(SoundDownloadItem* it in soundCache)
    {
        if(it.netstatus==KSNS_None)
        {
            [it startDownload];
            break;
        }
    }
    
	[self checkClearCache];
}

-(void) saveSound:(NSData*)data url:(NSString*)url
{
	NSString* filename=[self soundFilename:url];    
	[data writeToFile:filename atomically:YES];
    [self writeSoundTimeSign:url];
}

-(void) removeDelegate:(id<SoundDownloadDelegate>)delegate
{
    for(SoundDownloadItem* item in soundCache)
    {
        [item.delegateArray removeObject:delegate];
    }
}

-(BOOL) hasSoundBuffer:(NSString*)url
{
    NSString* filename=[self soundFilename:url];
    return FileExsit(filename);
}

-(NSData*) getSoundFromCache:(NSString*)url delegate:(id<SoundDownloadDelegate>)delegate // use thread
{
    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:url,@"url",delegate,@"delegate", nil];
    [NSThread detachNewThreadSelector:@selector(getLocalSound:) toTarget:self withObject:dict];
    return nil;
}

-(void) getLocalSound:(NSDictionary*)dict
{
    NSThread* thread=[NSThread currentThread]; // for ios 4.0
    [thread setThreadPriority:1.0]; // main thread is 0.75
    
    NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
    
    id<SoundDownloadDelegate> delegate=[dict objectForKey:@"delegate"];
    NSString* url=[dict objectForKey:@"url"];
    NSString* filename=[self soundFilename:url];
    
    NSData* data=[NSData dataWithContentsOfFile:filename];
    if(data)
    {
        if([(NSObject*)delegate respondsToSelector:@selector(soundDownloadFinish:downloadItem:)])
        {
            SoundDownloadItem* item=[[SoundDownloadItem alloc] init];
            item.url=url;
            
            [(NSObject*)delegate performSelectorOnMainThread:@selector(soundDownloadFinish:downloadItem:) withObject:data withObject:item waitUntilDone:NO];
            [item release];
        }
        
        [self writeSoundTimeSign:url];
    }
    
    [pool release];
}

-(void) getSoundFromNet:(NSString*)url delegate:(id<SoundDownloadDelegate>)delegate needProcess:(BOOL)need
{
    LOGSOUND2(@"getSoundFromNet: %@",url);
    if([self checkSoundUrl:url delegate:delegate])
    {
        SoundDownloadItem* item=[[SoundDownloadItem alloc] init];
        item.url=url;
        item.needProcess=need;
        item.netstatus=KSNS_None;
        
        if(delegate!=nil)
            [item.delegateArray addObject:delegate];
        
        [soundCache addObject:item];
        if(KDownSoundNum>=[soundCache count])
        {
            [item startDownload];
        }
        [item release];
    }
}

-(BOOL) checkSoundUrl:(NSString*)url delegate:(id<SoundDownloadDelegate>)delegate
{
    LOGSOUND2(@"checkSoundUrl: %@",url);
    for(SoundDownloadItem* item in soundCache)
    {
        if([item.url isEqualToString:url])
        {
            if(item.netstatus==KSNS_None) // change download array order
            {
                SoundDownloadItem* item2=[item retain];
                [soundCache removeObject:item];
                [soundCache insertObject:item2 atIndex:KDownSoundNum];
                [item release];
            }
            else if(item.netstatus==KSNS_Downloading && item.needProcess) // update process
            {
                float num=0;
                if(item.totalSize>0)
                    num=item.getSize/item.totalSize;
                
                if(num>0 && delegate!=nil && [(NSObject*)delegate respondsToSelector:@selector(soundDownloadProgress:)])
                {
                    NSNumber* nsnum=[NSNumber numberWithDouble:num];
                    [delegate soundDownloadProgress:nsnum];
                }
            }
            
            bool has=false;
            for(id<SoundDownloadDelegate> dg in item.delegateArray) // add delegate
            {
                if(dg==delegate)
                {
                    has=true;
                    break;
                }
            }
            if(!has && delegate!=nil)
            {
                [item.delegateArray addObject:delegate];
            }
            
            return NO;
        }
    }
    
    return YES; // need add to array
}

- (NSString*) MD5Hash:(NSString*)str
{
    const char* cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
	
    CC_MD5( cStr, strlen(cStr), result );
	
    return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

- (NSString*) soundFilename:(NSString*)url
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	
	NSString *directory=[documentsDirectory stringByAppendingPathComponent:KSoundCachePathName];
    NSString* allfilename=nil;
    
    if(url!=nil)
    {
        NSString* filename=[self MD5Hash:url];
        allfilename=[NSString stringWithFormat:@"%@/%@",directory,filename];
    }
    else
        allfilename=[NSString stringWithFormat:@"%@",directory];
    
	return allfilename;
}

-(BOOL) writeSoundFile:(NSString*)url content:(NSData*)data
{
    NSString* filename=[self soundFilename:url];
	return [data writeToFile:filename atomically:YES];
}

-(void) writeSoundTimeSign:(NSString*)url
{
    NSString* filename=[self soundFilename:url];
    NSString* datefile=[filename stringByAppendingString:KSoundCacheDateSignName];
    
    NSDate* date=[NSDate date];
    NSTimeInterval ti=[date timeIntervalSince1970];
    NSString* str=[NSString stringWithFormat:@"%f",ti];
    
    if(FileExsit(datefile))
    {
    }
    
    NSError* err=nil;
    [str writeToFile:datefile atomically:YES encoding:NSASCIIStringEncoding error:&err];
}

-(void) checkClearCache
{
    LOGSOUND(@"checkClearCache");
    NSFileManager* file=[NSFileManager defaultManager];
    NSError* err=nil;
    
    NSString* path=[self soundFilename:nil];
    NSArray* filearray=[file contentsOfDirectoryAtPath:path error:&err];
    
    if([filearray count]<MEMORYCACHESIZE)
        return;
    
    NSTimeInterval now=[[NSDate date] timeIntervalSince1970];
    for(NSString* filename in filearray)
    {
        if([filename hasSuffix:KSoundCacheDateSignName])
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
                if(now>ti+KTimeCheckDel)
                    needdel=true;
            }
            
            if(needdel)
            {
                NSRange ran={0,[fullname length]-[KSoundCacheDateSignName length]};
                NSString* soundfullname=[fullname substringWithRange:ran];
                
                [file removeItemAtPath:fullname error:&err];
                [file removeItemAtPath:soundfullname error:&err];
                LOGSOUND2(@"del cache: %@",soundfullname);
            }
        }
    }
}

-(void) initSoundPath
{
    NSFileManager* file=[NSFileManager defaultManager];
    NSError* err=nil;
    
    NSString* path=[self soundFilename:nil];
    NSArray* dirContents=[file contentsOfDirectoryAtPath:path error:&err];
    
    if(dirContents==nil)
        [file createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
}

-(void) clearSoundDir
{
    LOGSOUND(@"clearSoundDir");
    NSFileManager* file=[NSFileManager defaultManager];
    NSError* err=nil;
    
    NSString* path=[self soundFilename:nil];
    NSArray* filearray=[file contentsOfDirectoryAtPath:path error:&err];
    
    if([filearray count]<=0)
        return;
    
    for(NSString* filename in filearray)
    {
        NSString* fullname=[NSString stringWithFormat:@"%@/%@",path,filename];
        [file removeItemAtPath:fullname error:&err];
    }
}

-(BOOL) rename:(NSString*)oldfilename withNewFileName:(NSString*)newfilename
{
    NSFileManager* file=[NSFileManager defaultManager];
    NSError* err=nil;
    
    if(FileExsit(oldfilename))
        return [file moveItemAtPath:oldfilename toPath:newfilename error:&err];
    
    return NO;
}

-(BOOL) renameFile:(NSString*)oldfilename withNewFileName:(NSString*)newfilename
{
    NSString* oldname=[self soundFilename:oldfilename];
    NSString* newname=[self soundFilename:newfilename];
    
    [self rename:oldname withNewFileName:newname];
    [self rename:[oldname stringByAppendingString:KSoundCacheDateSignName] withNewFileName:[newname stringByAppendingString:KSoundCacheDateSignName]];
    
    return YES;
}

-(void) dealloc
{
    [soundCache removeAllObjects];
    [soundCache release];
    _sharedSoundNetManager=nil;
    
	[super dealloc];
}

@end