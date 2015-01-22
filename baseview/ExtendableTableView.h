
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


typedef enum
{
	HeaderRefreshPulling = 0,
	HeaderRefreshNormal,
	HeaderRefreshLoading,	
} HeaderRefreshState;

@interface RefreshTableHeader : UIView
{
	UILabel *lastUpdatedLabel;
	UILabel *statusLabel;
	CALayer *arrowImage;
	UIActivityIndicatorView *activityView;
	
	HeaderRefreshState _state;
}

@property(nonatomic,assign) HeaderRefreshState state;
@property(nonatomic,retain) NSDate* refreshDate;

-(void) setCurrentDate;
-(void) setState:(HeaderRefreshState)aState;

@end

@protocol ExtendableTableViewDelegate<NSObject>

//@required
//- (UITableViewCell*) tableView:(UITableView*)tableview cellForRow:(NSInteger)row withData:(id)data;

@optional
- (NSArray*)loadMoreTableFrom:(NSString*)index withNum:(NSString*)num andParam:(NSString*)param;
- (NSArray*)reloadTableWithData:(NSString*)param;
-(void) didSelectRow:(NSInteger)row atTable:(UITableView*)table withData:(id)data;
- (CGFloat)heightForRow:(NSInteger)row atTable:(UITableView*)table;
- (CGFloat)exHeightForIndexPath:(NSIndexPath*)indexPath atTable:(UITableView*)table;
- (UIView*)exTableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section;
- (CGFloat)exTableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section;

- (void)extScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)extscrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)extscrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)exscrollViewDidEndDecelerating:(UIScrollView *)scrollView;

//lyn add
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath;
-(void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath;
-(UITableViewCellEditingStyle) tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath;
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath;
-(void)listScrolled;
// for left right scroll event
-(void) scrollHorizontal:(BOOL)toleft;

@end

typedef enum _loadingState
{
	NONE = 0,
	LOADMORETABLE = 1,
	REFRESHTABLE = 2,
} LoadingState;

#define MAXCOUNT 2000

@interface ExtendableTableView : UITableView<UITableViewDelegate, UITableViewDataSource>
{
	RefreshTableHeader* _headerView;
	
	NSArray* _cellDataArray;
	
	LoadingState _loadState;
	
	id<ExtendableTableViewDelegate> extendDelegate;
	
	NSInteger stepLength;
	NSInteger curIndex;
	CGFloat contentHeight;
	NSString* _contentType;
	
	NSInteger totalNum;
	BOOL endOfTable;
	BOOL freshOff;
	
	UIColor* _headerColor;
	
	BOOL useEndOfTableFlag;
	BOOL beSetRefreash;
}

@property (nonatomic, retain) NSArray* cellDataArray;
@property (nonatomic, retain) RefreshTableHeader* headerView;
@property (nonatomic, assign) id<ExtendableTableViewDelegate> extendDelegate;
@property (nonatomic, retain) NSString* contentType;
@property (nonatomic, assign) BOOL freshOff;
@property (nonatomic,assign) BOOL endOfTable;

-(void) setTableLength:(NSInteger)len;
-(void) refreshExtendTableWithData:(NSArray*)data withParam:(NSDictionary*)param;
-(void) removeFreshHeader;
-(void) addFreshHeader;
-(void) replaceHeaderWithView:(UIView*)headv; //lyn add
-(void) replaceFooterWithView:(UIView*)footv;
-(void) setHeaderViewStyle:(UIColor*)color;
-(void) loadNormalStatus;
- (NSInteger)getTableLength;

-(void) setStatusRefresh;
-(void) setHiddenGetMoreLab:(BOOL)hidden;
-(void) mainRefresh;
-(void) mainGetMore;

@end
