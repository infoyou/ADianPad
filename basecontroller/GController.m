 
#import "GController.h"
#import "NsObject_Extras.h"
#import "GUtil.h"
#import "GDefine.h"
#import "UIView_Extras.h"
#import "UIImage_Extras.h"
#import "NSString_Extras.h"
#import "ADAppDelegate.h"

#import "PWWebViewController.h"
//#import "PersonInfoInitViewController.h"
#import "HudViewController.h"

//#import "PeopleDetailViewController.h"
//#import "PeopleBgViewController.h"
//#import "LikeListController.h"
//#import "FansListController.h"
//#import "FollowListController.h"
//#import "BlockListController.h"
//#import "PeopleProfileController.h"
//#import "PhotoDetailViewController.h"
//#import "MyPhotoListController.h"
//#import "MWPhotoBrowser.h"
//#import "SendPhotoViewController.h"
//#import "RateController.h"

//#import "CommentCellDataObject.h"
//#import "PhotoDataObject.h"
//#import "AboutViewController.h"
//#import "ShareSNSViewController.h"
//
//#import "InviteSinaViewController.h"
//#import "SearchViewController.h"
//#import "SearchResultViewController.h"
//
//#import "SearchSinaResultViewController.h"

#define LOG_CLASS

@implementation GController
@synthesize uuid,subtype;
@synthesize navbar,leftBtn,rightBtn,menus,titles,menuIndex,menuTrangle,screenImage,isneedscreenshot,sharesnsdelegate;

enum
{
    EControllerViewTag = 1110000,
    EControllerDoorLeftImageTag,
    EControllerDoorRightImageTag,
    EControllerNavTitleTag,
    EControllerMenuBgTag,
    
    EControllerZanViewTag,
    EControllerCaiViewTag,
    
    EControllerNewZanViewTag,
    
    EContorllerAlertSheetShareTag,
};

-(id) init
{
	if((self=[super init])) 
	{
		self.uuid=[GUtil getUUID];
        isneedscreenshot = YES;
	}
	return self;
}

-(id) initWithID:(NSString*)guid
{
	if((self=[super init]))
	{
		self.uuid=guid;
	}
	return self;
}

