
#import "GImageView.h"
#import "UIView_Extras.h"
#import "UIImage_Extras.h"
#import "GDefine.h"
#import "GUtil.h"
#import "ADAppDelegate.h"

#define KQiqoEventUrlKey @"__qe.add"
#define QiaoEventUrl(url) [NSString stringWithFormat:@"%@%@",url,KQiqoEventUrlKey]

@implementation GImageView
@synthesize beSync,beRound,beSquare,frameImage,needCutToFit;

-(id) initWithFrame:(CGRect)frame
{
    if((self=[super initWithFrame:frame]))
    {
        beSync = YES;
    }
    return self;
}

//-(void) loadQiaoImage:(NSString*)imgurl defalutImage:(UIImage*)defaultImg square:(BOOL)needSquare
//{
//    beQiaoEventImg=YES;
//    self.beSquare=needSquare;
//    [self loadImage:imgurl defalutImage:defaultImg];
//}
//
//-(void) loadQiaoImage:(NSString*)imgurl bigimage:(NSString*)bigimage defalutImage:(UIImage*)defaultImg square:(BOOL)needSquare
//{
//    if(appDelegate.isBigImage)
//    {
//        [self loadQiaoImage:bigimage defalutImage:defaultImg square:needSquare];
//    }
//    else
//    {
//        [self loadQiaoImage:imgurl defalutImage:defaultImg square:needSquare];
//    }
//}

-(void) loadImage:(NSString*)imgurl defalutImage:(UIImage*)defaultImg
{
//    if(beQiaoEventImg && beSquare && [ImageManager hasImageBuffer:QiaoEventUrl(imgurl)]) // check and replace imgurl
//    {
//        imgurl=QiaoEventUrl(imgurl);
//        self.beSquare=NO;
//    }
    
    UIImage* img=nil;
    if(beSync)
        img=[ImageManager reqSyncImage:imgurl imgDelegate:self];
    else
        img=[ImageManager reqImage:imgurl imgDelegate:self needProcess:NO];
    
    if(img==nil)
    {
        if(defaultImg!=nil && [defaultImg isKindOfClass:[UIImage class]])
            self.image=defaultImg;
    }
    else
    {
        [self getImage:img];
    }
    if(frameImage!=nil)
    {
        [self buildImage2:frameImage frame:CGRectMake(0, 0, self.width, self.height)];
    }
}

-(void) loadImage:(NSString*)imgurl delegate:(id<ImageDownloadDelegate>)imgdelegate
{
    delegate=imgdelegate;
    UIImage* img=[ImageManager reqImage:imgurl imgDelegate:self needProcess:NO];
    
    if(img && delegate && [delegate respondsToSelector:@selector(imageDownloadFinish:downloadItem:)])
    {
        [delegate imageDownloadFinish:img downloadItem:nil];
    }
}

-(void) loadImage:(NSString*)imgurl bigimage:(NSString*)bigimage defalutImage:(UIImage*)defaultImg
{
//    if(UseBigImage)
//    {
        [self loadImage:bigimage defalutImage:defaultImg];
//    }
//    else   
//    {
//        [self loadImage:imgurl defalutImage:defaultImg];
//    }
}

-(void) loadImage:(NSString*)imgurl bigimage:(NSString*)bigimage delegate:(id<ImageDownloadDelegate>)imgdelegate
{
//    if(UseBigImage)
//    {
        [self loadImage:bigimage delegate:imgdelegate];
//    }
//    else
//    {
//        [self loadImage:imgurl delegate:imgdelegate];
//    }
}

-(void) getImage:(UIImage*)img
{
    if(img!=nil)
    {
        if(self.beSquare)
            img=[img cutSquare];
        
        if(self.beRound)
            img=[img roundCorners];
        
        if(self.frame.size.width==0)
            self.size=img.size;
        else if(needCutToFit && (img.size.width!=self.width || img.size.height!=self.height) && img.size.width/self.width!=img.size.height/self.height)
        {
            float zoomY=img.size.height/self.height/2;
            float x=0;
            float w=img.size.width;
            float h=img.size.height/zoomY;
            float y=(img.size.height-h)/2;
            
            if(y>0)
            {
                img=[img getSubImage:CGRectMake(x, y, w, h)];
            }
        }
        
        self.image=img;
        if(self.width==KScreenWidth&&self.height==SCREEN_HEIGHT)
        {
            if((img.size.width>KScreenWidth||img.size.height>SCREEN_HEIGHT))
            {
//              img=[GUtil thumbnailWithImageWithoutScale:img size:self.size];
                img=[img scaleToSize:self.size];
            }
            self.size=img.size;
//          self.origin=CGPointMake(KScreenWidth/2-self.size.width/2, KScreenHeight/2-self.size.height/2-10);
        }
    }
    getImage=YES;
}

-(void) imageDownloadFinish:(UIImage*)img downloadItem:(ImageDownloadItem*)item
{
    [self getImage:img];
    
//    if(beQiaoEventImg && beSquare && ![item.imgurl hasSuffix:KQiqoEventUrlKey]) // save square to buffer
//    {
//        [ImageManager saveImage:self.image imgurl:QiaoEventUrl(item.imgurl)];
//    }
    if(delegate && [delegate respondsToSelector:@selector(imageDownloadFinish:downloadItem:)])
    {
        [delegate imageDownloadFinish:img downloadItem:item];
    }
}

-(void) imageDownloadProgress:(NSNumber*)progress
{
}

-(void) imageDownloadFailed:(ImageDownloadItem*)item
{
    if(delegate && [delegate respondsToSelector:@selector(imageDownloadFailed:)])
    {
        [delegate imageDownloadFailed:item];
    }
}

-(void) dealloc
{
    [self clearImage];
	[super dealloc];
}

-(void) clearImage
{
    [ImageManager removeDelegate:self];
    self.image=nil;
    self.frameImage=nil;
}

@end
