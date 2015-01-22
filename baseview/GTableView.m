
#import "GTableView.h"

@implementation GTableView
@synthesize tableDelegate,cellarray;

-(id) initWithFrame:(CGRect)frame
{
	if((self = [super initWithFrame:frame style:UITableViewStylePlain])) 
	{
        cellarray=[[NSMutableArray alloc] initWithCapacity:10];
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
    [cellarray removeAllObjects];
	[self reloadCell];
    self.endOfTable=YES;
}

-(void) appendCell:(UIView*)view
{
    [cellarray addObject:view];
}
-(void) insertCell:(UIView*)view atIndex:(int)index
{
    [cellarray insertObject:view atIndex:index];
}
-(void) reloadCell
{
    [self refreshExtendTableWithData:cellarray withParam:nil];
}

// for ExtendableTableViewDelegate
-(CGFloat) heightForRow:(NSInteger)row atTable:(UITableView*)table 
{
    if(cellarray!=nil && row<[cellarray count])
    {
        UIView* view=[cellarray objectAtIndex:row];
        if(view!=nil && [view isKindOfClass:[UIView class]])
            return view.frame.size.height;
    }
    
	return 80;
}

-(void) didSelectRow:(NSInteger)row atTable:(UITableView*)table withData:(id)data 
{
    if(cellarray==nil || row>=[cellarray count])
        return;
    
    if(tableDelegate!=nil && [(NSObject*)tableDelegate respondsToSelector:@selector(clickCell:)])
    {
        UIView* view=[cellarray objectAtIndex:row];
        [tableDelegate clickCell:view];
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
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if([(NSObject*)tableDelegate respondsToSelector:@selector(listDidScrolled)])
        [tableDelegate listDidScrolled];

}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if([(NSObject*)tableDelegate respondsToSelector:@selector(listDidScrolled)])
//        [tableDelegate listDidScrolled];
//
//}
-(void) scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    if(scrollView.isDragging&&[(NSObject*)tableDelegate respondsToSelector:@selector(listScrolled)])
        [tableDelegate listScrolled];
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableDelegate!= nil && [(NSObject*)tableDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
	{
        [tableDelegate tableView:tableView canMoveRowAtIndexPath:indexPath];
	}
	return YES;

}
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(tableDelegate!= nil && [(NSObject*)tableDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
	{
		 [tableDelegate tableView:tableView canEditRowAtIndexPath:indexPath];
	}
	
	return YES;
}


-(void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(tableDelegate!=nil && [(NSObject*)tableDelegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) 
	{
		 [tableDelegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
	}
}

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath{
	if(tableDelegate!=nil  && [(NSObject*)tableDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) 
	{
		 [tableDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
	}
	if(self.editing)
		return UITableViewCellEditingStyleDelete;
	
	return UITableViewCellEditingStyleNone;
}


-(void) dealloc
{
    [cellarray removeAllObjects];
    [cellarray release];
    
    [super dealloc];
}

@end