-(id) initWithID:(NSString*)guid nibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil 
{
	if((self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		self.uuid=guid;
	}
	return self;
}

-(id) initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil 
{
	if((self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
#ifdef LOG_CLASS
        LogClass;
#endif
		self.uuid=[GUtil getUUID];
	}
	return self;
}

-(NSString*) getFirstKey
{
    NSString* first=[NSString stringWithFormat:@"%@ - %@",self.class,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    return first;
}

-(BOOL) beFirstIn
{
    NSString* first=[self getFirstKey];
    NSString* content=[GUtil getInfo:first];
    return !(StrValid(content) && [content isEqualToString:@"true"]);
}

-(void) setNotFirst
{
    NSString* first=[self getFirstKey];
    [GUtil setInfo:@"true" withKey:first];
}

#define KFirstTipTag 38393
-(UIImageView*) buildFirstTipView:(UIImage*)img
{
    [self setNotFirst];
    
    UIImageView* iv=[self.view buildImage2:img frame:KScreenRect];
    [iv buildBlankBtn:self action:@selector(removeFirstTipView)];
    iv.tag=KFirstTipTag;
    iv.top=-20;
    return iv;
}
-(UIImageView*) buildFirstTipView:(UIImage*)img withFrame:(CGRect)rect
{
    [self setNotFirst];
    
    UIImageView* iv=[self.view buildImage2:img frame:KScreenRect];
    [iv buildBlankBtn:rect target:self action:@selector(removeFirstTipView)];
    iv.tag=KFirstTipTag;
    iv.top=-20;
    return iv;
}

-(UIImageView*) buildFirstTipView:(int)y img:(UIImage*)tipimg
{
    [self setNotFirst];
    
    UIImage* img=IMG(me_uppart);
    img=[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
    
    UIImageView* iv=[self.view buildImage2:nil frame:KScreenRect];
    [iv buildBlankBtn:self action:@selector(removeFirstTipView)];
    iv.tag=KFirstTipTag;
    iv.top=-20;
    
    [iv buildImage2:img frame:CGRectMake(0, 0, KScreenWidth, y)];
    [iv buildImage2:tipimg frame:CGRectMake(0, y, KScreenWidth, tipimg.size.height)];
    [iv buildImage2:img frame:CGRectMake(0, y+tipimg.size.height, KScreenWidth, KScreenHeight)];
    return iv;
}

-(void) removeFirstTipView
{
    UIView* view=[self.view viewWithTag:KFirstTipTag];
    [view removeFromSuperview];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)updateStatusBar
{
    [self setNeedsStatusBarAppearanceUpdate];
    
}
-(void) viewDidLoad
{
    [self updateStatusBar];
    [self buildBackground];
    isPaoLoading = NO;
//    [self buildNavBarWithLogo];
//    appDelegate.accelerometer.delegate = self;
}

-(void) clearNav
{
    if(navbar!=nil)
    {
        [navbar removeFromSuperview];
        navbar=nil;
    }
    
    leftBtn=nil;
    rightBtn=nil;
}

-(void) viewDidUnload
{
    [super viewDidUnload];
    navbar=nil;
    leftBtn=nil;
    rightBtn=nil;
}

-(NSString*) getKey:(NSString*)cmd
{
    return [NSString stringWithFormat:@"%@-%@-%@",self.class,cmd,subtype];
}

-(void) startScroll
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
}

-(void) stopScroll
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}

-(void) jsonRequestFinish:(NSDictionary*)dict requestItem:(JsonRequestItem*)item
{
    self.uuid=item.type;
    [self performSelectorOnMainThread:@selector(getNetData:withItem:) withObject:(id)dict withObject:item waitUntilDone:YES];
    [self stopScroll];
    
#ifdef LOG_CLASS
    NSString* key=[NSString stringWithFormat:@"netget  -------  %@",[self getKey:item.type]];
    LOGA(key);
#endif
}

-(void) jsonRequestFailed:(JsonRequestItem*)item
{
    [self removeHUD];
    [self paoCancelLoading];
    [self stopScroll];
    
    if(![item.custom isEqualToString:KDesNoNetAlert])
    {
        if ([item.type isEqualToString:@"message_polling"])
        {
//            AlertBar2(LTXT(PP_ConnectTimeOut));
        }
        else
        {
            Alert(LTXT(PP_ConnectTimeOut));
        }
    }
}

-(void) cancelNet
{
    [JsonManager removeDelegate:self];
    [self stopScroll];
}

-(void) didReceiveMemoryWarning
{
    [JsonManager removeDelegate:self];
    if(self.isViewLoaded)
        [self stopScroll];
    
//    [super didReceiveMemoryWarning];
}

-(void) dealloc 
{
    [self clearNav];
    [JsonManager removeDelegate:self];
    
    
    self.screenImage = nil;
	self.uuid=nil;
    self.subtype=nil;
    self.menus=nil;
    self.titles=nil;
    
    [super dealloc];
}

-(void) back:(id)sender
{
    [JsonManager removeDelegate:self];
    [appDelegate pop];
    [self removeHUD];
    [self paoCancelLoading];
}

-(void) resetView
{
    [self cancelNet];
    for(UIView* view in self.view.subviews)
    {
        [view removeFromSuperview];
    }
    
    leftBtn=nil;
    rightBtn=nil;
    navbar=nil;
}

-(void) getNetData:(NSDictionary*)data withItem:(JsonRequestItem*)item
{
    LOGA(data);
}

-(void) updateCell:(id)cd
{
}
-(void) addHUD
{
//    [self addHUD:Landing_Processing];
}
-(void) addHUDandBG
{ 
	if(hudVC == nil)
    {
		hudVC=[[HudViewController alloc] init];
        UIImageView* imgv=[[UIImageView alloc] initWithFrame:CGRectMake(0, -60, KScreenHeight, KScreenWidth)];
        imgv.image=IMG(Default);
        [hudVC.view insertSubview:imgv atIndex:0];
        [imgv release];
		[hudVC presentHUD:LTXT(PP_LOGIN_Third_Tips)];
//        Alert(LTXT(PP_LOGIN_Third_Tips));
	}
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
}

-(void) addHUD:(NSString*)tip
{
	if(hudVC == nil)
    {
		hudVC=[[HudViewController alloc] init]; 
		[hudVC presentHUD:tip]; 
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
}

-(void) removeHUD
{
	if(hudVC != nil)
    {
		[hudVC killHUD];
		[hudVC.view removeFromSuperview]; 
		hudVC=nil;
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}

-(void) paoLoading:(NSString*)msg
{
    [self paoCancelLoading];
    if(isPaoLoading)
    {
        return;
    }
    isPaoLoading = YES;
    int w=250;
    int h=50;
    int x=(KScreenHeight-w)/2;
    int y=(KScreenWidth-KNavBarHeight)*2/5;
    
    UIButton* block=[self.view buildBlankBtn:CGRectMake(0, KNavBarHeight, KScreenHeight, KScreenWidth-KNavBarHeight) target:nil action:nil];
    block.tag=1212;
    
    UIView* bg=[block buildBgView:ColorGrayA(0, 0.5) frame:CGRectMake(x, y, w, h)];
    [bg setRound:5];
    
    x=10;
    y=10;
    w=h=30;
    
    UIActivityIndicatorView* ind=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [bg addSubview:ind];
    [ind release];
    
    ind.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
    ind.backgroundColor=[UIColor clearColor];
    [ind startAnimating];
    
    x=ind.left+40;
    UILabel* lab=[bg buildTopLeftLabel:msg frame:CGRectMake(x, y+5, bg.width-x-10, 30) font:Font(16) color:KWhiteColor];
    lab.numberOfLines=1;
    
    bg.width=lab.width+ind.width+20*3;
    bg.left=(KScreenHeight-bg.width)/2;
    ind.left=17;
    lab.left=60;
}
-(void) paoCancelLoading
{
    isPaoLoading = NO;
    [[self.view viewWithTag:1212] removeFromSuperview];
}

-(void) popNavMenu
{
    float w=386.0/2;
    float x=(KScreenWidth-w)/2;
    float y=KNavBarHeight-6;
    
    self.menuTrangle.image=IMG(trangle2);
    
//    UIView* bg=[self.view buildBgView:KClearColor frame:self.view.frame];
    UIButton* bg=[self.view buildBlankBtn:self action:@selector(closeMenu)];
    bg.tag=EControllerMenuBgTag;
    
    UIImage* img=nil;
    UIImage* img2=nil;
    UIButton* btn=nil;
    float oy=0;
    
    for(int k=0;k<self.menus.count;k++)
    {
        img=(k==0 ? IMG(menu_bg_up) : (k==self.menus.count-1) ? IMG(menu_bg_down) : IMG(menu_bg_center));
        img2=(k==0 ? IMG(menu_sel_up) : (k==self.menus.count-1) ? IMG(menu_sel_down) : IMG(menu_sel_center));
        
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(x, y, img.size.width/2, img.size.height/2);
        [btn setImage:img forState:UIControlStateNormal];
        [btn setImage:img2 forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(selectMenuItem:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:btn];
        btn.tag=k;
        
        oy=(k==0 ? 11 : (k==self.menus.count-1) ? 0 : 0);
        [btn buildLabel:[self.menus objectAtIndex:k] frame:CGRectMake(0, oy, btn.width, 44) font:Font(16) color:KPTxtDeepGray].textAlignment=NSTextAlignmentCenter;
        
        y+=img.size.height/2;
    }
}
-(void) selectMenuItem:(UIButton*)btn
{
    if(self.menuIndex!=btn.tag)
    {
        self.menuIndex=btn.tag;
        UILabel* lab=(UILabel*)[navbar viewWithTag:EControllerNavTitleTag];
        lab.text=[self.titles objectAtIndex:self.menuIndex];
        
        int txtlen=txtLength(lab.text, KNavTitleFont, lab.width);
        menuTrangle.left=lab.left+(lab.width-txtlen)/2+txtlen+5;
        
        [self selectMenu:self.menuIndex];
    }
    
    [self closeMenu];
}
-(void) selectMenu:(int)index
{
    LOG(@"GControl::selectMenu - %d",index);
}
-(void) closeMenu
{
    self.menuTrangle.image=IMG(trangle);
    [[self.view viewWithTag:EControllerMenuBgTag] removeFromSuperview];
}

//#pragma mark -- UIAccelerometer
//-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
//{
////    NSLog(@"x = %f,y = %f,z = %f",fabsf(acceleration.x),fabsf(acceleration.y),fabsf(acceleration.z));
//
//    if (fabsf(acceleration.x)>1.4 || fabsf(acceleration.y)>1.4 || fabsf(acceleration.z)>1.4 ||
//        fabsf(acceleration.x)+fabsf(acceleration.y)+fabsf(acceleration.z)>3)
//    {
//        NSDate *now = [[NSDate alloc] init];
//        NSDate *checkDate = [[NSDate alloc] initWithTimeInterval:2.0f sinceDate:appDelegate.shakeStart];
//        if([now compare:checkDate] == NSOrderedDescending)
//        {
//            NSDate *temdate = [[NSDate alloc] init];
//            appDelegate.shakeStart = temdate;
//            [self movePhone];
//
//            [temdate release];
//            NSLog(@"你摇动我了~x = %f,y = %f,z = %f",fabsf(acceleration.x),fabsf(acceleration.y),fabsf(acceleration.z));
//        }
//        
//        [now release];
//        [checkDate release];
//        
//    }
//
//}

-(void) movePhone
{
}
#pragma mark - zyg - build nav
-(void) buildBackground
{
//    self.view.backgroundColor=[UIColor colorWithPatternImage:IMG(bg_background)];
    self.view.backgroundColor=KPageBackgroundColor;
}

//-(void) showNoLocationTip
//{
//    NSString* tip=LTXT(PP_LocationNoOpenTip);
//    if(appDelegate.beTimeOut)
//        tip=LTXT(PP_PositionErrorTip);
//    
//    Alert(tip);
//}

-(UIView*) buildNavBarWithLogo
{
    if(navbar!=nil && [navbar retainCount]>0)
    {
        [navbar removeFromSuperview];
        navbar=nil;
        leftBtn=nil;
        rightBtn=nil;
    }
    
	navbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, KNavBarHeight+KNavBarHeightOff)];
    navbar.backgroundColor=KClearColor;
    [self.view addSubview:navbar];
    [navbar release];
    
    UIImage* img=IMG(top);
    img=[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
	UIImageView* iv=[[UIImageView alloc] initWithFrame:navbar.frame];
	[iv setImage:img];
	[navbar addSubview:iv];
	[iv release];
    
    UIImage* logo=IMG(logo);
    UIImageView* lv=[[UIImageView alloc] initWithImage:logo];
    lv.frame=CGRectMake((320-logo.size.width/2)/2, (KNavBarHeight-logo.size.height/2)/2, logo.size.width/2, logo.size.height/2);
    [iv addSubview:lv];
    [lv release];
    
    return navbar;
}
-(UILabel*) buildNavBarWithTitle:(NSString*)str
{
    if(navbar!=nil)
    {
        [navbar removeFromSuperview];
        navbar=nil;
        leftBtn=nil;
        rightBtn=nil;
    }
    
    navbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KNavBarHeight+KNavBarHeightOff)];
    navbar.backgroundColor=KClearColor;
    [self.view addSubview:navbar];
    [navbar release];
    
    UIImage* img=IMG(top);
    img=[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
	UIImageView* iv=[[UIImageView alloc] initWithFrame:navbar.frame];
	[iv setImage:img];
	[navbar addSubview:iv];
	[iv release];
    
    UILabel* lab=[[UILabel alloc] initWithFrame:CGRectMake(KNavTitleLeft, KNavTitleTop, KNavTitleWidth, 30)];
    lab.text=str;
    lab.font=KNavTitleFont;
    lab.textColor=KWhiteColor;
//    lab.shadowColor=Color(170, 15, 31);
//    lab.shadowOffset=CGSizeMake(-1, -1);
    lab.textAlignment=UITextAlignmentCenter;
    lab.backgroundColor=[UIColor clearColor];
	[navbar addSubview:lab];
	[lab release];
    
    return lab;
}
-(UILabel*) buildNavBarWithTitle2:(NSString*)str
{
    if(navbar!=nil)
    {
        [navbar removeFromSuperview];
        navbar=nil;
        leftBtn=nil;
        rightBtn=nil;
    }
    
    navbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KNavBarHeight+KNavBarHeightOff)];
    navbar.backgroundColor=KClearColor;
    [self.view addSubview:navbar];
    [navbar release];
    
    UIImage* img=IMG(title_bg);
    img=[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
	UIImageView* iv=[[UIImageView alloc] initWithFrame:navbar.frame];
	[iv setImage:img];
	[navbar addSubview:iv];
	[iv release];
    
    UILabel* lab=[[UILabel alloc] initWithFrame:CGRectMake(KNavTitleLeft, KNavTitleTop, KNavTitleWidth, 30)];
    lab.text=str;
    lab.font=KNavTitleFont;
    lab.textColor=KWhiteColor;
    lab.textAlignment=UITextAlignmentCenter;
    lab.backgroundColor=[UIColor clearColor];
	[navbar addSubview:lab];
	[lab release];
    
    return lab;
}
-(UILabel*) buildNavBarWithMenuTitle:(NSArray*)menu titles:(NSArray*)title defaultIndex:(int)index
{
    if(navbar!=nil)
    {
        [navbar removeFromSuperview];
        navbar=nil;
        leftBtn=nil;
        rightBtn=nil;
    }
    
    navbar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KNavBarHeight+KNavBarHeightOff)];
    navbar.backgroundColor=KClearColor;
    [self.view addSubview:navbar];
    [navbar release];
    
    UIImage* img=IMG(top);
    img=[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
	UIImageView* iv=[[UIImageView alloc] initWithFrame:navbar.frame];
	[iv setImage:img];
	[navbar addSubview:iv];
	[iv release];
    
    self.menus=menu;
    self.titles=title;
    self.menuIndex=index;
    NSString* str=[title objectAtIndex:index];
    
    UILabel* lab=[[UILabel alloc] initWithFrame:CGRectMake(KNavTitleLeft, KNavTitleTop, KNavTitleWidth, 30)];
    lab.text=str;
    lab.font=KNavTitleFont;
    lab.textColor=KWhiteColor;
    lab.shadowColor=Color(170, 15, 31);
    lab.shadowOffset=CGSizeMake(-1, -1);
    lab.textAlignment=UITextAlignmentCenter;
    lab.backgroundColor=[UIColor clearColor];
	[navbar addSubview:lab];
    lab.tag=EControllerNavTitleTag;
	[lab release];
    
    int txtlen=txtLength(str, KNavTitleFont, lab.width);
    int x=(lab.width-txtlen)/2+txtlen+5;
    menuTrangle=[navbar buildImage2:IMG(trangle) frame:CGRectMake(lab.left+x, 21, 11, 5.5)];
    
    [navbar buildBlankBtn:lab.frame target:self action:@selector(popNavMenu)];
    
    return lab;
}
-(UIButton*) buildNavLeftBtn:(UIImage*)img target:(id)tar action:(SEL)action
{
    if(leftBtn!=nil)
    {
        [leftBtn removeFromSuperview];
        leftBtn=nil;
    }
    
    leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
	[leftBtn setImage:img forState:UIControlStateNormal];
//	leftBtn.frame=KNavLeftBtnRect;
	leftBtn.frame=CGRectMake(KNavLeftBtnRect.origin.x, KNavLeftBtnRect.origin.y, KNavLeftBtnRect.size.width, KNavLeftBtnRect.size.height);
    
	[leftBtn addTarget:tar action:action forControlEvents:UIControlEventTouchUpInside];
    [navbar addSubview:leftBtn];
    
    leftBtn.showsTouchWhenHighlighted=YES;
    return leftBtn;
}
-(UIButton*) buildNavRightBtn:(UIImage*)img target:(id)tar action:(SEL)action
{
    if(rightBtn!=nil)
    {
        [rightBtn removeFromSuperview];
        rightBtn=nil;
    }
    
    rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
	[rightBtn setImage:img forState:UIControlStateNormal];
//    rightBtn.frame=KNavRightBtnRect;
	rightBtn.frame=CGRectMake(KScreenWidth-img.size.width-KNavLeftBtnRect.origin.x, KNavLeftBtnRect.origin.y, KNavRightBtnRect.size.width, KNavRightBtnRect.size.height);
    
    [rightBtn addTarget:tar action:action forControlEvents:UIControlEventTouchUpInside];
    [navbar addSubview:rightBtn];
    
    rightBtn.showsTouchWhenHighlighted=YES;
    return rightBtn;
}
-(UIButton*) buildNavRightBtnTxt:(NSString*)txt target:(id)target action:(SEL)action
{
    [self buildNavRightBtn:IMG(btn_next) target:self action:action];
    [rightBtn buildLabel:txt frame:CGRectMake(0, 0, KNavRightBtnRect.size.width, KNavRightBtnRect.size.height) font:FontBold(14) color:KWhiteColor].textAlignment = NSTextAlignmentCenter;
    return rightBtn;
}
-(UIButton*) buildNavLeftBackBtn
{
    [self buildNavLeftBtn:IMG(back) target:self action:@selector(back:)];
    return leftBtn;
}

#pragma mark -watering -- newzan
-(void) addNewZan:(NSString*)tips
{
    UIView *newzanview = [[UIView alloc] initWithFrame:CGRectMake(0, KNavBarHeight, KScreenWidth, 30)];
    newzanview.tag = EControllerNewZanViewTag;
    UIImage* image = [IMG(new_cell_bg) stretchableImageWithLeftCapWidth:18 topCapHeight:15];
    [newzanview buildImage2:image frame:CGRectMake(0, 0, KScreenWidth, 30)];
    CGSize size = [tips sizeWithFont:Font(14)];
    NSInteger x = (KScreenWidth - size.width)/2;
    [newzanview buildLabel:tips frame:CGRectMake(x, 0, size.width, 30) font:Font(14) color:KPTableHeadTextColor].textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:newzanview];
    [newzanview release];
    newzanview.alpha = 0.0f;
    [self doAddnewzanAnimate];
}

