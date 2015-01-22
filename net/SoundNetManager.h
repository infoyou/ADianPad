
#import <Foundation/Foundation.h>

#define SoundManager [SoundNetManager sharedSoundNetManager]
@class SoundDownloadItem;

typedef enum _KSoundNetStats
{
    KSNS_None=0,
    KSNS_Downloading,
//    KSNS_Downloaded,
} KSoundNetStats;

// interface SoundDownloadDelegate
@protocol SoundDownloadDelegate <NSObject>
-(void) soundDownloadFinish:(NSData*)data downloadItem:(SoundDownloadItem*)item;
@optional
-(void) soundDownloadProgress:(NSNumber*)progress;
-(void) soundDownloadFailed:(SoundDownloadItem*)item;
@end

// class SoundDownloadItem
@interface SoundDownloadItem : NSObject
{
    NSString*       url;
    KSoundNetStats  netstatus;
    NSMutableArray* delegateArray; // id<SoundDownloadDelegate> delegate;
    
    NSMutableData*  data;
	double          totalSize;
	double          getSize;
    BOOL            needProcess;
    NSURLConnection*   connect;
}
@property (nonatomic,retain) NSString*          url;
@property (nonatomic,assign) KSoundNetStats     netstatus;
@property (nonatomic,assign) NSMutableArray*    delegateArray;
@property (nonatomic,retain) NSMutableData*     data;
@property (nonatomic,assign) BOOL               needProcess;
@property (nonatomic,assign) double             totalSize;
@property (nonatomic,assign) double             getSize;

-(void) startDownload;
-(void) getSoundError;
-(void) resetConnection;
@end

// class SoundNetManager
@interface SoundNetManager : NSObject
{
	NSMutableArray* soundCache;
}
@property (nonatomic,retain) NSMutableArray* soundCache;

+(SoundNetManager*) sharedSoundNetManager;

-(NSData*) reqSyncSound:(NSString*)url delegate:(id<SoundDownloadDelegate>)delegate;
-(NSData*) reqSound:(NSString*)url delegate:(id<SoundDownloadDelegate>)delegate needProcess:(BOOL)need;
-(void) preloadSound:(NSString*)url;
-(void) saveSound:(NSMutableData*)data downloadItem:(SoundDownloadItem*)item;
-(void) removeDelegate:(id<SoundDownloadDelegate>)delegate;
-(void) saveSound:(NSData*)data url:(NSString*)url;

-(BOOL) hasSoundBuffer:(NSString*)url;
-(NSData*) getSoundFromCache:(NSString*)url delegate:(id<SoundDownloadDelegate>)delegate;
-(void) getSoundFromNet:(NSString*)url delegate:(id<SoundDownloadDelegate>)delegate needProcess:(BOOL)need;
-(BOOL) checkSoundUrl:(NSString*)url delegate:(id<SoundDownloadDelegate>)delegate;

-(NSString*) soundFilename:(NSString*)url;
-(BOOL) writeSoundFile:(NSString*)url content:(NSData*)data;
-(void) initSoundPath;
-(void) writeSoundTimeSign:(NSString*)url;
-(void) checkClearCache;

-(void) clearSoundDir;
-(BOOL) renameFile:(NSString*)oldfilename withNewFileName:(NSString*)newfilename; // filename is url or local name

@end
