
#import "ImageNetManager.h"

@class GImageView;

@interface GImageView : UIImageView <ImageDownloadDelegate>
{
    BOOL getImage;
//    BOOL beQiaoEventImg;
    id<ImageDownloadDelegate> delegate;
}

@property (nonatomic,assign) BOOL beSync;
@property (nonatomic,assign) BOOL beRound;
@property (nonatomic,assign) BOOL beSquare;
@property (nonatomic,assign) BOOL needCutToFit;
@property (nonatomic,retain) UIImage* frameImage;

-(void) loadImage:(NSString*)imgurl defalutImage:(UIImage*)defaultImg;
-(void) loadImage:(NSString*)imgurl delegate:(id<ImageDownloadDelegate>)imgdelegate;
-(void) loadImage:(NSString*)imgurl bigimage:(NSString*)bigimage defalutImage:(UIImage*)defaultImg;
-(void) loadImage:(NSString*)imgurl bigimage:(NSString*)bigimage delegate:(id<ImageDownloadDelegate>)imgdelegate;
-(void) clearImage;

//-(void) loadQiaoImage:(NSString*)imgurl defalutImage:(UIImage*)defaultImg square:(BOOL)needSquare;
//-(void) loadQiaoImage:(NSString*)imgurl bigimage:(NSString*)bigimage defalutImage:(UIImage*)defaultImg square:(BOOL)needSquare;
-(void) getImage:(UIImage*)img;

@end