-(void) doAddnewzanAnimate
{
    UIView *view = [self.view viewWithTag:EControllerNewZanViewTag ];
    if(view)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDidStopSelector:@selector(doAddnewzanAnimateStop)];
        [UIView setAnimationDelegate:self];
        view.alpha = 1.0f;
        
        [UIView commitAnimations];
    }
}
-(void) doAddnewzanAnimateStop
{
    [self performSelector:@selector(hiddenAddnewzanAnimate:) withObject:nil afterDelay:2];
}

-(void)hiddenAddnewzanAnimate:(id)sender
{
    UIView *view = [self.view viewWithTag:EControllerNewZanViewTag ];
    if(view)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDidStopSelector:@selector(hiddenAddnewzanAnimateStop)];
        [UIView setAnimationDelegate:self];
        view.alpha = 0.0f;
        
        [UIView commitAnimations];
    }
}

-(void) hiddenAddnewzanAnimateStop
{
    UIView *view = [self.view viewWithTag:EControllerNewZanViewTag ];
    if(view)
    {
        [view removeFromSuperview];
    }
}

#pragma mark - watering -animate
-(void) doZanAnimate
{
    UIImageView *zan=[[UIImageView alloc]initWithFrame:CGRectMake(96, (KContentHeight-128)/2-35, 128, 128)];
    zan.alpha = 0.0;
    zan.image=[UIImage imageNamed:@"like_animl.png"];
    zan.tag = EControllerZanViewTag;
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [zan.layer addAnimation:animation forKey:nil];
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    zan.alpha = 0.8;
    [UIView commitAnimations];
    [self.view addSubview:zan];
    [zan release];

    [self performSelector:@selector(dismissZan:) withObject:zan afterDelay:0.5];
}

