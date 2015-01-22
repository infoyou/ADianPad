
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ExtendableTableView.h"

@interface ExtendableTableViewV2 : UITableView<UITableViewDelegate, UITableViewDataSource>
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
    
    NSMutableArray* bufferVisibleCells;
    NSMutableArray* bufferVisibleIndexs;
}

@property (nonatomic, retain) NSArray* cellDataArray;
@property (nonatomic, retain) RefreshTableHeader* headerView;
@property (nonatomic, assign) id<ExtendableTableViewDelegate> extendDelegate;
@property (nonatomic, retain) NSString* _contentType;
@property (nonatomic, assign) BOOL freshOff;
@property (nonatomic, assign) BOOL endOfTable;
@property (nonatomic, assign) CGFloat contentHeight;

-(void) setTableLength:(NSInteger)len;
-(void) refreshExtendTableWithData:(NSArray*)data withParam:(NSDictionary*)param;
-(void) removeFreshHeader;
-(void) addFreshHeader;
- (void)rebuildFreshHeaderWithWidth:(CGFloat)width;

-(void) replaceHeaderWithView:(UIView*)headv;
-(void) replaceFooterWithView:(UIView*)footv;
-(void) setHeaderViewStyle:(UIColor*)color;
-(void) loadNormalStatus;
- (NSInteger)getTableLength;

-(void) setStatusRefresh;
-(void) setHiddenGetMoreLab:(BOOL)hidden;
-(void) mainRefresh;
-(void) mainGetMore;

-(void) bufferCellViews;
-(void) clearVisibleBuffer;

-(void) setGetMoreLabOffset;

@end
