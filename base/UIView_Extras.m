
#import "UIView_Extras.h"
#import <QuartzCore/QuartzCore.h>
#import "GDefine.h"
#import "ADAppDelegate.h"
#import "NSString_Extras.h"
#import "GImageView.h"
#import "GPopImageScrollView.h"

@implementation UIScreen(Extras)

+(CGFloat) screenScale
{
    CGFloat scale=1.0;
    if([[UIScreen mainScreen]respondsToSelector:@selector(scale)])
    {
        CGFloat tmp=[[UIScreen mainScreen] scale];
        if (tmp > 1.5)
        {
            scale=2.0;
        }
    }
    return scale;
}

@end

@implementation UIView(Extras)

-(CGSize) size
{
    return self.frame.size;
}
-(void) setSize:(CGSize)aSize
{
    CGRect newframe=self.frame;
    newframe.size=aSize;
    self.frame=newframe;
}
-(CGPoint) origin
{
    return self.frame.origin;
}
-(void) setOrigin:(CGPoint)aPoint
{
    CGRect newframe=self.frame;
    newframe.origin=aPoint;
    self.frame=newframe;
}
-(CGPoint) bottomLeft
{
    CGFloat x=self.frame.origin.x;
    CGFloat y=self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}
-(CGPoint) bottomRight
{
    CGFloat x=self.frame.origin.x + self.frame.size.width;
    CGFloat y=self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}
-(CGPoint) topRight
{
    CGFloat x=self.frame.origin.x + self.frame.size.width;
    CGFloat y=self.frame.origin.y;
    return CGPointMake(x, y);
}
-(CGFloat) height
{
    return self.frame.size.height;
}
-(void) setHeight:(CGFloat)aHeight
{
    CGRect newframe=self.frame;
    newframe.size.height=aHeight;
    self.frame=newframe;
}
-(CGFloat) width
{
    return self.frame.size.width;
}
-(void) setWidth:(CGFloat)aWidth
{
    CGRect newframe=self.frame;
    newframe.size.width=aWidth;
    self.frame=newframe;
}
-(CGFloat) top
{
    return self.frame.origin.y;
}
-(void) setTop:(CGFloat)aTop
{
    CGRect newframe=self.frame;
    newframe.origin.y=aTop;
    self.frame=newframe;
}
-(CGFloat) left
{
    return self.frame.origin.x;
}
-(void) setLeft:(CGFloat)aLeft
{
    CGRect newframe=self.frame;
    newframe.origin.x=aLeft;
    self.frame=newframe;
}
-(CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}
-(void) setBottom:(CGFloat)aBottom
{
    CGRect newframe=self.frame;
    newframe.origin.y=aBottom - self.frame.size.height;
    self.frame=newframe;
}
-(CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}
-(void) setRight:(CGFloat)aRight
{
    CGFloat delath= aRight -(self.frame.origin.y + self.frame.size.width);
    CGRect newframe=self.frame;
    newframe.origin.x += delath;
    self.frame=newframe;
}
-(void) moveBy:(CGPoint)delta
{
}
-(void) scaleBy:(CGFloat)scaleFactor
{
}
-(void) fitInSize:(CGSize)aSize
{
}
-(void) removeAllSubViews
{
    for(UIView* view in self.subviews)
    {
        [view removeFromSuperview];
    }
}
-(void) removeAllNoTagSubViews
{
    for(UIView* view in self.subviews)
    {
        if(view.tag==0)
            [view removeFromSuperview];
    }
}
-(void) removeAllSubViews:(Class)cla
{
    for(UIView* view in self.subviews)
    {
        if([view isKindOfClass:cla])
            [view removeFromSuperview];
    }
}
-(void) removeAllSubViewsExcept:(Class)cla
{
    for(UIView* view in self.subviews)
    {
        if(![view isKindOfClass:cla])
            [view removeFromSuperview];
    }
}
-(void) removeSubViewsExcept:(UIView*)v
{
    for(UIView* view in self.subviews)
    {
        if(view!=v)
            [view removeFromSuperview];
    }
}
-(UIView*) getSubView:(Class)cla
{
    for(UIView* view in self.subviews)
    {
        if([view isKindOfClass:cla])
            return view;
    }
    return nil;
}
-(void) moveToParentCenter
{
    UIView* view=self.superview;
    if(view==nil)
        return;
    
    self.left=(view.width-self.width)/2;
    self.top=(view.height-self.height)/2;
}
-(void) moveToParentCenterX
{
    UIView* view=self.superview;
    if(view==nil)
        return;
    
    self.left=(view.width-self.width)/2;
}
-(void) moveToParentCenterY
{
    UIView* view=self.superview;
    if(view==nil)
        return;
    
    self.top=(view.height-self.height)/2;
}