-(void) dismissZan:(id)obj
{
    
    UIImageView *img=(UIImageView*)obj;
    if (img)
    {
        [img removeFromSuperview];
    }
}

-(void) doCaiAnimate
{
    UIImageView *zan=[[UIImageView alloc]initWithFrame:CGRectMake(96, (KContentHeight-128)/2-35, 128, 128)];
    zan.image=[UIImage imageNamed:@"unlike_animal.png"];
    zan.alpha = 0.0;
    zan.tag = EControllerCaiViewTag;
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [zan.layer addAnimation:animation forKey:nil];
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    zan.alpha = 0.8;
    [UIView commitAnimations];
    
    [self.view addSubview:zan];
    [zan release];
    
    [self performSelector:@selector(dismissCai:) withObject:zan afterDelay:0.5];
}

-(void)dismissCai:(id)obj
{
    
    UIImageView *img=(UIImageView*)obj;
    if (img)
    {
        [img removeFromSuperview];
    }
}

#pragma mark - watering -share

-(void) buileShare:(id)adelegate
{
    [self screenShots];
    UIActionSheet* actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:adelegate cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];

    sharesnsdelegate = adelegate;
//    [actionSheet addButtonWithTitle:LTXT(PP_Share_QQ_Friend)];
    [actionSheet addButtonWithTitle:LTXT(PP_Share_Weixin_Friend)];
    [actionSheet addButtonWithTitle:LTXT(PP_Share_Weixin_Zone)];
    
    [actionSheet addButtonWithTitle:LTXT(PP_Share_Weibo_Sina)];
    [actionSheet addButtonWithTitle:LTXT(PP_CANCEL)];
    actionSheet.tag=KShareSheetTag;
    actionSheet.cancelButtonIndex=actionSheet.numberOfButtons-1;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

