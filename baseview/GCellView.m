
#import "GCellView.h"
#import "GDefine.h"
#import "UIView_Extras.h"
#import "GImageView.h"

@implementation GCellView
@synthesize dict;

-(void) dealloc
{
    [dict release];
    
    [super dealloc];
}

-(id) initWithFrame:(CGRect)frame 
{
	if((self = [super initWithFrame:frame])) 
	{
        self.backgroundColor=KColorFindBg;
        [self buildImage2:IMG(split_person) frame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        arrow=[self buildImage2:IMG(arrow2) frame:CGRectMake(frame.size.width-20, 20, 11, 17)];
        
        bgview=[self buildImage2:IMG(bg_banner_friend2) frame:CGRectMake(0, -1, frame.size.width, frame.size.height+1)];
        arrow2=[bgview buildImage2:IMG(arrow) frame:CGRectMake(frame.size.width-20, 20, 11, 17)];
        bgview.hidden=YES;
	}
    return self;
}

-(UIView*) setCellFocus:(BOOL)focus
{
    if(!passChangeBg)
        bgview.hidden=!focus;
    return self;
}

-(void) removeArrow
{
    [arrow removeFromSuperview]; arrow=nil;
    [arrow2 removeFromSuperview]; arrow2=nil;
}

@end


@implementation GCellPeople

-(void) buildCell:(NSDictionary*)dt
{
    self.dict=dt;
    
    float x=8;
    float y=8;
    int w=40;
    int h=40;
    
    float tx=55;
    float ty=6;
    float ty2=26;
    
    float ix=KScreenWidth-72;
    GImageView* iv=nil;
    
    NSDictionary* User=[dt objectForKey:@"User"];
    [self buildImage:[User objectForKey:@"avatar"] frame:CGRectMake(x, y, w, h) defaultimg:IMG(defaultmanavatar)].beRound=YES;
    [self buildTopLeftLabel:[User objectForKey:@"nickname"] frame:CGRectMake(tx, ty, 200, 25) font:FontBold(15) color:KBlackColor];
    
    if(StrValid([dt objectForKey:@"distance"]))
        [self buildTopLeftLabel:[dt objectForKey:@"distance"] frame:CGRectMake(tx, ty2, 200, 25) font:Font(12) color:KGrayColor];
    
    NSDictionary* Photos=[[dt objectForKey:@"Photos"] firstObject];
    if(StrValid([Photos objectForKey:@"thumb_url_s"]))
        iv=[self buildImage:[Photos objectForKey:@"thumb_url_s"] frame:CGRectMake(ix, y, w, h)];
    else
        iv=[self buildImage:[dt objectForKey:@"thumb_url_s"] frame:CGRectMake(ix, y, w, h)];
    iv.beRound=YES;
    iv.beSquare=YES;
}

@end


@implementation GCellPeople2
@synthesize hasAdd,beInvite,parent;

-(void) buildCell:(NSDictionary*)dt
{
    self.dict=dt;
    [self removeArrow];
    
    float x=9;
    float y=9;
    int w=35;
    int h=35;
    
    float tx=55;
    float ty=16;
    
    float bw=40;
    float bh=30;
    float bx=KScreenWidth-50;
    float by=12;
    
    [self buildImage:[dt objectForKey:@"avatar"] frame:CGRectMake(x, y, w, h) defaultimg:IMG(defaultmanavatar)].beRound=YES;
    [self buildTopLeftLabel:[dt objectForKey:@"nickname"] frame:CGRectMake(tx, ty, 200, 25) font:FontBold(15) color:KBlackColor];
    
    if(beInvite)
    {
        UIButton* btn=[self buildImgBtn:CGRectMake(bx, by, bw, bh) target:parent action:@selector(clickBtnAddOrInvite:) image:IMG(btn_blank)];
        [btn buildLabel:LTXT(PP_Invite_) frame:CGRectMake(12, 0, 20, btn.height) font:Font(15) color:KWhiteColor];
        passChangeBg=YES;
    }
    else
    { 
        BOOL is_following=[[dt objectForKey:@"is_following"] boolValue];
        if (!is_following) {
            [self buildImgBtn:CGRectMake(bx, by, bw, bh) target:parent action:@selector(clickBtnAddOrInvite:) image:IMG(focus)]; // unfollow_button
        }
    }
}

@end
