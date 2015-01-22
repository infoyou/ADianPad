
#import <Foundation/Foundation.h>

#define JsonManager [JsonNetManager sharedJsonNetManager]
@class JsonRequestItem;

typedef enum _KJsonNetStats
{
    KJNS_None=0,
    KJNS_Running,
} KJsonNetStats;

// interface JsonRequestDelegate
@protocol JsonRequestDelegate <NSObject>
-(NSString*) getKey:(NSString*)cmd;
@optional
-(void) jsonRequestFinish:(NSDictionary*)dict requestItem:(JsonRequestItem*)item;
-(void) jsonRequestFailed:(JsonRequestItem*)item;
-(void) startScroll;
-(void) checkJsonRequestBuffer:(JsonRequestItem*)item;
@end

// class JsonRequestItem
@interface JsonRequestItem : NSObject
{
    NSString*       type;
    NSDictionary*   json;
    
    KJsonNetStats   netstatus;
    id<JsonRequestDelegate> jsonDelegate;
    NSMutableData*  data;
    NSString*       key;
    NSURLConnection*   connect;
    BOOL done;
    
    NSString *commend;
    NSString *jsonurl;
    
    int sendlength;
}
@property (nonatomic,retain) NSString*          type;
@property (nonatomic,retain) NSDictionary*      json;
@property (nonatomic,assign) KJsonNetStats      netstatus;
@property (nonatomic,assign) id<JsonRequestDelegate> jsonDelegate;
@property (nonatomic,retain) NSMutableData*     data;
@property (nonatomic,retain) NSString*          key;
@property (nonatomic,retain) NSString*          custom;
@property (nonatomic,retain) NSString*          subType;
@property (nonatomic,retain) NSString*          commend;
@property (nonatomic,retain) NSString*          jsonurl;

+(NSDictionary*) requestSyncJson:(NSDictionary*)json withCmd:(NSString*)type withPost:(BOOL)bePost;

-(void) startRequest;
-(void) jsonRequestError;
-(NSString*) buildSendString;
-(NSString*) buildAsySendBase;
-(BOOL) checkUseBuffer;
-(void) resetConnection;
@end

// class JsonNetManager
@interface JsonNetManager : NSObject
{
	NSMutableArray* jsonCache;
    int             runcount;
    BOOL            frombuffer; // add for buffer
}
@property (nonatomic,retain) NSMutableArray* jsonCache;
@property (nonatomic,assign) BOOL            frombuffer;

+(JsonNetManager*) sharedJsonNetManager;

-(JsonRequestItem*) requestJson:(NSDictionary*)json type:(NSString*)type customid:(NSString*)customid jsonDelegate:(id<JsonRequestDelegate>)delegate;
-(JsonRequestItem*) requestJson:(NSDictionary*)json type:(NSString*)type commend:(NSString*)commend jsonurl:(NSString*)jsonurl jsonDelegate:(id<JsonRequestDelegate>)delegate;
-(JsonRequestItem*) requestJson:(NSDictionary*)json type:(NSString*)type jsonDelegate:(id<JsonRequestDelegate>)delegate;
-(BOOL) checkJson:(NSDictionary*)json type:(NSString*)type jsonDelegate:(id<JsonRequestDelegate>)delegate;
-(void) removeDelegate:(id<JsonRequestDelegate>)delegate;
-(void) checkRunNext:(JsonRequestItem*)item;

-(NSString*) jsonFilename:(NSString*)data;
-(void) initJsonPath;
-(void) saveRequestBuffer:(JsonRequestItem*)item response:(NSDictionary*)dict;
-(NSDictionary*) getRequestBuffer:(JsonRequestItem*)item;
-(NSDictionary*) getRequestBufferFromKey:(NSString*)key;

-(void) checkClearCache;
-(void) clearAllCache;

@end