-(void) doShareIndex:(NSInteger)index
{
    NSLog(@"index = %d",index);
    switch (index) {
        case 0:
        {
            //分享到微信好友
            if(screenImage)
            {
//                [appDelegate sendImageContentSession:screenImage];
            }
            
        }
            break;
        case 1:
        {
            //分享到微信朋友圈
            if(screenImage)
            {
//                [appDelegate sendImageContentTimeline:screenImage];
            }
        }
            break;
        case 2:
        {
            //分享到微博类网站
//            [self jumpPageShareSns:screenImage];
        }
            break;
//        case 3:
//        {
//            //分享到qq好友
//        }
            break;
            
        default:
            break;
    }
}

-(void) screenShots
{
    if(isneedscreenshot)
    {
        CGSize imageSize = [[UIScreen mainScreen] bounds].size;
        if (NULL != UIGraphicsBeginImageContextWithOptions) {
            UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
        }
        else
        {
            UIGraphicsBeginImageContext(imageSize);
        }
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        for (UIWindow * window in [[UIApplication sharedApplication] windows]) {
            if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
                CGContextSaveGState(context);
                CGContextTranslateCTM(context, [window center].x, [window center].y);
                CGContextConcatCTM(context, [window transform]);
                CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
                [[window layer] renderInContext:context];
                
                CGContextRestoreGState(context);
            }
        }
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //    [[ImageNetManager sharedImageNetManager]saveImage:image filename:KScreenShotPhotoName];
        self.screenImage = image;
        UIGraphicsEndImageContext();
//        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        NSLog(@"Suceeded!");
    }
}

