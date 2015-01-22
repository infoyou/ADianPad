
#import "ImageNetManager.h"
#import "NSString_Extras.h"
#import "GUtil.h"
//#import "WebPImage.h"
#import "GDefine.h"

#define LOGIMG(f) //NSLog(f)
#define LOGIMG2(f,a) //NSLog(f,a)
#define StrNull(f) (f==nil || ![f isKindOfClass:[NSString class]] || ([f isKindOfClass:[NSString class]] && [f isEqualToString:@""]))

#define MEMORYCACHESIZE 400
#define KDownImageNum 3
#define FileExsit(name) [[NSFileManager defaultManager] fileExistsAtPath:name]
#define KTimeCheckDel 300

#define KImageCachePathName @"imageNetCache"
#define KImageCacheDateSignName @".dat"
#define KImageTimeOutValue 50

static ImageNetManager* _sharedImageNetManager=nil;

@implementation NSObject(performSelectorOnMainThreadForObjs)
-(void) performSelectorOnMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2 waitUntilDone:(BOOL)wait
{
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if(!sig)
        return;
    
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&arg1 atIndex:2];
    [invo setArgument:&arg2 atIndex:3];
    [invo retainArguments];
    
    [invo performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
}
@end

@implementation ImageDownloadItem
@synthesize imgurl,netstatus,delegateArray,data,needProcess,totalSize,getSize;

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
    if(imgurl!=nil)
    {
        netstatus=KINS_Downloading;
        
        NSURLRequest* req=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imgurl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KImageTimeOutValue];
        //        [NSURLConnection connectionWithRequest:req delegate:self];
        connect=[[NSURLConnection alloc] initWithRequest:req delegate:self];
        
        [req release];
        self.data=[NSMutableData data];
    }
}

-(void) connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    LOGIMG2(@"connection didReceiveResponse: %@",imgurl);
	totalSize=response.expectedContentLength;
    if(totalSize<=0)
    {
        NSLog(@"response.expectedContentLength: 0 !!");
        [self getImageError];
    }
	getSize=0;
}

-(void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)imgdata
{
    LOGIMG2(@"connection didReceiveData: %@",imgurl);
	[data appendData:imgdata];
	if(!needProcess)
        return;
    
    getSize+=[imgdata length];
    double val=0;
    if(totalSize>0)
        val=getSize/totalSize;
    NSNumber* num=[NSNumber numberWithDouble:val];
    
    for(id<ImageDownloadDelegate> delegate in delegateArray)
    {
        if(delegate!=nil && [(NSObject*)delegate respondsToSelector:@selector(imageDownloadProgress:)])
        {
            [delegate imageDownloadProgress:num];
        }
	}
}

-(void) connectionDidFinishLoading:(NSURLConnection*)connection 
{
    LOGIMG2(@"connectionDidFinishLoading: %@",imgurl);
    [GUtil addFlow2:(KImageHttpHeaderSendLength+KImageHttpHeaderRecvLength+totalSize)];
    
	NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
    
	UIImage* img=[[UIImage alloc] initWithData:data];
//    UIImage* img=[[WebPImage loadWebPFromData:data] retain];
    if(img)
    {
        [ImageManager saveImage:img downloadItem:self];
        
        for(id<ImageDownloadDelegate> delegate in delegateArray)
        {
            if([(NSObject*)delegate respondsToSelector:@selector(imageDownloadFinish:downloadItem:)])
            {
                [delegate imageDownloadFinish:img downloadItem:self];
            }
        }
        
        [img release];
        self.data=nil;
        [self resetConnection];
    }
    else 
    {
        NSLog(@"ImageNetManager: Image data error");
        [self getImageError];
    }
    
	[pool release];
}

-(void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    LOGIMG2(@"connection didFailWithError: %@",imgurl);
    NSLog(@"ImageNetManager: Image net error : %@",error);
    [self getImageError];
}

