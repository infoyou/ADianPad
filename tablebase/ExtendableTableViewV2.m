
#import "ExtendableTableViewV2.h"
//#import "GCellAd.h"
#import "GDefine.h"
#import "GDataObject.h"
#import "UIView_Extras.h"
#import "UIView_Extras.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define KTagTipGetMoreLab 4892

@interface ExtendableTableViewV2 (Private)
-(void) loadSubviews;
@end

@implementation ExtendableTableViewV2

@synthesize headerView = _headerView;
@synthesize cellDataArray = _cellDataArray;
@synthesize extendDelegate;
@synthesize _contentType;
@synthesize freshOff,endOfTable,contentHeight;

-(void) myinit
{
	self.delegate = self;
	self.dataSource = self;
	[self loadSubviews];
	self.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.separatorColor=KC_CELL_LINE;
    
    bufferVisibleCells=[[NSMutableArray alloc] init];
    bufferVisibleIndexs=[[NSMutableArray alloc] init];
}

-(void) awakeFromNib
{
    [self myinit];
}

-(id) initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        [self myinit];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	if((self = [super initWithFrame:frame style:style]))
    {
        [self myinit];
    }
    return self;
}

-(void) dealloc
{
	[_headerView release];
	[_cellDataArray release];
	[_contentType release];
	[_headerColor release];
    
    [bufferVisibleCells release];
    [bufferVisibleIndexs release];
    [super dealloc];
}

-(void) loadSubviews
{
	curIndex = 0;
	stepLength = 10;
	totalNum = MAXCOUNT;
	
	self.backgroundColor = [UIColor clearColor];
	self.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	_headerView = [[RefreshTableHeader alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.frame.size.height, 320.0f, self.frame.size.height)];
	[self addSubview:_headerView];
    
	if(_headerColor != nil)
		_headerView.backgroundColor = _headerColor;
    else
		_headerView.backgroundColor = [UIColor clearColor];
	
//	UIActivityIndicatorView *moreLoadingV = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(20, KTableFootIndicatorY, 20.0, 20.0)];
	UIActivityIndicatorView *moreLoadingV = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((KScreenWidth-20)/2, KTableFootIndicatorY, 20.0, 20.0)];
	moreLoadingV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	moreLoadingV.backgroundColor = [UIColor clearColor];
	moreLoadingV.tag = 100;
	UILabel * moreLoadingL = [[UILabel alloc] initWithFrame:CGRectMake(135, KTableFootMoreY, 100.0, 30.0)];
	moreLoadingL.backgroundColor = [UIColor clearColor];
//	moreLoadingL.textColor = [UIColor grayColor];
    moreLoadingL.textColor = KPTxtLightGray;
    moreLoadingL.font=FontBold(14);
	moreLoadingL.text = NSLocalizedString(@"PP_More_", @"");
	moreLoadingL.tag = 101;
	
	UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, KTableFootHeight)];
	footV.backgroundColor = [UIColor clearColor];
	
	[footV addSubview:moreLoadingV];
	[footV addSubview:moreLoadingL];
	
	moreLoadingL.hidden = YES;
	moreLoadingV.hidden = YES;
	
	[moreLoadingV release];
	[moreLoadingL release];
	
	self.tableFooterView = footV;
	[footV release];
    
//    UILabel* lab=[footV buildCenterLabel:LTXT(PP_DragUpGetMore) top:KTableFootTipY font:FontBold(16) color:[UIColor grayColor]];
    UILabel* lab=[footV buildCenterLabel:LTXT(PP_DragUpGetMore) top:KTableFootTipY font:FontBold(14) color:KPTxtLightGray];
    lab.tag=KTagTipGetMoreLab;
    [self setEndOfTable:YES];
    [self setHiddenGetMoreLab:YES];
}

-(void) setGetMoreLabOffset
{
    [self.tableFooterView viewWithTag:KTagTipGetMoreLab].left-=30;
    [self.tableFooterView viewWithTag:101].left-=10;
}

-(void) setHiddenGetMoreLab:(BOOL)hidden
{
    UILabel* lab=(UILabel*)[self.tableFooterView viewWithTag:KTagTipGetMoreLab];
    if(lab!=nil && [lab isKindOfClass:[UILabel class]])
        lab.hidden=hidden;
}