-(void) buildNoContentTips:(NSString*)tips
{
    [self removeNoContentTips];
    UIView* view=[self.view buildBgView:KClearColor frame:CGRectMake(0, KNavBarHeight, KScreenWidth, KContentHeight)];
    view.userInteractionEnabled=YES;
    view.tag=1998;
    
    float w=176.0/2;
    float h=195.0/2;
    float x=(KScreenWidth-w)/2;
    float y=(KContentHeight-250)/2;
    [view buildImage2:IMG(bear) frame:CGRectMake(x, y, w, h)].userInteractionEnabled=YES;
    
    x=30;
    y+=h+40;
    w=KScreenWidth-x-x;
    [view buildLabel:tips frame:CGRectMake(x, y, w, 60) font:FontBold(16) color:KPTxtLightGray].textAlignment=NSTextAlignmentCenter;
}

-(void) removeNoContentTips
{
    [[self.view viewWithTag:1998] removeFromSuperview];
}

#pragma mark door Animate
#define KLeftDoorWidth 317.0/2
#define KRighttDoorWidth 198
#define KRighttDoorX 122
-(void) addDoorAnimate
{
    [self.view buildImage2:IMG(doormovieleft) frame:CGRectMake(0, 0, KLeftDoorWidth, KContentHeight)].tag=EControllerDoorLeftImageTag;
    [self.view buildImage2:IMG(doormovieright) frame:CGRectMake(KRighttDoorX, 0, KRighttDoorWidth, KContentHeight)].tag=EControllerDoorRightImageTag;
}

