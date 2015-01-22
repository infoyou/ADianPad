
#import <Foundation/Foundation.h>

@class JsonUploadManager;
@class EventController;

@interface UploadItem : NSObject<NSCoding>
{
}

@property (nonatomic, retain) JsonUploadManager* upload;

@property (nonatomic, copy) NSString* imgLocalName;
@property (nonatomic, copy) NSString* audioLocalName;
@property (nonatomic, copy) NSString* imgServerName; // use this check if has upload bin ok
@property (nonatomic, copy) NSString* audioServerName;

@property (nonatomic, copy) NSString* filter;
@property (nonatomic, copy) NSString* lat;
@property (nonatomic, copy) NSString* lon;
@property (nonatomic, copy) NSString* poi;
@property (nonatomic, copy) NSString* poiid;

@property (nonatomic, assign) int imgWidth;
@property (nonatomic, assign) int imgHeight;
@property (nonatomic, assign) int audioLength;
@property (nonatomic, assign) BOOL metaSending;

-(void) clearUpload;
-(NSDictionary*) getItemData;
+(UploadItem*) createItem:(NSDictionary*)dict;

@end

@interface UploadItem2 : NSObject
{
}

@property (nonatomic, retain) NSDictionary* uploadDict;
@property (nonatomic, assign) EventController* eventControl;
@property (nonatomic, copy) NSString* key;
@property (nonatomic, assign) int type;

@end

@protocol JsonUploadManagerDelegate
-(void) uploadFinished:(NSDictionary*)dict manager:(JsonUploadManager*)manager;
@optional
-(void) uploadProcess:(float)process manager:(JsonUploadManager*)manager;
@end

#define KEventUpload [EventUpload sharedEventUpload]
@interface EventUpload : NSObject<JsonUploadManagerDelegate>
{
    BOOL uploading;
    NSMutableArray* uploads;
}
@property (nonatomic, retain) JsonUploadManager* upload;

+(EventUpload*) sharedEventUpload;
-(void) appendUploadItem:(NSString*)key control:(EventController*)event uploadData:(NSDictionary*)data;
-(void) appendUploadItem:(NSString*)key control:(EventController*)event uploadData:(NSDictionary*)data type:(int)type;
-(void) checkUploadNext;
-(void) clearEvent:(EventController*)event;

@end

@interface JsonUploadManager : NSObject
{
    NSData* imageData;
    NSData* soundData;
    NSString* cmdType;
    NSDictionary* uploadData;
    NSString* photoName;
    
    id<JsonUploadManagerDelegate> delegate;
    BOOL beSync;
    NSMutableData*  recvdata;
    NSURLConnection* connect;
    BOOL done;
    int sendlength;
}

@property (nonatomic, retain) NSData* imageData;
@property (nonatomic, retain) NSData* soundData;
@property (nonatomic, retain) NSDictionary* uploadData;
@property (nonatomic, copy) NSString* cmdType;
@property (nonatomic, copy) NSString* photoName;
@property (nonatomic, assign) id<JsonUploadManagerDelegate> delegate;
@property (nonatomic, copy) NSString* customid;

-(NSDictionary*) startUpload; 

-(void) asyncUpload:(NSData*)imgdata delegate:(id<JsonUploadManagerDelegate>)uploaddelegate type:(NSString*)type photoName:(NSString*)photoName;
-(void) asyncUpload:(NSData*)imgdata sounddata:(NSData*)sounddata delegate:(id<JsonUploadManagerDelegate>)uploaddelegate type:(NSString*)type uploadData:(NSDictionary*)data;
-(void) cancelUpload;

-(NSMutableDictionary*) buildJsonString; // for custom json data

@end
