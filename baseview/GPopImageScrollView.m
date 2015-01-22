
#import "GPopImageScrollView.h"
#import "GDefine.h"
#import "UIView_Extras.h"

#define KScrollOffset 320
#define KPopTime 0.3

@implementation GPopImageScrollView

-(id) initWithFrame:(CGRect)frame 
{
	if((self=[super initWithFrame:frame])) 
	{
        self.delegate=self;
        self.maximumZoomScale=3.0;
        self.minimumZoomScale=1.0;
	}
    return self;
}

-(void) dealloc
{
    [ImageManager removeDelegate:self];
    [super dealloc];
}

-(void) buildImageView:(UIView*)parentView imgView:(UIImageView*)imgview withUrl:(NSString*)imgurl
{
    [parentView addSubview:self];
    imgrect=[imgview convertRect:CGRectMake(0, 0, imgview.width, imgview.height) toView:parentView];
    self.backgroundColor=KBlackColor;
    self.alpha=0;
    
    [self addTarget:self action:@selector(unpopImage:)];
    myImgView=[self buildImage2:imgview.image frame:imgrect];
    
    float maxw=320;
    float maxh=460;
    float o=imgview.image.size.width/imgview.image.size.height;
    float width=(o>=maxw/maxh) ? maxw : maxh*o;
    float height=(o>=maxw/maxh) ? maxw/o : maxh;
    CGRect rect2=CGRectMake((KScreenWidth-width)/2, (maxh-height)/2, width, height);
    
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:KPopTime];
    myImgView.frame=rect2;
    myImgView.alpha=1.0;
    self.alpha=0.9;
    [UIView commitAnimations];
    
    [ImageManager reqImage:imgurl imgDelegate:self needProcess:NO];
}

-(void) showTabbarAndUnpop:(id)sender
{
//    [self unpopImage:sender];
//    [appDelegate showTabBar];
}

-(void) unpopImage:(id)sender
{
    if(!ValidClass(sender, UITapGestureRecognizer))
        return;
    
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:KPopTime];
    myImgView.frame=imgrect;
    myImgView.alpha=0;
    self.alpha=0;
    [UIView commitAnimations];
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:KPopTime];
}

// ImageDownloadDelegate
-(void) imageDownloadFinish:(UIImage*)img downloadItem:(ImageDownloadItem*)item
{
    myImgView.image=img;
}

// UIScrollViewDelegate
-(UIView*) viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return myImgView;
}

-(void) scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
	if(scrollView.zoomScale!=1.0 || scrollView.zooming)
        return;
    
    scrollView.contentOffset=CGPointMake(scrollView.contentOffset.x+KScrollOffset/2, scrollView.contentOffset.y);
    myImgView.left+=KScrollOffset/2;
}

-(void) scrollViewDidScroll:(UIScrollView*)scrollView
{
	if(scrollView.zoomScale>1.0)
	{
		myImgView.top= (myImgView.height-480>0) ? 0 : (480-myImgView.height)/2;
		myImgView.left= (myImgView.width-320>0) ? 0 : (320-myImgView.width)/2;
	}
}

@end