-(BOOL) touchInside:(NSSet*)touches
{
    UITouch* _touch=[touches anyObject];
    CGPoint _point=[_touch locationInView:self];
    
    return [self pointInside:_point];
}

-(BOOL) pointInside:(CGPoint)pt
{
    if(pt.x >=0 && pt.x<=self.width && pt.y>=0 && pt.y<=self.height)
        return YES;
    
    return NO;
}

-(void) setRound:(float)round
{
    self.layer.cornerRadius=round;
    self.layer.masksToBounds=YES;
}

-(void) setBeHidden
{
    self.hidden=YES;
}

-(void) setBeShow
{
    self.hidden=NO;
}

-(UIButton*) buildTxtBtn:(CGRect)rect target:(id)target action:(SEL)action txt:(NSString*)txt
{
    self.userInteractionEnabled=YES;
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=rect;
    [btn setTitle:txt forState:UIControlStateNormal];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}
-(UIButton*) buildImgBtn:(UIImage*)img position:(CGPoint)pt target:(id)target action:(SEL)action
{
    self.userInteractionEnabled=YES;
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(pt.x, pt.y, img.size.width , img.size.height);
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}
-(UIButton*) buildImgBtn:(CGRect)rect target:(id)target action:(SEL)action image:(UIImage*)img
{
    self.userInteractionEnabled=YES;
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=rect;
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}
-(UIButton*) buildBlankBtn:(CGRect)rect target:(id)target action:(SEL)action
{
    self.userInteractionEnabled=YES;
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=rect;
    btn.backgroundColor=KClearColor;
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}
-(UIButton*) buildBlankBtn:(id)target action:(SEL)action
{
    self.userInteractionEnabled=YES;
    
    CGRect rect=self.frame;
    rect.origin.x=0;
    rect.origin.y=0;
    
    return [self buildBlankBtn:rect target:target action:action];
}
-(UITapGestureRecognizer*) addTarget:(id)target action:(SEL)action
{
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer* gesture=[[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:gesture];
    [gesture release];
    return gesture;
}
-(UILabel*) buildLabel:(NSString*)str position:(CGPoint)pt font:(UIFont*)font color:(UIColor*)color
{
    //	int h=[font fontHeight];
    CGSize temp={900000, 80};
    CGSize txtSize=[str sizeWithFont:font constrainedToSize:temp];
    CGRect rect=CGRectMake(pt.x, pt.y, txtSize.width, txtSize.height);
    
    UILabel* lab=[[UILabel alloc] initWithFrame:rect];
    lab.text=str;
    lab.font=font;
    lab.textColor=color;
    lab.backgroundColor=KClearColor;
    
    [self addSubview:lab];
    [lab release];
    return lab;
}
-(UILabel*) buildCenterLabel:(NSString*)str top:(float)top font:(UIFont*)font color:(UIColor*)color
{
    CGSize temp={self.width,900000};
    CGSize txtSize=[str sizeWithFont:font constrainedToSize:temp];
    
    UILabel* lab=[[UILabel alloc] initWithFrame:CGRectMake(0, top, self.width, txtSize.height)];
    lab.text=str;
    lab.font=font;
    lab.textColor=color;
    lab.backgroundColor=KClearColor;
    lab.textAlignment=NSTextAlignmentCenter;
    
    [self addSubview:lab];
    [lab release];
    return lab;
}
-(UILabel*) buildLabel:(NSString*)str frame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color
{
    UILabel* lab=[[UILabel alloc] initWithFrame:frame];
    lab.numberOfLines=0;
    lab.text=str;
    lab.font=font;
    lab.textColor=color;
    lab.backgroundColor=KClearColor;
    
    [self addSubview:lab];
    [lab release];
    return lab;
}
-(UILabel*) buildTopLeftLabel:(NSString*)str frame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color
{
    CGSize temp={frame.size.width,900000};
    CGSize txtSize=[str sizeWithFont:font constrainedToSize:temp];
    CGRect rect=CGRectMake(frame.origin.x, frame.origin.y, txtSize.width, txtSize.height);
    
    UILabel* lab=[[UILabel alloc] initWithFrame:rect];
    lab.numberOfLines=0;
    lab.text=str;
    lab.font=font;
    lab.textColor=color;
    lab.backgroundColor=KClearColor;
    
    [self addSubview:lab];
    [lab release];
    return lab;
}
-(UILabel*) buildTopLeftLabel:(NSString*)str frame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color linelimit:(int)limit
{
    CGSize temp={frame.size.width,900000};
    CGSize txtSize=[str sizeWithFont:font constrainedToSize:temp];
    CGRect rect=CGRectMake(frame.origin.x, frame.origin.y, txtSize.width, txtSize.height);
    
    temp=CGSizeMake(9999999,50);
    NSString* trimstr=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // why no effect !! ??
    trimstr=[trimstr stringByReplacingOccurrencesOfString:@" " withString:@""];
    trimstr=[trimstr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    trimstr=[trimstr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    trimstr=[trimstr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    CGSize txtSize2=[trimstr sizeWithFont:font constrainedToSize:temp];
    if(txtSize.height > limit*txtSize2.height)
        rect.size.height=limit*txtSize2.height;
    
    UILabel* lab=[[UILabel alloc] initWithFrame:rect];
    lab.numberOfLines=limit;
    lab.text=str;
    lab.font=font;
    lab.textColor=color;
    lab.backgroundColor=KClearColor;
    
    [self addSubview:lab];
    [lab release];
    return lab;
}
-(UILabel*) buildTopLeftLabelWithAutoScroll:(NSString*)str frame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color
{
    CGSize temp={frame.size.width,900000};
    CGSize txtSize=[str sizeWithFont:font constrainedToSize:temp];
    CGRect rect=CGRectMake(frame.origin.x, frame.origin.y, txtSize.width, txtSize.height);
    
    UILabel* lab=[[UILabel alloc] initWithFrame:rect];
    lab.numberOfLines=0;
    lab.text=str;
    lab.font=font;
    lab.textColor=color;
    lab.backgroundColor=KClearColor;
    
    if(txtSize.height>frame.size.height)
    {
        UIScrollView* sv=[[UIScrollView alloc] initWithFrame:frame];
        [self addSubview:sv];
        [sv release];
        
        txtSize.height+=30;
        sv.contentSize=txtSize;
        [sv addSubview:lab];
        
        rect.origin.x=0;
        rect.origin.y=0;
        lab.frame=rect;
    }
    else
        [self addSubview:lab];
    
    [lab release];
    return lab;
}
-(UIView*) buildBgView:(UIColor*)color frame:(CGRect)rect
{
    UIView* view=[[UIView alloc] initWithFrame:rect];
    view.backgroundColor=color;
    
    [self addSubview:view];
    [view release];
    return view;
}
#define KViewPopTipsTag 6688
-(void) popupTips:(NSString*)title content:(NSString*)txt
{
    if(txt==nil || txt.length<=0)
        return;
    
    UIView* view=[self buildBgView:ColorA(0,0,0,0.4) frame:self.frame];
    view.tag=KViewPopTipsTag;
    
    UIImage* img=IMG(bg_poptip);
    img=[img stretchableImageWithLeftCapWidth:21 topCapHeight:50];
    float w=260;
    float h=220;
    float x=(320-w)/2;
    float y=100;
    CGRect rect=CGRectMake(x, y, w, h);
    
    UIImageView* iv=[[UIImageView alloc] initWithFrame:rect];
    iv.image=img;
    iv.userInteractionEnabled=YES;
    [view addSubview:iv];
    [iv release];
    
    if(title!=nil && title.length>0)
    {
        UIFont* font=FontBold(16);
        int len=txtLength(title,font,w);
        x=(w-len)/2;
        y=7;
        [iv buildLabel:title position:CGPointMake(x, y) font:font color:KWhiteColor];
    }
    
    int ox=30;
    w-=ox;
    UIFont* font=Font(14);
    UIColor* color=KBlackColor;
    int len=txtLength(txt,font,w);
    if(len<w)
    {
        x=(w+ox-len)/2;
        y=80;
        [iv buildLabel:txt position:CGPointMake(x, y) font:font color:color];
    }
    else
    {
        x=ox/2;
        y=25;
        w=len;
        h=h-y-40;
        rect=CGRectMake(x, y, w, h);
        
        UILabel* lab=[[UILabel alloc] initWithFrame:rect];
        lab.numberOfLines=0;
        lab.text=txt;
        lab.textColor=color;
        lab.backgroundColor=KClearColor;
        lab.font=font;
        [iv addSubview:lab];
        [lab release];
    }
    
    w=200;
    h=30;
    x=(iv.frame.size.width-w)/2;
    y=iv.frame.size.height-h-30;
    rect=CGRectMake(x, y, w, h);
    img=IMG(bg_btn_green);
    img=[img stretchableImageWithLeftCapWidth:21 topCapHeight:14];
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=rect;
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setTitle:LTXT(PP_O_k) forState:UIControlStateNormal];
    [btn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(closeTips:) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:btn];
}
-(void) closeTips:(id)sender
{
    UIView* view=[self viewWithTag:KViewPopTipsTag];
    [view removeFromSuperview];
}

#define KTagPopImageView 6155
#define KTagPopMarkView 6156
-(void) popImage:(id)sender
{
    UIImageView* imgview=nil;
    
    if(ValidClass(sender, UIImageView))
        imgview=(UIImageView*)sender;
    else if(ValidClass(sender, UITapGestureRecognizer))
        imgview=(UIImageView*)((UITapGestureRecognizer*)sender).view;
    else
        imgview=(UIImageView*)[((UIView*)sender) superview];
    
    if(!ValidClass(imgview, UIImageView))
        return;
    
    CGRect rect=[imgview convertRect:CGRectMake(0, 0, imgview.width, imgview.height) toView:self];
    //    GPopScrollView* bg=[[GPopScrollView alloc] initWithFrame:self.frame];
    UIView* bg=[[UIView alloc] initWithFrame:self.frame];
    [self addSubview:bg];
    [bg release];
    
    bg.backgroundColor=KBlackColor;
    bg.alpha=0;
    
    //    if(sender==appDelegate.meC.head)
    //        [bg addTarget:self action:@selector(showTabbarAndUnpop:)];
    //    else
    [bg addTarget:self action:@selector(unpopImage:)];
    
    UIView* markview=[bg buildBgView:KClearColor frame:rect];
    markview.tag=KTagPopMarkView;
    
    UIImageView* iv=[[UIImageView alloc] initWithFrame:rect];
    iv.tag=KTagPopImageView;
    iv.image=imgview.image;
    [bg addSubview:iv];
    //    [bg addZoomView:iv];
    [iv release];
    
    float maxw=310;
    float maxh=460;
    float o=imgview.image.size.width/imgview.image.size.height;
    float width=(o>=maxw/maxh) ? maxw : maxh*o;
    float height=(o>=maxw/maxh) ? maxw/o : maxh;
    CGRect rect2=CGRectMake((320-width)/2, (460-height)/2, width, height);
    
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.3];
    iv.frame=rect2;
    iv.alpha=1.0;
    bg.alpha=0.9;
    [UIView commitAnimations];
}
-(void) showTabbarAndUnpop:(id)sender
{
    [self unpopImage:sender];
    //    [appDelegate showTabBar];
}
-(void) unpopImage:(id)sender
{
    if(!ValidClass(sender, UITapGestureRecognizer))
        return;
    
    UIView* bg=((UITapGestureRecognizer*)sender).view;
    UIView* markview=[bg viewWithTag:KTagPopMarkView];
    UIImageView* iv=(UIImageView*)[bg viewWithTag:KTagPopImageView];
    if(!ValidClass(iv, UIImageView) || !ValidClass(markview, UIView))
        return;
    
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.3];
    iv.frame=markview.frame;
    iv.alpha=0;
    bg.alpha=0;
    [UIView commitAnimations];
    
    [bg performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
}
-(void) closeView:(id)sender
{
    UIView* view=nil;
    
    if(ValidClass(sender, UIView))
        view=(UIView*)sender;
    else if(ValidClass(sender, UITapGestureRecognizer))
        view=((UITapGestureRecognizer*)sender).view;
    
    if(ValidClass(view, UIView))
        [view removeFromSuperview];
}

-(UIView*) setCellFocus:(BOOL)focus
{
    if(focus)
        self.backgroundColor=KColorListSelect;
    else
        self.backgroundColor=KClearColor;
    
    return nil;
}
-(UIView*)buildCellLine
{
    UIView *lineV=[[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height - 1, self.frame.size.width, 1)];
    lineV.backgroundColor=KC_CELL_LINE;
    [self addSubview:lineV];
    [lineV release];
    
    return lineV;
}
-(UIImageView*) buildArrow
{
    UIImage* img=IMG(cell_arrow);
    UIImageView* iv=[[UIImageView alloc] initWithImage:img];
    [self addSubview:iv];
    [iv release];
    
    float w=self.frame.size.width;
    float h=self.frame.size.height;
    iv.frame=CGRectMake(w-img.size.width-KOffsetArrow, (h-img.size.height)/2 - 3, img.size.width, img.size.height);
    return iv;
}
-(GImageView*) buildImage:(NSString*)url frame:(CGRect)rect
{
    return [self buildImage:url frame:rect defaultimg:nil];
}
-(GImageView*) buildImage:(NSString*)url frame:(CGRect)rect defaultimg:(UIImage*)img
{
    GImageView* gv=[[GImageView alloc] initWithFrame:rect];
    gv.tag=KTagGImageView;
    [self addSubview:gv];
    [gv release];
    
    [gv loadImage:url defalutImage:img];
    
    return gv;
}
-(GImageView*) buildSyncImage:(NSString*)url frame:(CGRect)rect defaultimg:(UIImage*)img
{
    GImageView* gv=[[GImageView alloc] initWithFrame:rect];
    gv.tag=KTagGImageView;
    [self addSubview:gv];
    [gv release];
    
    gv.beSync=YES;
    [gv loadImage:url defalutImage:img];
    
    return gv;
}
-(UIImageView*) buildImage2:(UIImage*)img frame:(CGRect)rect
{
    UIImageView* iv=[[UIImageView alloc] initWithImage:img];
    [self addSubview:iv];
    [iv release];
    
    iv.frame=rect;
    return iv;
}
-(UIImageView*) buildImage2:(UIImage*)img point:(CGPoint)point
{
    UIImageView* iv=[[UIImageView alloc] initWithImage:img];
    [self addSubview:iv];
    [iv release];
    
    iv.frame=CGRectMake(point.x, point.y, img.size.width, img.size.height);
    return iv;
}
-(UIImageView*) buildRoundBg
{
    int ox=10;
    int oy=12;
    
    UIImage* img=IMG(me_buble);
    img=[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
    UIImageView* iv=[self buildImage2:img frame:CGRectMake(ox, KNavBarHeight+oy, self.width-ox-ox, self.height-KNavBarHeight-oy-oy)];
    [self sendSubviewToBack:iv];
    return iv;
}

-(void) buildImageNumber:(int)num
{
    float ox=0;
    float oy=0;
    float w=6.5;
    float h=6.5;
    
    int n1=num%10;
    NSString* imgname=[NSString stringWithFormat:@"%d.png",n1];
    UIImageView* iv=[self buildImage2:IMG0(imgname) frame:CGRectMake(self.width-ox-w, self.height-oy-h, w, h)];
    
    int n2=(num/10)%10;
    int n3=(num/100)%10;
    
    if(n3>0 || n2>0)
    {
        imgname=[NSString stringWithFormat:@"%d.png",n2];
        iv=[self buildImage2:IMG0(imgname) frame:CGRectMake(iv.left-ox-w, iv.top, w, h)];
    }
    
    if(n3>0)
    {
        imgname=[NSString stringWithFormat:@"%d.png",n3];
        [self buildImage2:IMG0(imgname) frame:CGRectMake(iv.left-ox-w, iv.top, w, h)];
    }
}

-(void) buildImageNumber2:(int)num
{
    float ox=0;
    float oy=0;
    float w=4.5;
    float h=4.5;
    
    int n1=num%10;
    NSString* imgname=[NSString stringWithFormat:@"s%d.png",n1];
    UIImageView* iv=[self buildImage2:IMG0(imgname) frame:CGRectMake(self.width-ox-w, self.height-oy-h, w, h)];
    
    int n2=(num/10)%10;
    int n3=(num/100)%10;
    
    if(n3>0 || n2>0)
    {
        imgname=[NSString stringWithFormat:@"s%d.png",n2];
        iv=[self buildImage2:IMG0(imgname) frame:CGRectMake(iv.left-ox-w, iv.top, w, h)];
    }
    
    if(n3>0)
    {
        imgname=[NSString stringWithFormat:@"s%d.png",n3];
        [self buildImage2:IMG0(imgname) frame:CGRectMake(iv.left-ox-w, iv.top, w, h)];
    }
}

-(GPopImageScrollView*) buildPopImageView:(UIImageView*)imgview withUrl:(NSString*)imgurl
{
    GPopImageScrollView* sv=[[GPopImageScrollView alloc] initWithFrame:self.frame];
    [sv buildImageView:self imgView:imgview withUrl:imgurl];
    [sv release];
    return sv;
}

-(UIImageView*) buildOkCancelDialog:(NSString*)txt target:(id)target action:(SEL)action
{
    int x=50;
    int y=KContentHeight*2/5;
    int w=KScreenWidth-x-x;
    int h=150;
    
    UIImage* img=[IMG(ok_cancel_bg) stretchableImageWithLeftCapWidth:45 topCapHeight:25];
    UIButton* blank=[self buildBlankBtn:nil action:nil];
    UIImageView* bg=[blank buildImage2:img frame:CGRectMake(x, y, w, h)];
    bg.userInteractionEnabled=YES;
    bg.alpha=0.8;
    
    UILabel* lab=[bg buildLabel:txt frame:CGRectMake(20, 20, bg.width-40, 60) font:Font(16) color:KWhiteColor];
    lab.textAlignment=UITextAlignmentCenter;
    
    x=20;
    y=100;
    w=76;
    h=38;
    UIButton* btn=[bg buildImgBtn:CGRectMake(x, y, w, h) target:target action:action image:IMG(btn_ok)];
    [btn addTarget:bg action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:blank action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [btn buildCenterLabel:LTXT(PP_OK) top:9 font:Font(16) color:ColorGray(88)];
    
    x=bg.width-x-w;
    btn=[bg buildImgBtn:CGRectMake(x, y, w, h) target:bg action:@selector(removeFromSuperview) image:IMG(btn_cancel)];
    [btn addTarget:blank action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [btn buildCenterLabel:LTXT(PP_CANCEL) top:9 font:Font(16) color:KWhiteColor];
    
    [bg exChangeOut:0.5];
    return bg;
}

-(UIImageView*) buildOkDialog:(NSString*)txt target:(id)target action:(SEL)action
{
    int x=50;
    int y=KContentHeight*2/5;
    int w=KScreenWidth-x-x;
    int h=150;
    
    UIImage* img=[IMG(ok_cancel_bg) stretchableImageWithLeftCapWidth:45 topCapHeight:25];
    UIButton* blank=[self buildBlankBtn:nil action:nil];
    UIImageView* bg=[blank buildImage2:img frame:CGRectMake(x, y, w, h)];
    bg.userInteractionEnabled=YES;
    bg.alpha=0.8;
    
    UILabel* lab=[bg buildLabel:txt frame:CGRectMake(20, 20, bg.width-40, 60) font:Font(16) color:KWhiteColor];
    lab.textAlignment=UITextAlignmentCenter;
    
    x=20;
    y=100;
    w=76*2+x;
    h=38;
    img=[IMG(btn_ok) stretchableImageWithLeftCapWidth:152.0/4 topCapHeight:75.0/4];
    UIButton* btn=[bg buildImgBtn:CGRectMake(x, y, w, h) target:target action:action image:img];
    [btn addTarget:bg action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:blank action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [btn buildCenterLabel:LTXT(PP_OK) top:9 font:Font(16) color:ColorGray(88)];
    
    [bg exChangeOut:0.5];
    return bg;
}

-(void) exChangeOut:(CFTimeInterval)duration
{
    CAKeyframeAnimation* animation=[CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration=duration;
    //animation.delegate=self;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    
    NSMutableArray* values=[NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values=values;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    [self.layer addAnimation:animation forKey:nil];
}

#pragma mark - qiaoqiao
+(UIImageView*) buildSearchTipBar:(NSString*)tip
{
    UIImageView* iv=[[UIImageView alloc] initWithImage:IMG(banner_find_friend)];
    iv.frame=CGRectMake(0, 0, KScreenWidth, 27);
    [iv buildLabel:tip frame:CGRectMake(15, 0, KScreenWidth-15, iv.height) font:Font(15) color:KWhiteColor];
    
    return [iv autorelease];
}

-(UIView*) buildProcess:(CGRect)rect
{
    UIView* bg=[self buildBgView:ColorA(0, 0, 0, 0.5) frame:rect];
    
    UIActivityIndicatorView* av=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [bg addSubview:av];
    [av release];
    
    av.frame=CGRectMake((rect.size.width-25)/2, (rect.size.height-25)/2, 25, 25);
    [av startAnimating];
    
    return bg;
}

-(UIView*) buildQiaoTips:(NSString*)msg
{
    UIImage* img=[IMG(pop-up-bg) stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    UIImageView* bg=[self buildImage2:img frame:CGRectMake(65, KContentHeight*2/5, 190, 112+20)];
    bg.alpha=0.6;
    bg.userInteractionEnabled=YES;
    
    [bg buildImage2:IMG(pop-up-success) frame:CGRectMake((190-36)/2, 20, 36, 36)].alpha=0.9;
    UILabel* lab=[bg buildLabel:msg frame:CGRectMake(20, 75, 150, 60) font:Font(16) color:KWhiteColor];
    lab.textAlignment=UITextAlignmentCenter;
    
    if(msg.length>20)
    {
        bg.height+=25;
        lab.height+=25;
    }
    
    //    [bg exChangeOut:0.5];
    [bg performSelector:@selector(slowRemove) withObject:nil afterDelay:2];
    return bg;
}

-(UIView*) buildQiaoTips2:(NSString*)msg
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:GP_AlertTitle message:msg delegate:nil cancelButtonTitle:LTXT(PP_OK) otherButtonTitles:nil];
    [alert show];
    [alert release];
    return nil;
    
    float len=txtLength(msg, Font(16), 200)+20*2;
    if(len<120)
        len=120;
    
    UIImage* img=[IMG(pop-up-bg) stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    UIImageView* bg=[self buildImage2:img frame:CGRectMake((KScreenWidth-len)/2, KContentHeight*2/5, len, 100)];
    bg.alpha=0.6;
    bg.userInteractionEnabled=YES;
    
    UILabel* lab=[bg buildLabel:msg frame:CGRectMake(20, 22, len-40, 60) font:Font(16) color:KWhiteColor];
    lab.textAlignment=UITextAlignmentCenter;
    
    //    [bg exChangeOut:0.5];
    [bg performSelector:@selector(slowRemove) withObject:nil afterDelay:2];
    return bg;
}

-(void) slowRemove
{
    [UIView beginAnimations:@"slowRemove" context:nil];
    [UIView setAnimationDuration:0.3];
    self.alpha=0;
    [UIView commitAnimations];
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
}

@end