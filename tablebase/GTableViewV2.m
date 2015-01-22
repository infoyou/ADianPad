
#import "GTableViewV2.h"
#import "GDataObject.h"

@implementation GTableViewV2
@synthesize tableDelegate,dataArray;

-(id) initWithFrame:(CGRect)frame
{
	if((self = [super initWithFrame:frame style:UITableViewStylePlain])) 
	{
        dataArray=[[NSMutableArray alloc] initWithCapacity:10];
        self.extendDelegate=self;
        
        self.scrollEnabled=YES;
        self.scrollsToTop=YES;
	}
    return self;
}

-(BOOL) scrollViewShouldScrollToTop:(UIScrollView*)scrollView
{
    return YES; 
}

//-(void) scrollToRowAtIndexPath:(NSIndexPath*)indexPath atScrollPosition:(UITableViewScrollPosition)position animated:(BOOL)be
//{
//    [super scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:be];
//}
//
//-(void) scrollToTop:(BOOL)animated
//{
//    [self setContentOffset:CGPointMake(0,0) animated:animated];
//}

-(void) resetCell
{
    [dataArray removeAllObjects];
	[self reloadCell];
}

-(void) appendCell:(GDataObject*)data
{
    [dataArray addObject:data];
}
-(void) insetCell:(GDataObject *)data
{
    [dataArray insertObject:data atIndex:0];
}
-(void) removeCell:(int)indexcell
{
    if ([dataArray count]>indexcell) {
        [dataArray removeObjectAtIndex:indexcell];
    }

}
-(void) reloadCell
{
    [self refreshExtendTableWithData:dataArray withParam:nil];
}

// for ExtendableTableViewDelegate
-(CGFloat) heightForRow:(NSInteger)row atTable:(UITableView*)table 
{
    if(dataArray!=nil && row<[dataArray count])
    {
        GDataObject* data=[dataArray objectAtIndex:row];
        if(data!=nil && [data isKindOfClass:[GDataObject class]])
            return [data getCellHeight];
    }
    
	return 80;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableDelegate!= nil && [(NSObject*)tableDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
	{
        return [tableDelegate tableView:tableView canMoveRowAtIndexPath:indexPath];
	}
	return YES;
    
}
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(tableDelegate!= nil && [(NSObject*)tableDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
	{
        return [tableDelegate tableView:tableView canEditRowAtIndexPath:indexPath];
	}
	
	return YES;
}


-(void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(tableDelegate!=nil && [(NSObject*)tableDelegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)])
	{
        return [tableDelegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
	}
}

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath{
	if(tableDelegate!=nil  && [(NSObject*)tableDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
	{
        return [tableDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
	}
	if(self.editing)
		return UITableViewCellEditingStyleDelete;
	
	return UITableViewCellEditingStyleNone;
}
-(void) didSelectRow:(NSInteger)row atTable:(UITableView*)table withData:(id)data 
{
    if(dataArray==nil || row>=[dataArray count])
        return;
    
    if(tableDelegate!=nil && [(NSObject*)tableDelegate respondsToSelector:@selector(clickCell:)])
    {
        GDataObject* data=[dataArray objectAtIndex:row];
        if(data!=nil && [data isKindOfClass:[GDataObject class]])
            [tableDelegate clickCell:data];
    }
}

-(NSArray*) loadMoreTableFrom:(NSString*)index withNum:(NSString*)num andParam:(NSString*)param
{
    if(tableDelegate!=nil && [(NSObject*)tableDelegate respondsToSelector:@selector(loadMoreTableFrom:withNum:andParam:)])
    {
        return [tableDelegate loadMoreTableFrom:index withNum:num andParam:param];
    }
    else
        [self loadNormalStatus];
    
    return nil;
}

-(NSArray*) reloadTableWithData:(id)data
{
    if(tableDelegate!=nil && [(NSObject*)tableDelegate respondsToSelector:@selector(reloadTableWithData:)])
    {
        return [tableDelegate reloadTableWithData:data];
    }
    else
        [self loadNormalStatus];
    
    return nil;
}

-(void) scrollViewDidScroll:(UIScrollView*)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    if([(NSObject*)tableDelegate respondsToSelector:@selector(listScrolled)])
        [tableDelegate listScrolled];
}
//
-(void) extscrollViewWillBeginDragging:(UIScrollView*)scrollView
{
//    scrollY=scrollView.contentOffset.y;
}

-(void) dealloc
{
    [dataArray removeAllObjects];
    [dataArray release];
    
    [super dealloc];
}

@end
