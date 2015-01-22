
#import "JsonNetManager.h"
#import "UIViewController_Extras.h"
#import "ADBarVIew.h"
#import "UIAlertView+Block.h"

enum MainViewPosition{
    MainViewPositionMiddle=0,
    MainViewPositionLeft=1,
    MainViewPositionRight=2
};
typedef enum MainViewPosition viewPosition;

@class GEventCellData;
@class HudViewController;

@interface GController : UIViewController <JsonRequestDelegate,UIAccelerometerDelegate,ADBarAddLeftEventProtocol>
{
	NSString* uuid;
    NSString* subtype;
    
    UIView* navbar;
    UIButton* leftBtn;
    UIButton* rightBtn;
    UIImage *screenImage;
    HudViewController* hudVC;
    BOOL isneedscreenshot;
    NSInteger shareType;
    
    BOOL isPaoLoading;
    
    id sharesnsdelegate;
}
@property (nonatomic,copy) NSString *uuid;
@property (nonatomic,copy) NSString *subtype;

@property (nonatomic,assign) id sharesnsdelegate;

@property (nonatomic,assign) UIView* navbar;
@property (nonatomic,assign) UIButton* leftBtn;
@property (nonatomic,assign) UIButton* rightBtn;
@property (nonatomic,retain) UIImage *screenImage;
@property (nonatomic,retain) NSArray* menus;
@property (nonatomic,retain) NSArray* titles;
@property (nonatomic,assign) int menuIndex;
@property (nonatomic,assign) UIImageView* menuTrangle;
@property (nonatomic,assign) BOOL isneedscreenshot;

-(id) initWithID:(NSString*)guid;
-(id) initWithID:(NSString*)guid nibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil;

-(void) back:(id)sender;
-(void) resetView;
-(void) getNetData:(NSDictionary*)data withItem:(JsonRequestItem*)item;
-(void) updateCell:(id)cd; // for play sound
-(void) addHUD;
-(void) addHUDandBG;
-(void) addHUD:(NSString*)tip;
-(void) removeHUD;
-(void) startScroll;
-(void) stopScroll;

-(void) paoLoading:(NSString*)msg;
-(void) paoCancelLoading;

-(void) popNavMenu;
-(void) selectMenu:(int)index;
-(void) closeMenu;

-(void) addDoorAnimate;
-(void) addCloseDoorAnimate;
-(void) startDoorAnimate;
-(void) doorAnimateStop;

-(void) closeDoor;
-(void) openDoor;

-(NSString*) getFirstKey;
-(BOOL) beFirstIn; // when first in this page, we do something
-(void) setNotFirst;
-(UIImageView*) buildFirstTipView:(UIImage*)img;
-(UIImageView*) buildFirstTipView:(UIImage*)img withFrame:(CGRect)rect;
-(UIImageView*) buildFirstTipView:(int)y img:(UIImage*)tipimg;
-(void) removeFirstTipView;

#pragma mark -watering -- newzan
-(void) addNewZan:(NSString*)tips;

#pragma mark - watering -animate
-(void) doZanAnimate;
-(void) doCaiAnimate;

#pragma mark - watering -share

-(void) buileShare:(id)delegate;
-(void) doShareIndex:(NSInteger)index;

-(void) buildNoContentTips:(NSString*)tips;
-(void) removeNoContentTips;

-(void) movePhone;

#pragma mark - zyg - nav
-(void) buildBackground;
//-(void) showNoLocationTip;

-(UIView*) buildNavBarWithLogo;
-(UILabel*) buildNavBarWithTitle:(NSString*)str;
-(UILabel*) buildNavBarWithTitle2:(NSString*)str;
-(UILabel*) buildNavBarWithMenuTitle:(NSArray*)menu titles:(NSArray*)title defaultIndex:(int)index;
-(UIButton*) buildNavLeftBtn:(UIImage*)img target:(id)target action:(SEL)action;
-(UIButton*) buildNavRightBtn:(UIImage*)img target:(id)target action:(SEL)action;
-(UIButton*) buildNavRightBtnTxt:(NSString*)txt target:(id)target action:(SEL)action;
-(UIButton*) buildNavLeftBackBtn;

#pragma mark - zyg - jump
//-(void) jumpPageLogin;
//-(void) jumpPhotosImport;
//-(void) jumpPageSearchSinaResult:(NSString*)str;
//-(void) jumpPageSearchResult:(NSString*)str;
//-(void) jumpPageSearch:(NSInteger)type;
//-(void) jumpPageInviteSina;
//-(void) jumpPagePersonInfoInit;
//-(void) jumpPagePerson:(NSDictionary*)dict withTime:(NSDate*)refreshTime;
//-(void) jumpPageChangePersonBg:(UIImageView*)bgimg withData:(NSMutableDictionary*)peopleData;
//-(void) jumpPagePersonProfile:(UIImageView*)headimg withData:(NSMutableDictionary*)peopleData;
//-(void) jumpPageMyPhotoList;
//-(void) jumpPagePhotoDetail:(NSDictionary*)dict;
//-(void) jumpPageLikeList;
//-(void) jumpPageFansList;
//-(void) jumpPageFollowList;
//-(void) jumpPageBlockList;
//-(void) jumpPageTudingLogin;
//-(void) jumpPageEvent:(NSDictionary*)cellData;
//-(void) jumpPageEventFromleft:(NSDictionary*)cellData replyId:(NSString*)replyId replyName:(NSString*)replyName;
//-(void) jumpPageFindFriend;
//-(void) jumpPageNearPeople;
//-(void) jumpPageThirdFriend:(int)type;
//-(void) jumpPageInvite:(NSDictionary*)dict type:(NSString*)type;
//-(void) jumpPageFindResult;
//+(GController*) jumpImageViewPage:(NSString*)imgname imgurl:(NSString*)imgurl urlarray:(NSArray*)urlarray imgarray:(NSArray*)imgarray imgindex:(int)imgindex;
//-(void) jumpPageSendPhoto;
//-(void) jumpPageRate;
//-(void) jumpPageAbout;
//-(void) jumpPageWebview:(NSString*)url withTitle:(NSString*)title;
@end