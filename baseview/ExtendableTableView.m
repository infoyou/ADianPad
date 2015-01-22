
#import "ExtendableTableView.h"
#import "GDefine.h"
#import "UIView_Extras.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define KTagTipGetMoreLab 4892

@implementation RefreshTableHeader

@synthesize state=_state,refreshDate;

-(id) initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        self.backgroundColor=[UIColor colorWithPatternImage:IMG(bg_background)];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
		lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
		lastUpdatedLabel.textColor = TEXT_COLOR;
		lastUpdatedLabel.backgroundColor = [UIColor clearColor];
		lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:lastUpdatedLabel];
		[lastUpdatedLabel release];
		
		if([[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"])
			lastUpdatedLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"];
		else
			[self setCurrentDate];
        lastUpdatedLabel.hidden=YES;
		
		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 40.0f)];
		statusLabel.font=FontBold(14);
//		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		statusLabel.textColor = TEXT_COLOR;
		statusLabel.textColor = KPTxtLightGray;
		statusLabel.backgroundColor = [UIColor clearColor];
		statusLabel.textAlignment = UITextAlignmentCenter;
		[self setState:HeaderRefreshNormal];
		[self addSubview:statusLabel];
		[statusLabel release];
		
		arrowImage = [[CALayer alloc] init];
		arrowImage.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		arrowImage.contentsGravity = kCAGravityResizeAspect;
		arrowImage.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
		[[self layer] addSublayer:arrowImage];
		[arrowImage release];
        arrowImage.hidden=YES;
		
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//		activityView.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		activityView.frame = CGRectMake((KScreenWidth-20)/2, frame.size.height - 38.0f, 20.0f, 20.0f);
        self.backgroundColor=KPageBackgroundColor;
		activityView.hidesWhenStopped = YES;
		[self addSubview:activityView];
		[activityView release];		
    }
    return self;
}

-(void) setCurrentDate
{
    self.refreshDate=[NSDate date];
    
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setAMSymbol:@"AM"];
	[formatter setPMSymbol:@"PM"];
//	[formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss at"];
	[formatter setDateFormat:@"MM-dd hh:mm:ss at"];
	NSString *str = NSLocalizedString(@"PP_LastRefresh",@"");
	str = [str stringByAppendingString:[formatter stringFromDate:self.refreshDate]];
	lastUpdatedLabel.text = [NSString stringWithString:str];
	[[NSUserDefaults standardUserDefaults] setObject:lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[formatter release];
}

-(void) setState:(HeaderRefreshState)aState
{
	switch (aState)
    {
		case HeaderRefreshPulling:
        {
//			statusLabel.text = NSLocalizedString(@"PP_UntieToRefresh",@"");
			statusLabel.text = LTXT(PP_ReleaseRefresh);
			[CATransaction begin];
			[CATransaction setAnimationDuration:.18];
			arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
            
			break;
        }
		case HeaderRefreshNormal:
        {
			if(_state == HeaderRefreshPulling)
            {
				[CATransaction begin];
				[CATransaction setAnimationDuration:.18];
				arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
//			statusLabel.text = NSLocalizedString(@"PP_PullRefresh",@"");
//			arrowImage.hidden = NO;
			statusLabel.text = LTXT(PP_DownRefresh);
			[activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
        }
		case HeaderRefreshLoading:
        {
//			statusLabel.text = NSLocalizedString(@"PP_Refreshing",@"");
//			arrowImage.hidden = YES;
			statusLabel.text = @"";
			[activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			[CATransaction commit];
			
			break;
        }
		default:
			break;
	}
	
	_state = aState;
}

-(void) dealloc
{
	activityView = nil;
	statusLabel = nil;
	arrowImage = nil;
	lastUpdatedLabel = nil;
    self.refreshDate=nil;
    [super dealloc];
}

@end

@interface ExtendableTableView (Private)
-(void) loadSubviews;
@end

@implementation ExtendableTableView

@synthesize headerView = _headerView;
@synthesize cellDataArray = _cellDataArray;
@synthesize extendDelegate;
@synthesize contentType = _contentType;
@synthesize freshOff,endOfTable;

-(void) myinit
{
	self.delegate = self;
	self.dataSource = self;
	[self loadSubviews];
	self.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.separatorColor=KC_CELL_LINE;
}

-(void) awakeFromNib
{
	self.delegate = self;
	self.dataSource = self;
	[self loadSubviews];
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
	
    _headerView.backgroundColor=KPageBackgroundColor;
	UIActivityIndicatorView *moreLoadingV = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((KScreenWidth-20)/2, KTableFootIndicatorY, 20.0, 20.0)];
//	UIActivityIndicatorView *moreLoadingV = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(20.0, KTableFootIndicatorY, 20.0, 20.0)];
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

-(void) setHiddenGetMoreLab:(BOOL)hidden
{
    UILabel* lab=(UILabel*)[self.tableFooterView viewWithTag:KTagTipGetMoreLab];
    if(lab!=nil && [lab isKindOfClass:[UILabel class]])
    {
        lab.hidden=hidden;
    }
}

-(BOOL) scrollViewShouldScrollToTop:(UIScrollView*)scrollView
{
    return YES; 
}

#pragma mark UITableViewDataSource
-(NSInteger) tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
	return [_cellDataArray count];
}

-(UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString *CellIdentifier = @"EventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if(cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
	}
	else if([cell.contentView subviews] != nil)
    {
		for(UIView *v in [cell.contentView subviews])
		{
			[v removeFromSuperview];
		}
	}
	
	cell.textLabel.text = @"";
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	UIView *v = [_cellDataArray objectAtIndex:indexPath.row];
	[cell.contentView addSubview:v];
	return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat) tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
	if(extendDelegate != nil && [extendDelegate respondsToSelector:@selector(exTableView:heightForHeaderInSection:)]) 
	{
		return [extendDelegate exTableView:tableView heightForHeaderInSection:section];
	}
	return 0.0;
}

