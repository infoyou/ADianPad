
#import "ExtendableTableView.h"

@protocol GTableViewDelegate
@optional
    -(void) clickCell:(id)sender; // GDataObject or GView
    -(NSArray*) loadMoreTableFrom:(NSString*)index withNum:(NSString*)num andParam:(NSString*)param;
    -(NSArray*) reloadTableWithData:(id)data;
    -(void) listScrolled;
- (void) listDidScrolled;
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
    - (BOOL) tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath;
    -(void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath;
    -(UITableViewCellEditingStyle) tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath;
@end

@interface GTableView : ExtendableTableView <UITableViewDelegate,ExtendableTableViewDelegate>
{
	id<GTableViewDelegate>  tableDelegate;
    NSMutableArray*         cellarray;
}

@property (nonatomic,assign) id<GTableViewDelegate>     tableDelegate;
@property (nonatomic,readonly) NSMutableArray*          cellarray;

-(void) resetCell;
-(void) appendCell:(UIView*)view;
-(void) insertCell:(UIView*)view atIndex:(int)index;
-(void) reloadCell;

@end