#pragma mark UITableViewDataSource
-(NSInteger) tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
	return [_cellDataArray count];
}

-(UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath 
{
	static NSString* cellIdentifier = @"vlingdi_tabele_v2";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    NSLog(@"cellForRowAtIndexPath,%d",indexPath.row);
	if(cell == nil)
    {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.textLabel.text = @"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if([cell.contentView subviews] != nil)
    {
//        for(UIView *v in [cell.contentView subviews])
//            [v removeFromSuperview];
        
        if(ValidArray(bufferVisibleIndexs))
        {
            for(int k=[bufferVisibleIndexs count]-1;k>=0;k--)
            {
                NSIndexPath* ip=nil;
                UIView* view=nil;
                if([bufferVisibleIndexs count]>k && [bufferVisibleCells count]>k)
                {
                    ip=[bufferVisibleIndexs objectAtIndex:k];
                    view=[bufferVisibleCells objectAtIndex:k];
                }
                
                if(ip!=nil && [ip compare:indexPath]==NSOrderedSame)
                {
                    for(UIView *v in [cell.contentView subviews])
                        [v removeFromSuperview];
                    
                    [cell.contentView addSubview:view];
                    [bufferVisibleCells removeObjectAtIndex:k];
                    [bufferVisibleIndexs removeObjectAtIndex:k];
                    return cell;
                }
            }
        }
	}
    
    id celldata = nil;
    if([_cellDataArray count]>indexPath.row)
        celldata=[_cellDataArray objectAtIndex:indexPath.row];
    
    if([celldata isKindOfClass:[GDataObject class]])
    {
        {
            for(UIView *v in [cell.contentView subviews])
                [v removeFromSuperview];
            
            UIView* v = (UIView*)[(GDataObject*)celldata createCell];
            [cell.contentView addSubview:v];
        }
    }
    
    return cell;
}

-(void) clearVisibleBuffer
{
    NSMutableArray* cells=(NSMutableArray*)self.visibleCells;
    NSMutableArray* indexs=(NSMutableArray*)self.indexPathsForVisibleRows;
    [cells removeAllObjects];
    [indexs removeAllObjects];
}

#pragma mark UITableViewDelegate
-(CGFloat) tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
	if(extendDelegate != nil && [extendDelegate respondsToSelector:@selector(exTableView:heightForHeaderInSection:)]) 
		return [extendDelegate exTableView:tableView heightForHeaderInSection:section];
    
	return 0.0;
}

-(UIView*) tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
	if(extendDelegate != nil && [extendDelegate respondsToSelector:@selector(exTableView:viewForHeaderInSection:)]) 
		return [extendDelegate exTableView:tableView viewForHeaderInSection:section];
    
	return nil;
}

-(CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	//This block can not work with indexPath.section
	if(extendDelegate != nil && [extendDelegate respondsToSelector:@selector(heightForRow:atTable:)]) 
	{
		CGFloat rowH = [extendDelegate heightForRow:indexPath.row atTable:tableView];
		contentHeight = contentHeight + rowH;
		return rowH;
	}
	//This is new
	if(extendDelegate && [extendDelegate respondsToSelector:@selector(exHeightForIndexPath:atTable:)])
	{
		CGFloat rowH = [extendDelegate exHeightForIndexPath:indexPath atTable:tableView];
		contentHeight = contentHeight + rowH;
		return rowH;
	}
	CGFloat rowH = 0;
	id celldata = [_cellDataArray objectAtIndex:indexPath.row];
	if([celldata isKindOfClass:[GDataObject class]])
		rowH = [(GDataObject*)celldata getCellHeight];
    
	contentHeight = contentHeight + rowH;
	return rowH;
}

-(void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(extendDelegate != nil && [extendDelegate respondsToSelector:@selector(didSelectRow:atTable:withData:)])
    {
		[extendDelegate didSelectRow:indexPath.row 
							 atTable:tableView 
							withData:[NSDictionary dictionaryWithObjectsAndKeys:_contentType, @"type",[_cellDataArray objectAtIndex:indexPath.row],@"data",nil]];
	}
}