-(void) getImageError
{
    [ImageManager saveImage:nil downloadItem:self];
    
    for(id<ImageDownloadDelegate> delegate in delegateArray)
    {
        if([(NSObject*)delegate respondsToSelector:@selector(imageDownloadFailed:)])
        {
            [delegate imageDownloadFailed:self];
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
    self.imgurl=nil;
    [delegateArray removeAllObjects];
    [delegateArray release];
    [super dealloc];
}
@end

@implementation ImageNetManager
@synthesize imageCache;

+(ImageNetManager*) sharedImageNetManager
{
	if(_sharedImageNetManager==nil)
    {
		_sharedImageNetManager=[[ImageNetManager alloc] init];
	}
	return _sharedImageNetManager;
}

-(id) init
{
	if((self=[super init]))
    {
		imageCache=[[NSMutableArray alloc] initWithCapacity:MEMORYCACHESIZE];
        [self initImagePath];
	}
	return self;
}

-(UIImage*) reqSyncImage:(NSString*)imgurl imgDelegate:(id<ImageDownloadDelegate>)delegate
{
    if(StrNull(imgurl) || imgurl.length<=0)
        return nil;
    
    NSString* filename=[self imgFilename:imgurl];
    if(FileExsit(filename))
    {
        [self writeImageTimeSign:imgurl]; // update time sign
		return [[[UIImage alloc] initWithContentsOfFile:filename] autorelease];
//        return [WebPImage loadWebPFromFile:filename];
    }
    else
    {
        [self getImageFromNet:imgurl imgDelegate:delegate needProcess:NO];
        return nil;
    }
}

-(UIImage*) reqImage:(NSString*)imgurl imgDelegate:(id<ImageDownloadDelegate>)delegate needProcess:(BOOL)need
{
    LOGIMG2(@"reqImage: %@",imgurl);
    if(StrNull(imgurl) || imgurl.length<=0)
        return nil;
        
    NSString* filename=[self imgFilename:imgurl];
    if(FileExsit(filename))
        [self getImageFromCache:imgurl imgDelegate:delegate];
    else
        [self getImageFromNet:imgurl imgDelegate:delegate needProcess:need];
    
    return nil;
}

-(void) preloadImage:(NSString*)imgurl
{
    [self reqImage:imgurl imgDelegate:nil needProcess:NO];
}

-(void) saveImage:(UIImage*)img downloadItem:(ImageDownloadItem*)item
{
	NSData* data=UIImageJPEGRepresentation(img,KJpgQuality);//UIImagePNGRepresentation(img);
    [self saveImageData:data downloadItem:item];
}

-(void) saveImageData:(NSData*)imgdata downloadItem:(ImageDownloadItem*)item
{
    if(imgdata!=nil)
    {
        NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
        if(YES!=[self writeImageFile:item.imgurl content:imgdata])
        {
            NSLog(@"save fail");
        }
        else // write ok, create time sign
        {
            [self writeImageTimeSign:item.imgurl];
        }
        [pool release];
    }
    
    [imageCache removeObject:item];
    for(ImageDownloadItem* it in imageCache)
    {
        if(it.netstatus==KINS_None)
        {
            [it startDownload];
            break;
        }
    }
    
	[self checkClearCache];
}

-(void) saveImage:(UIImage*)img imgurl:(NSString*)imgurl
{
	NSData* data=UIImageJPEGRepresentation(img,KJpgQuality);//UIImagePNGRepresentation(img);
    [self saveImageData:data imgurl:imgurl];
}

-(void) saveImageData:(NSData*)imgdata imgurl:(NSString*)imgurl
{
	NSString* filename=[self imgFilename:imgurl];
//    if(FileExsit(filename))
//    {
//        NSFileManager* file=[NSFileManager defaultManager];
//        NSError* err=nil;
//        [file removeItemAtPath:filename error:&err];
//    }
    
	[imgdata writeToFile:filename atomically:YES];
    [self writeImageTimeSign:imgurl];
}

-(void) removeDelegate:(id<ImageDownloadDelegate>)delegate
{
    for(ImageDownloadItem* item in imageCache)
    {
        [item.delegateArray removeObject:delegate];
    }
}

-(BOOL) hasImageBuffer:(NSString*)imgurl
{
    NSString* filename=[self imgFilename:imgurl];
    return FileExsit(filename);
}

//typedef void (^ImgFun)(void);
//-(UIImage*) getImageFromCache:(NSString*)imgurl imgDelegate:(id<ImageDownloadDelegate>)delegate // use block
//{
//    NSString* filename=[self imgFilename:imgurl];
//    ImgFun imgfun=^(void)
//    {
//        UIImage* img=[[UIImage alloc] initWithContentsOfFile:filename];
//        UIImage* img=[[WebPImage loadWebPFromFile:filename] retain];
//        if(img)
//        {
//            if([(NSObject*)delegate respondsToSelector:@selector(imageDownloadFinish:downloadItem:)])
//            {
//                [delegate imageDownloadFinish:img downloadItem:nil];
//            }
//            
//            [img release];
//            [self writeImageTimeSign:imgurl];
//        }
//    };
//    
//    dispatch_async(dispatch_get_main_queue(), imgfun);
//    return nil;
//}

-(UIImage*) getImageFromCache:(NSString*)imgurl imgDelegate:(id<ImageDownloadDelegate>)delegate // use thread
{
    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:imgurl,@"imgurl",delegate,@"imgdelegate", nil];
//    [NSThread detachNewThreadSelector:@selector(getLocalImage:) toTarget:self withObject:dict];
    
    NSThread* t1=[[NSThread alloc] initWithTarget:self selector:@selector(getLocalImage:) object:dict];
    [t1 setStackSize:1024*1024];
    [t1 setThreadPriority:0.9];
    [[t1 autorelease] start];
    return nil;
}

-(void) getLocalImage:(NSDictionary*)dict
{
    NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
    
    id<ImageDownloadDelegate> delegate=[dict objectForKey:@"imgdelegate"];
    NSString* imgurl=[dict objectForKey:@"imgurl"];
    NSString* filename=[self imgFilename:imgurl];
    
    UIImage* img=[[UIImage alloc] initWithContentsOfFile:filename];
//    UIImage* img=[[WebPImage loadWebPFromFile:filename] retain];
    if(img)
    {
        if([(NSObject*)delegate respondsToSelector:@selector(imageDownloadFinish:downloadItem:)])
        {
            ImageDownloadItem* item=[[ImageDownloadItem alloc] init];
            item.imgurl=imgurl;
            
//            [(NSObject*)delegate performSelectorOnMainThread:@selector(imageDownloadFinish:downloadItem:) withObject:img waitUntilDone:NO];
            [(NSObject*)delegate performSelectorOnMainThread:@selector(imageDownloadFinish:downloadItem:) withObject:img withObject:item waitUntilDone:NO];
            [item release];
        }
        
        [img release];
        [self writeImageTimeSign:imgurl];
    }
    
    [pool release];
}

-(void) getImageFromNet:(NSString*)imgurl imgDelegate:(id<ImageDownloadDelegate>)delegate needProcess:(BOOL)need
{
//    NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:imgurl,@"imgurl",delegate,@"imgdelegate",[NSNumber numberWithBool:need],@"needProcess",  nil];
//    [NSThread detachNewThreadSelector:@selector(getNetImage:) toTarget:self withObject:dict];
//}
//
//-(void) getNetImage:(NSDictionary*)dict
//{
//    NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
//    
//    NSString* imgurl=[dict objectForKey:@"imgurl"];
//    id<ImageDownloadDelegate> delegate=[dict objectForKey:@"imgdelegate"];
//    BOOL need=[[dict objectForKey:@"needProcess"] boolValue];
    
    LOGIMG2(@"getImageFromNet: %@",imgurl);
    if([self checkImageUrl:imgurl imgDelegate:delegate])
    {
        ImageDownloadItem* item=[[ImageDownloadItem alloc] init];
        item.imgurl=imgurl;
        item.needProcess=need;
        item.netstatus=KINS_None;
        
        if(delegate!=nil)
            [item.delegateArray addObject:delegate];
        
        [imageCache addObject:item];
        if(KDownImageNum>=[imageCache count])
        {
            [item startDownload];
        }
        [item release];
    }
    
//    [pool release];
}

-(UIImage*) simpleGetImage:(NSString*)imgurl
{
    NSString* filename=[self imgFilename:imgurl];
    if(!FileExsit(filename))
        return nil;
    
    return [UIImage imageWithContentsOfFile:filename];
//    return [WebPImage loadWebPFromFile:filename];
}

-(BOOL) checkImageUrl:(NSString*)imgurl imgDelegate:(id<ImageDownloadDelegate>)delegate
{
    LOGIMG2(@"checkImageUrl: %@",imgurl);
    for(ImageDownloadItem* item in imageCache)
    {
        if([item.imgurl isEqualToString:imgurl])
        {
            if(item.netstatus==KINS_None) // change download array order
            {
                ImageDownloadItem* item2=[item retain];
                [imageCache removeObject:item];
                [imageCache insertObject:item2 atIndex:KDownImageNum];
                [item release];
            }
            else if(item.netstatus==KINS_Downloading && item.needProcess) // update process
            {
                float num=0;
                if(item.totalSize>0)
                    num=item.getSize/item.totalSize;
                
                if(num>0 && delegate!=nil && [(NSObject*)delegate respondsToSelector:@selector(imageDownloadProgress:)])
                {
                    NSNumber* nsnum=[NSNumber numberWithDouble:num];
                    [delegate imageDownloadProgress:nsnum];
                }
            }
            
            bool has=false;
            for(id<ImageDownloadDelegate> dg in item.delegateArray) // add delegate
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

-(NSString*) imgFilename:(NSString*)imgurl
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	
	NSString *imageDirectory=[documentsDirectory stringByAppendingPathComponent:KImageCachePathName];
    NSString* allfilename=nil;
    
    if(imgurl!=nil)
    {
        NSString* filename=[imgurl MD5Hash];
        allfilename=[NSString stringWithFormat:@"%@/%@",imageDirectory,filename];
    }
    else
        allfilename=[NSString stringWithFormat:@"%@",imageDirectory];
    
	return allfilename;
}

-(BOOL) writeImageFile:(NSString*)imgurl content:(NSData*)imgdata
{
    NSString* filename=[self imgFilename:imgurl];
	return [imgdata writeToFile:filename atomically:YES];
}

-(void) writeImageTimeSign:(NSString*)imgurl
{
    NSString* filename=[self imgFilename:imgurl];
    NSString* datefile=[filename stringByAppendingString:KImageCacheDateSignName];
    
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
    LOGIMG(@"checkClearCache");
    NSFileManager* file=[NSFileManager defaultManager];
    NSError* err=nil;
    
    NSString* path=[self imgFilename:nil];
    NSArray* filearray=[file contentsOfDirectoryAtPath:path error:&err];
    
    if([filearray count]<MEMORYCACHESIZE)
        return;
    
    NSTimeInterval now=[[NSDate date] timeIntervalSince1970];
    for(NSString* filename in filearray)
    {
        //        if([[filename pathExtension] isEqualToString:KImageCacheDateSignName])
        if([filename hasSuffix:KImageCacheDateSignName])
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
                NSRange ran={0,[fullname length]-[KImageCacheDateSignName length]};
                NSString* imgfullname=[fullname substringWithRange:ran];
                
                [file removeItemAtPath:fullname error:&err];
                [file removeItemAtPath:imgfullname error:&err];
                LOGIMG2(@"del cache: %@",imgfullname);
            }
        }
    }
}

-(void) initImagePath
{
    NSFileManager* file=[NSFileManager defaultManager];
    NSError* err=nil;
    
    NSString* path=[self imgFilename:nil];
    NSArray* dirContents=[file contentsOfDirectoryAtPath:path error:&err];
    
    if(dirContents==nil)
        [file createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
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
    NSString* oldname=[self imgFilename:oldfilename];
    NSString* newname=[self imgFilename:newfilename];
    
    [self rename:oldname withNewFileName:newname];
    [self rename:[oldname stringByAppendingString:KImageCacheDateSignName] withNewFileName:[newname stringByAppendingString:KImageCacheDateSignName]];
    
    return YES;
}

+(BOOL) deleteFile:(NSString*)filename
{
    NSFileManager* file=[NSFileManager defaultManager];
    NSError* err=nil;
    
    if(FileExsit(filename))
        return [file removeItemAtPath:filename error:&err];
    
    return NO;
}

-(void) dealloc
{
    NSLog(@"memory warning ??? ImageNetManager ````````````````````````");
    [imageCache removeAllObjects];
    [imageCache release];
    _sharedImageNetManager=nil;
    
	[super dealloc];
}

@end