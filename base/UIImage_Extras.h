
#import <Foundation/Foundation.h>
@interface UIImage(Extras)
//static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,float ovalHeight);
-(UIImage*) imageByScalingProportionallyToSize:(CGSize)targetSize;
-(UIImage*) getSubImage:(CGRect)rect;

-(UIImage*) scaleToSize:(CGSize)size;
-(UIImage*) GPScale;
-(UIImage*) scaleWithMaxLen:(float)maxlen;
-(UIImage*) cutSquare;

-(UIImage*) roundCorners;
-(UIImage*) roundCorners:(CGFloat)radius;

-(UIImage*) scaleAndRotateImage;
-(UIImage*) scaleAndRotateImage:(int)length;

-(UIImage*) blurImage:(int)radius;

@end