-(BOOL) tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(extendDelegate!= nil && ![extendDelegate isKindOfClass:[ExtendableTableViewV2 class]] && [extendDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
		return [extendDelegate tableView:tableView canEditRowAtIndexPath:indexPath];
	
	return YES;
}

-(void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(extendDelegate!=nil && [extendDelegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)])
        [extendDelegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

-(UITableViewCellEditingStyle) tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(extendDelegate!=nil)
    {
        if(![extendDelegate isKindOfClass:[ExtendableTableViewV2 class]])
        {
            if([extendDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
            {
                
            }
        }
    }
	if(extendDelegate!=nil && ![extendDelegate isKindOfClass:[ExtendableTableViewV2 class]] && [extendDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
		return [extendDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    
	if(self.editing)
		return UITableViewCellEditingStyleDelete;
	
	return UITableViewCellEditingStyleNone;
}

-(void) scrollViewDidScroll:(UIScrollView*)scrollView
{
	if(freshOff) return;
    
    //    NSLog(@"scrollViewDidScroll--offset--%f", scrollView.contentOffset.y);
	if(scrollView.isDragging)
    {
		if(_headerView.state == HeaderRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loadState)
			[_headerView setState:HeaderRefreshNormal];
		else if(_headerView.state == HeaderRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loadState)
			[_headerView setState:HeaderRefreshPulling];
	}
    
    const static float KLimitOffset=-190;
    if(scrollView.contentOffset.y < KLimitOffset)
        scrollView.contentOffset=CGPointMake(scrollView.contentOffset.x, KLimitOffset);
    
    if (extendDelegate != nil && [extendDelegate respondsToSelector:@selector(extScrollViewDidScroll:)])
        [extendDelegate extScrollViewDidScroll:scrollView];
}

-(void) setStatusRefresh
{
    if(freshOff || self.contentOffset.y <= -65)
        return;
    
    _loadState=0;
    self.contentOffset=CGPointMake(0, -65);
    beSetRefreash=YES;
    [self scrollViewDidEndDragging:self willDecelerate:NO];
    beSetRefreash=NO;
}

-(void) mainRefresh
{
    self.contentOffset=CGPointMake(0, -80);
    [_headerView setState:HeaderRefreshLoading];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
    
    //here reload tableview data,may be neen runloop to notify the pulled view to scroll up
    if(extendDelegate != nil && [extendDelegate respondsToSelector:@selector(reloadTableWithData:)])
    {
        curIndex = 0;
        if(!beSetRefreash)
            [extendDelegate reloadTableWithData:_contentType];
        
       NSLog(@"_contentType====%@",_contentType);
    }
}

-(void) mainGetMore
{
    UIActivityIndicatorView *av = (UIActivityIndicatorView*)[self.tableFooterView viewWithTag:100];
//    UILabel *ml = (UILabel*)[self.tableFooterView viewWithTag:101];
//    ml.hidden = NO;
    [av startAnimating];
    //av.hidden = NO;
    [self setHiddenGetMoreLab:YES];
    
    [_headerView setState:HeaderRefreshLoading];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
    
    //request again, and add new data into array,reload data
    if(extendDelegate != nil && [extendDelegate respondsToSelector:@selector(loadMoreTableFrom:withNum:andParam:)])
    {
        [self performSelector:@selector(bufferCellViews) withObject:nil afterDelay:0.21];
        [extendDelegate loadMoreTableFrom:[NSString stringWithFormat:@"%d", curIndex]
                                  withNum:[NSString stringWithFormat:@"%d", stepLength]
                                 andParam:_contentType];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (extendDelegate!=nil &&[extendDelegate respondsToSelector:@selector(extscrollViewWillBeginDragging:)]) {
        [extendDelegate extscrollViewWillBeginDragging:scrollView];
    }
}

-(void) scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
	if(freshOff)
        return;
    
	//top fresh
	if(scrollView.contentOffset.y <= - 65.0f && !_loadState) 
	{
        _loadState = 2;
		[self mainRefresh];
		return;
	}
    
	//bottom fresh
	float footerH = 0;
	if(self.tableFooterView != nil)
		footerH = self.tableFooterView.frame.size.height;
    
	float headerH = 0.0;
	if(self.tableHeaderView != nil)
		headerH = self.tableHeaderView.frame.size.height;
    
	float contentH = footerH + contentHeight;
    //	NSLog(@"011--%f, 222--%f, 333--%f", scrollView.contentOffset.y, self.frame.size.height, headerH);
	float currentH = scrollView.contentOffset.y + self.frame.size.height - headerH;
    //	NSLog(@"footer1:%f,contentOffset:%f, content H:%f,current H:%f, self Height:%f",footerH,scrollView.contentOffset.y, contentH, currentH, self.frame.size.height);
	
	if(currentH - contentH >= 5 && !_loadState /*&& contentH > self.frame.size.height*/ && !endOfTable)
	{
        _loadState = 1;
		[self mainGetMore];
	}
    
    if (extendDelegate!=nil && [extendDelegate respondsToSelector:@selector(extscrollViewDidEndDragging:willDecelerate:)])
        [extendDelegate extscrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

-(void) bufferCellViews
{
//    return;
    
    [bufferVisibleCells removeAllObjects];
    [bufferVisibleIndexs removeAllObjects];
    
    if(!ValidArray(self.visibleCells) || !ValidArray(self.indexPathsForVisibleRows))
        return;
    
    for(UITableViewCell* cell in self.visibleCells)
    {
        if(ValidArray([cell.contentView subviews]))
            [bufferVisibleCells addObject:[[cell.contentView subviews] objectAtIndex:0]];
    }
    
    [bufferVisibleIndexs addObjectsFromArray:self.indexPathsForVisibleRows];
}

-(void) loadNormalStatus
{
	_loadState = 0;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[_headerView setState:HeaderRefreshNormal];
	[_headerView setCurrentDate];  //  should check if data reload was successful 
	
	UIActivityIndicatorView *av = (UIActivityIndicatorView*)[self.tableFooterView viewWithTag:100];
	UILabel *ml = (UILabel*)[self.tableFooterView viewWithTag:101];
	[av stopAnimating];
	av.hidden = YES;
	ml.hidden = YES;
    
    if(!endOfTable)
        [self setHiddenGetMoreLab:NO];
}

-(void) setEndOfTable:(BOOL)isend 
{
	useEndOfTableFlag = YES;
	endOfTable = isend;
    
    [self setHiddenGetMoreLab:endOfTable];
}

-(void) refreshExtendTableWithData:(NSArray*)data withParam:(NSDictionary*)param
{
	if(useEndOfTableFlag == NO)
    {
		if([data count] == totalNum)
			endOfTable = YES;
		else
			endOfTable = NO;
	}
    
    self.cellDataArray=nil;
    _cellDataArray = [data copy];
//	self._contentType = [param objectForKey:@"type"];
	curIndex = [data count];
	
	//EventList and CheckinList need correct offset to get AD
//	for (UIView* v in data)
//    {
//		if([v isKindOfClass:[GCellAd class]])
//			curIndex--;
//	}
    
	contentHeight = 0;
    [self reloadData];
	[self loadNormalStatus];
}

#pragma mark setting method
-(void) removeFreshHeader
{
	if([_headerView superview])
	{
		[_headerView removeFromSuperview];
		freshOff = YES;
	}
    
    [_headerView release];_headerView = nil;
}

-(void) rebuildFreshHeaderWithWidth:(CGFloat)width
{
	if(!_headerView)
	{
		_headerView = [[RefreshTableHeader alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.frame.size.height, width, self.frame.size.height)];
	}
    
    if(_headerColor == nil)
        _headerView.backgroundColor = [UIColor clearColor];
    else
        _headerView.backgroundColor = _headerColor;
    
	if([_headerView superview] == nil)
	{
		[self addSubview:_headerView];
		freshOff = NO;
	}
}

-(void) addFreshHeader
{
	[self rebuildFreshHeaderWithWidth:320];
}

-(void) replaceHeaderWithView:(UIView*)headv
{
	self.tableHeaderView = headv;
}

-(void) replaceFooterWithView:(UIView*)footv
{
	self.tableFooterView = footv;
}

-(void) setTableLength:(NSInteger)len
{
	totalNum = len;
}

-(NSInteger) getTableLength
{
	return totalNum;
}

-(void) setHeaderViewStyle:(UIColor*)color 
{
	if(_headerView != nil)
		_headerView.backgroundColor = color;
}

@end
