
#import <UIKit/UIKit.h>
#import "ImageNetManager.h"

@interface GPopImageScrollView : UIScrollView <UIScrollViewDelegate,ImageDownloadDelegate>
{
    CGRect imgrect;
    UIImageView* myImgView;
}

-(void) buildImageView:(UIView*)parentView imgView:(UIImageView*)imgview withUrl:(NSString*)imgurl;

@end