-(UIView*) tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
	if(extendDelegate != nil && [extendDelegate respondsToSelector:@selector(exTableView:viewForHeaderInSection:)]) 
	{
		return [extendDelegate exTableView:tableView viewForHeaderInSection:section];
	}
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
	contentHeight = contentHeight + self.rowHeight;
	return self.rowHeight;
}

-(void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(extendDelegate != nil && [extendDelegate respondsToSelector:@selector(didSelectRow:atTable:withData:)])
    {
		[extendDelegate didSelectRow:indexPath.row 
							 atTable:tableView 
							withData:[NSDictionary dictionaryWithObjectsAndKeys:_contentType, @"type", [_cellDataArray objectAtIndex:indexPath.row], @"data",nil]];
	}
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
	if(extendDelegate!= nil && ![extendDelegate isKindOfClass:[ExtendableTableView class]] && [extendDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
	{
		return [extendDelegate tableView:tableView canMoveRowAtIndexPath:indexPath];
	}
	
    return YES;
}
-(BOOL) tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(extendDelegate!= nil && ![extendDelegate isKindOfClass:[ExtendableTableView class]] && [extendDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) 
	{
		return [extendDelegate tableView:tableView canEditRowAtIndexPath:indexPath];
	}
	
	return YES;
}

-(void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(extendDelegate!=nil && [extendDelegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) 
	{
		return [extendDelegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
	}
}

-(NSString*) tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(extendDelegate!=nil && ![extendDelegate isKindOfClass:[ExtendableTableView class]]&&[extendDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) 
	{
		return [extendDelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
	}
    return LTXT(PP_Del);
}

-(UITableViewCellEditingStyle) tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(extendDelegate!=nil && ![extendDelegate isKindOfClass:[ExtendableTableView class]] && [extendDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) 
	{
		return [extendDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
	}
    
	if(self.editing)
		return UITableViewCellEditingStyleDelete;
	
	return UITableViewCellEditingStyleNone;
}

-(void) scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    if(scrollView.isDragging&&[extendDelegate respondsToSelector:@selector(listScrolled)])
        [extendDelegate listScrolled];
}

-(void) scrollViewDidScroll:(UIScrollView*)scrollView
{
    if(freshOff)
        return;

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
    }
}

-(void) mainGetMore
{
    [_headerView setState:HeaderRefreshLoading];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
    
    //request again, and add new data into array,reload data
    if(extendDelegate != nil && [extendDelegate respondsToSelector:@selector(loadMoreTableFrom:withNum:andParam:)])
    {
        [extendDelegate loadMoreTableFrom:[NSString stringWithFormat:@"%d", curIndex]
                                  withNum:[NSString stringWithFormat:@"%d", stepLength]
                                 andParam:_contentType];
    }
    
    UIActivityIndicatorView *av = (UIActivityIndicatorView*)[self.tableFooterView viewWithTag:100];
    UILabel *ml = (UILabel*)[self.tableFooterView viewWithTag:101];
    [av startAnimating];
    ml.hidden = NO;
    [self setHiddenGetMoreLab:YES];
}

-(void) scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
	if(freshOff)
        return;
    
    // top refesh
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

	float contentH = footerH + contentHeight + headerH;	//plus headerH  111216
    //	NSLog(@"011--%f, 222--%f, 333--%f", scrollView.contentOffset.y, self.frame.size.height, headerH);
	float currentH = scrollView.contentOffset.y + self.frame.size.height/* - headerH*/;		//m 111216
//	NSLog(@"footer1:%f,contentOffset:%f, content H:%f,current H:%f, self Height:%f",footerH,scrollView.contentOffset.y, contentH, currentH, self.frame.size.height);

	if(currentH - contentH >= 5 && !_loadState /*&& contentH > self.frame.size.height*/ && !endOfTable)
	{
        _loadState = 1;    
		[self mainGetMore];
	}
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
	self.contentType = [param objectForKey:@"type"];
	curIndex = [data count];
	
//	for (UIView* v in data)
//		if([v isKindOfClass:[GCellAd class]])
//			curIndex--;
    
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
}

-(void) addFreshHeader
{
	if(!_headerView)
	{
		_headerView = [[RefreshTableHeader alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.frame.size.height, 320.0f, self.frame.size.height)];
		if(_headerColor == nil)
			_headerView.backgroundColor = [UIColor clearColor];
		else
			_headerView.backgroundColor = _headerColor;
	}
    
	if([_headerView superview] == nil)
	{
		[self addSubview:_headerView];
		freshOff = NO;
	}
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
