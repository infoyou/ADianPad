
#import <Foundation/Foundation.h>

@class GController;
@class GImageView;
@class GDataObject;
@class GPopImageScrollView;

@interface UIScreen(Extras)

+(CGFloat) screenScale;

@end

@interface  UIView(Extras)

@property CGSize    size;
@property CGPoint   origin;
@property (readonly) CGPoint    bottomLeft;
@property (readonly) CGPoint    bottomRight;
@property (readonly) CGPoint    topRight;
@property CGFloat   height;
@property CGFloat   width;
@property CGFloat   top;
@property CGFloat   left;
@property CGFloat   bottom;
@property CGFloat   right;

-(void) moveBy:(CGPoint) delta;
-(void) scaleBy:(CGFloat) scaleFactor;
-(void) fitInSize:(CGSize) aSize;
-(void) removeAllSubViews;
-(void) removeAllNoTagSubViews;
-(void) removeAllSubViews:(Class)cla;
-(void) removeAllSubViewsExcept:(Class)cla;
-(void) removeSubViewsExcept:(UIView*)v;
-(UIView*) getSubView:(Class)cla;
-(void) moveToParentCenter;
-(void) moveToParentCenterX;
-(void) moveToParentCenterY;
-(BOOL) touchInside:(NSSet*)touches;
-(BOOL) pointInside:(CGPoint)pt;

-(void) setRound:(float)round;
-(void) setBeHidden;
-(void) setBeShow;

-(UIButton*) buildTxtBtn:(CGRect)rect target:(id)target action:(SEL)action txt:(NSString*)txt;
-(UIButton*) buildImgBtn:(UIImage*)img position:(CGPoint)pt target:(id)target action:(SEL)action;
-(UIButton*) buildImgBtn:(CGRect)rect target:(id)target action:(SEL)action image:(UIImage*)img;
-(UIButton*) buildBlankBtn:(CGRect)rect target:(id)target action:(SEL)action;
-(UIButton*) buildBlankBtn:(id)target action:(SEL)action;
-(UITapGestureRecognizer*) addTarget:(id)target action:(SEL)action;
-(UILabel*) buildLabel:(NSString*)str position:(CGPoint)pt font:(UIFont*)font color:(UIColor*)color;
-(UILabel*) buildCenterLabel:(NSString*)str top:(float)top font:(UIFont*)font color:(UIColor*)color;
-(UILabel*) buildLabel:(NSString*)str frame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color;
-(UILabel*) buildTopLeftLabel:(NSString*)str frame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color;
-(UILabel*) buildTopLeftLabel:(NSString*)str frame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color linelimit:(int)limit;
-(UILabel*) buildTopLeftLabelWithAutoScroll:(NSString*)str frame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color;
-(UIView*) buildBgView:(UIColor*)color frame:(CGRect)rect;
-(void) popupTips:(NSString*)title content:(NSString*)txt;
-(void) closeTips:(id)sender;
-(void) popImage:(id)sender;
-(void) unpopImage:(id)sender;
-(void) closeView:(id)sender;

-(UIView*) setCellFocus:(BOOL)focus;
-(UIImageView*) buildArrow;
-(GImageView*) buildImage:(NSString*)url frame:(CGRect)rect;
-(GImageView*) buildImage:(NSString*)url frame:(CGRect)rect defaultimg:(UIImage*)img;
-(GImageView*) buildSyncImage:(NSString*)url frame:(CGRect)rect defaultimg:(UIImage*)img;
-(UIImageView*) buildImage2:(UIImage*)img frame:(CGRect)rect;
-(UIImageView*) buildImage2:(UIImage*)img point:(CGPoint)point;
-(UIImageView*) buildRoundBg;

-(void) buildImageNumber:(int)num;
-(void) buildImageNumber2:(int)num;
-(GPopImageScrollView*) buildPopImageView:(UIImageView*)imgview withUrl:(NSString*)imgurl;
-(UIImageView*) buildOkCancelDialog:(NSString*)txt target:(id)target action:(SEL)action;
-(UIImageView*) buildOkDialog:(NSString*)txt target:(id)target action:(SEL)action;
-(void) exChangeOut:(CFTimeInterval)duration;

#pragma mark - qiaoqiao
+(UIImageView*) buildSearchTipBar:(NSString*)tip;
-(UIView*) buildProcess:(CGRect)rect;
-(UIView*) buildQiaoTips:(NSString*)msg;
-(UIView*) buildQiaoTips2:(NSString*)msg;
//-(GImageView*) buildQiaoImage:(NSString*)url frame:(CGRect)rect defaultimg:(UIImage*)img square:(BOOL)needSquare;

@end
