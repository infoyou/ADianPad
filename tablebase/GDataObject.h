
#import <Foundation/Foundation.h>

@class GView;

@interface GDataObject : NSObject
{
	NSDictionary* cellData;
    NSMutableArray *selArrayData;
}

@property (nonatomic, retain) NSDictionary* cellData;
@property (nonatomic,retain) NSMutableArray *selArrayData;;
-(id) initWithDict:(NSDictionary*)dict;
-(void) loadData:(NSDictionary*)dict;

-(GView*) createCell;
-(int) getCellHeight;
@end
