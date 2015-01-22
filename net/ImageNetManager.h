
#import <Foundation/Foundation.h>

@interface NSObject(performSelectorOnMainThreadForObjs)
-(void) performSelectorOnMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2 waitUntilDone:(BOOL)wait;
@end

#define ImageManager [ImageNetManager sharedImageNetManager]
@class ImageDownloadItem;

typedef enum _KImageNetStats
{
    KINS_None=0,
    KINS_Downloading,
//    KINS_Downloaded,
} KImageNetStats;

// interface ImageDownloadDelegate
@protocol ImageDownloadDelegate <NSObject>
-(void) imageDownloadFinish:(UIImage*)img downloadItem:(ImageDownloadItem*)item;
@optional
-(void) imageDownloadProgress:(NSNumber*)progress;
-(void) imageDownloadFailed:(ImageDownloadItem*)item;
@end

// class ImageDownloadItem
@interface ImageDownloadItem : NSObject
{
    NSString*       imgurl;
    KImageNetStats  netstatus;
    NSMutableArray* delegateArray; // id<ImageDownloadDelegate> imgDelegate;
    
    NSMutableData*  data;
	double          totalSize;
	double          getSize;
    BOOL            needProcess;
    NSURLConnection*   connect;
}
@property (nonatomic,retain) NSString*          imgurl;
@property (nonatomic,assign) KImageNetStats     netstatus;
@property (nonatomic,assign) NSMutableArray*    delegateArray;
@property (nonatomic,retain) NSMutableData*     data;
@property (nonatomic,assign) BOOL               needProcess;
@property (nonatomic,assign) double             totalSize;
@property (nonatomic,assign) double             getSize;

-(void) startDownload;
-(void) getImageError;
-(void) resetConnection;
@end

// class ImageNetManager
@interface ImageNetManager : NSObject
{
	NSMutableArray* imageCache;
}
@property (nonatomic,retain) NSMutableArray* imageCache;

+(ImageNetManager*) sharedImageNetManager;

-(UIImage*) reqSyncImage:(NSString*)imgurl imgDelegate:(id<ImageDownloadDelegate>)delegate;
-(UIImage*) reqImage:(NSString*)imgurl imgDelegate:(id<ImageDownloadDelegate>)delegate needProcess:(BOOL)need;
-(void) preloadImage:(NSString*)imgurl;
//-(void) saveImage:(NSMutableData*)imgdata downloadItem:(ImageDownloadItem*)item;
-(void) saveImage:(UIImage*)img downloadItem:(ImageDownloadItem*)item;
-(void) removeDelegate:(id<ImageDownloadDelegate>)delegate;
-(void) saveImage:(UIImage*)img imgurl:(NSString*)imgurl; // save png
-(void) saveImageData:(NSData*)imgdata imgurl:(NSString*)imgurl;

-(BOOL) hasImageBuffer:(NSString*)imgurl;
-(UIImage*) getImageFromCache:(NSString*)imgurl imgDelegate:(id<ImageDownloadDelegate>)delegate;
-(void) getImageFromNet:(NSString*)imgurl imgDelegate:(id<ImageDownloadDelegate>)delegate needProcess:(BOOL)need;
-(BOOL) checkImageUrl:(NSString*)imgurl imgDelegate:(id<ImageDownloadDelegate>)delegate;

-(NSString*) imgFilename:(NSString*)imgurl;
-(BOOL) writeImageFile:(NSString*)imgurl content:(NSData*)imgdata;
-(void) initImagePath;
-(void) writeImageTimeSign:(NSString*)imgurl;
-(void) checkClearCache;

-(BOOL) renameFile:(NSString*)oldfilename withNewFileName:(NSString*)newfilename; // filename is url or local name
+(BOOL) deleteFile:(NSString*)filename;
-(UIImage*) simpleGetImage:(NSString*)imgurl;

@end