-(void) addCloseDoorAnimate
{
    if([self.view viewWithTag:EControllerDoorLeftImageTag]==nil)
        [self.view buildImage2:IMG(doormovieleft) frame:CGRectMake(-KLeftDoorWidth, 0, KLeftDoorWidth, KContentHeight)].tag=EControllerDoorLeftImageTag;
    if([self.view viewWithTag:EControllerDoorRightImageTag]==nil)
        [self.view buildImage2:IMG(doormovieright) frame:CGRectMake(KScreenWidth, 0, KRighttDoorWidth, KContentHeight)].tag=EControllerDoorRightImageTag;
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [self.view viewWithTag:EControllerDoorLeftImageTag].frame=CGRectMake(0, 0, KLeftDoorWidth, KContentHeight);
    [self.view viewWithTag:EControllerDoorRightImageTag].frame=CGRectMake(KRighttDoorX, 0, KRighttDoorWidth, KContentHeight);
    [UIView commitAnimations];
}

-(void) startDoorAnimate
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDidStopSelector:@selector(doorAnimateStop)];
    [UIView setAnimationDelegate:self];
    
    [self.view viewWithTag:EControllerDoorLeftImageTag].frame=CGRectMake(-KLeftDoorWidth, 0, KLeftDoorWidth, KContentHeight);
    [self.view viewWithTag:EControllerDoorRightImageTag].frame=CGRectMake(KScreenWidth, 0, KRighttDoorWidth, KContentHeight);
        
    [UIView commitAnimations];
}

