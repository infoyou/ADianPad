
#import "GDataObject.h"
#import "GView.h"
#import "GDefine.h"
#import "UIView_Extras.h"

@implementation GDataObject
@synthesize cellData;
@synthesize selArrayData;
-(id) initWithDict:(NSDictionary*)dict
{
	if((self=[super init]))
    {
		[self loadData:dict];
	}
	return self;
}

-(void) loadData:(NSDictionary*)dict
{
    self.cellData=dict;
}

-(GView*) createCell
{
    GView* view=[[GView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [view buildLabel:@"default cell" position:CGPointMake(20, 20) font:Font(14) color:KBlackColor];
    return [view autorelease];
}

-(int) getCellHeight
{
    return 60;
}

-(void) dealloc
{
    self.cellData=nil;
    [selArrayData release];
	[super dealloc];
}

@end
