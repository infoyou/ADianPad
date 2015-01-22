
#import <Foundation/Foundation.h>

#define JsonManager2 [JsonNetManager2 sharedJsonNetManager]
@class JsonRequestItem2;

typedef enum _KJsonNetStats2
{
    KJNS2_None=0,
    KJNS2_Running,
} KJsonNetStats2;

// class JsonRequestItem2
@interface JsonRequestItem2 : NSObject
{
    NSString*       type;
    NSDictionary*   json;
    
    KJsonNetStats2   netstatus;
    NSMutableData*  data;
    NSURLConnection*   connect;
    BOOL done;
    
    int sendlength;
}
@property (nonatomic,retain) NSString*          type;
@property (nonatomic,retain) NSDictionary*      json;
@property (nonatomic,assign) KJsonNetStats2      netstatus;
@property (nonatomic,retain) NSMutableData*     data;
@property (nonatomic,retain) NSString*          custom;

-(NSDictionary*) getItemData;
+(JsonRequestItem2*) createItem:(NSDictionary*)dict;

-(void) startRequest;
-(void) jsonRequestError;
-(NSString*) buildSendString;
-(void) resetConnection;
@end

// class JsonNetManager2
@interface JsonNetManager2 : NSObject
{
	NSMutableArray* jsonCache;
    int             runcount;
    BOOL            frombuffer; // add for buffer
}
@property (nonatomic,retain) NSMutableArray* jsonCache;
@property (nonatomic,assign) BOOL            frombuffer;

+(JsonNetManager2*) sharedJsonNetManager;

-(JsonRequestItem2*) requestJson:(NSDictionary*)json type:(NSString*)type customid:(NSString*)customid;
-(JsonRequestItem2*) requestJson:(NSDictionary*)json type:(NSString*)type;
-(void) checkRunNext:(JsonRequestItem2*)item;

-(NSString*) jsonFilename;
-(void) saveJsons;
-(void) loadJsons;

@end