-(void) doorAnimateStop
{
    [[self.view viewWithTag:EControllerDoorLeftImageTag] removeFromSuperview];
    [[self.view viewWithTag:EControllerDoorRightImageTag] removeFromSuperview];
}

-(void) closeDoor
{
    // build down
    UIView* up=[[UIView alloc] initWithFrame:CGRectMake(0, -KContentHeight/2, KScreenWidth, KContentHeight/2)];
    [self.view addSubview:up];
    [up release];
    
    UIImage* img=IMG(door_line);
    img=[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
    up.backgroundColor=[UIColor colorWithPatternImage:IMG(door_bg)];
    [up buildImage2:img frame:CGRectMake(0, up.height-7.5, KScreenWidth, 7.5)].tag=121;
    up.tag=101;
    
    UIImage* img2=IMG(bear2);
    [up buildImage2:img2 frame:CGRectMake((up.width-img2.size.width/2)/2, up.height-img2.size.height/2-30, img2.size.width/2, img2.size.height/2)];
    
    // build down
    UIView* down=[[UIView alloc] initWithFrame:CGRectMake(0, KContentHeight, KScreenWidth, KContentHeight/2)];
    [self.view addSubview:down];
    [down release];
    
    down.backgroundColor=[UIColor colorWithPatternImage:IMG(door_bg)];
    [down buildImage2:img frame:CGRectMake(0, 0, KScreenWidth, 7.5)].tag=122;
    down.tag=102;
    
    // build label
    float x=30;
    float y=60;
    float w=30;
    float h=30;
    
    UIActivityIndicatorView* ind=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [down addSubview:ind];
    [ind release];
    
    ind.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
    ind.backgroundColor=[UIColor clearColor];
    [ind startAnimating];
    
    x=70;
    UILabel* lab=[down buildTopLeftLabel:LTXT(PP_PhotoIsLoading) frame:CGRectMake(x, y+4, down.width-x-10, 30) font:FontBold(16) color:KWhiteColor];
    lab.numberOfLines=1;
    lab.shadowOffset=CGSizeMake(1, 1);
    lab.shadowColor=ColorGrayA(100, 0.7);
//    lab.left=ind.right+(down.width-ind.right-10-lab.width)/2;
    
    // do animation
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    
    up.top=0;
    down.top=KContentHeight/2;
    
    [UIView commitAnimations];
    [self performSelector:@selector(hideLine) withObject:nil afterDelay:0.4];
}
-(void) openDoor
{
    [self.view viewWithTag:121].hidden=NO;
    [self.view viewWithTag:122].hidden=NO;
    
    // do animation
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    
    [self.view viewWithTag:101].top=0;
    [self.view viewWithTag:101].top=KContentHeight/2;
    
    [UIView commitAnimations];
    [self performSelector:@selector(hideLine) withObject:nil afterDelay:0.4];
}
-(void) hideLine
{
    [self.view viewWithTag:121].hidden=YES;
    [self.view viewWithTag:122].hidden=YES;
}

#pragma mark - keil - jump

-(void) jumpPageWebview:(NSString*)url withTitle:(NSString*)title
{
    NSURLRequest* request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    PWWebViewController* con=[[PWWebViewController alloc] initWithRequest:request];
    con.navTitle=title;
    [appDelegate.navController pushViewController:con animated:YES];
    [con release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
