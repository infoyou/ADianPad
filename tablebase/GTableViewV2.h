
#import "ExtendableTableViewV2.h"
#import "GTableView.h"

@class GDataObject;

@interface GTableViewV2 : ExtendableTableViewV2 <ExtendableTableViewDelegate>
{
	id<GTableViewDelegate>  tableDelegate;
    NSMutableArray*         dataArray;
}

@property (nonatomic,assign) id<GTableViewDelegate>     tableDelegate;
@property (nonatomic,readonly) NSMutableArray*          dataArray;

-(void) resetCell;
-(void) appendCell:(GDataObject*)data;
-(void) reloadCell;
-(void) insetCell:(GDataObject *)data;
-(void) removeCell:(int)indexcell;
@end
