
#import "UIImage_Extras.h"
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import "GDefine.h"

NSUInteger alphaOffset(NSUInteger x, NSUInteger y, NSUInteger w){return y * w * 4 + x * 4 + 0;}
NSUInteger redOffset(NSUInteger x, NSUInteger y, NSUInteger w){return y * w * 4 + x * 4 + 1;}
NSUInteger greenOffset(NSUInteger x, NSUInteger y, NSUInteger w){return y * w * 4 + x * 4 + 2;}
NSUInteger blueOffset(NSUInteger x, NSUInteger y, NSUInteger w){return y * w * 4 + x * 4 + 3;}

#define offR(x, y, w)   ((y) * (w) + (x) * 4 + 0)
#define offG(x, y, w)   ((y) * (w) + (x) * 4 + 1)
#define offB(x, y, w)   ((y) * (w) + (x) * 4 + 2)
#define offA(x, y, w)   ((y) * (w) + (x) * 4 + 3)

#define PI 3.1415926f
#define Min(a,b) ((a)>(b) ? (b):(a))
#define Max(a,b) ((a)>(b) ? (a):(b))
#define Abs(a,b) ((a)>(b) ? ((a)-(b)):((b)-(a)))

//static
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,float ovalHeight) 
{
	float fw, fh;
	if(ovalWidth == 0 || ovalHeight == 0) 
	{
		CGContextAddRect(context, rect);
		return;
	}
	
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGContextScaleCTM(context, ovalWidth, ovalHeight);
	fw = CGRectGetWidth(rect) / ovalWidth;
	fh = CGRectGetHeight(rect) / ovalHeight;
	
	CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
	CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
	CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
	CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
	CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
	
	CGContextClosePath(context);
	CGContextRestoreGState(context);
}

@implementation UIImage (Extras)

-(UIImage*) imageByScalingProportionallyToSize:(CGSize)targetSize
{
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if(!CGSizeEqualToSize(imageSize, targetSize)) {
		
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if(widthFactor < heightFactor) 
			scaleFactor = widthFactor;
        else
			scaleFactor = heightFactor;
		
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
		
        if(widthFactor < heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        } else if(widthFactor > heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
	}
	
	
	// this is actually the interesting part:
//	NSLog(@"target width:%f, height:%f", targetWidth, targetHeight);
	UIGraphicsBeginImageContext(targetSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
//	NSLog(@"scaled width:%f, height:%f", scaledWidth, scaledHeight);	
	if(newImage == nil) NSLog(@"could not scale image");
	
	return newImage ;
}

-(UIImage*) getSubImage:(CGRect)rect  
{  
	CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);  
	CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));  
	
	UIGraphicsBeginImageContext(smallBounds.size);  
	CGContextRef context = UIGraphicsGetCurrentContext();  
	CGContextDrawImage(context, smallBounds, subImageRef);  
	UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];  
	UIGraphicsEndImageContext();
    
    CGImageRelease(subImageRef);
	return smallImage;  
}  

//-(UIImage*) scaleToSize:(CGSize)size
//{
//    UIGraphicsBeginImageContext(size);
//    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage* scaledImage=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext(); 
//    return scaledImage;
//}

-(UIImage*) scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio > 1 && horizontalRadio > 1)
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    else
        radio = horizontalRadio > verticalRadio ? verticalRadio : horizontalRadio;
    
    width = width * radio;
    height = height * radio;
    
//    int xPos = (size.width - width)/2;
//    int yPos = (size.height - height)/2; 
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [self drawInRect:CGRectMake(0, 0, width, height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(UIImage*) scaleWithMaxLen:(float)maxlen
{
    float w=self.size.width;
    float h=self.size.height;
    
    if(w<=maxlen && h<=maxlen)
        return self;
    
    float b=maxlen/w < maxlen/h ? maxlen/w : maxlen/h;
    CGSize size=CGSizeMake(b*w, b*h);
    CGRect rect=CGRectMake(0, 0, b*w, b*h);
    
    UIGraphicsBeginImageContext(size);
    [self drawInRect:rect];
    
    UIImage* img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(UIImage*) GPScale
{
    return [self scaleWithMaxLen:KImageUploadLen];
}

-(UIImage*) cutSquare
{
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    if(width==height)
        return self;
    
    float x=0,y=0;
    float len=MIN(width,height);
    if(len==width)
        y=(height-len)/2;
    else
        x=(width-len)/2;
    
    UIGraphicsBeginImageContext(CGSizeMake(len, len));
    [self drawInRect:CGRectMake(-x, -y, width, height)];
    
    UIImage* afterImg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return afterImg;
}

-(UIImage*) roundCorners
{
	return [self roundCorners:6.0];
}

-(UIImage*) roundCorners:(CGFloat)radius
{
	int w = self.size.width;
	int h = self.size.height;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4*w, colorSpace, kCGImageAlphaPremultipliedFirst);
	
	CGContextBeginPath(context);
	CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
	addRoundedRectToPath(context, rect, radius, radius);
	CGContextClosePath(context);
	CGContextClip(context);
	
	CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
	
	CGImageRef imageMasked = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
	UIImage* image = [[UIImage alloc] initWithCGImage:imageMasked];
    CFRelease(imageMasked);
	
	return [image autorelease];
}

-(UIImage*) scaleAndRotateImage
{
    return [self scaleAndRotateImage:KImageUploadLen];
}

-(UIImage*) scaleAndRotateImage:(int)length
{	
	NSLog(@"gypsiihybridAppDelegate - scaleAndRotateImage");
	CGFloat kMaxResolution = length;
	
	CGImageRef imgRef = self.CGImage;
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	
	if(width > kMaxResolution || height > kMaxResolution) 
	{
		CGFloat ratio = width/height;
		if(ratio > 1) 
		{
			bounds.size.width = kMaxResolution;
			bounds.size.height = bounds.size.width / ratio;
		}
		else 
		{
			bounds.size.height = kMaxResolution;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	
	CGFloat boundHeight;
	UIImageOrientation orient = self.imageOrientation;
	
	switch(orient) 
	{			
		case UIImageOrientationUp:
        {
			transform = CGAffineTransformIdentity;
			break;
        }
		case UIImageOrientationUpMirrored:
        {
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			
			break;
        }
		case UIImageOrientationDown:
        {
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			
			break;
        }
		case UIImageOrientationDownMirrored:
        {
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			
			break;
        }
		case UIImageOrientationLeftMirrored:
        {
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
			
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			
			break;
        }
		case UIImageOrientationLeft:
        {
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			
			break;
        }
		case UIImageOrientationRightMirrored:
        {
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			
			break;
        }
		case UIImageOrientationRight:
        {
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
        }
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
	}
    
    int w=bounds.size.width; // format float->int
    int h=bounds.size.height;
    bounds.size=CGSizeMake(w, h);
	
	UIGraphicsBeginImageContext(bounds.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if(orient == UIImageOrientationRight || orient == UIImageOrientationLeft) 
	{
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else 
	{
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}

#pragma mark base image operation
-(unsigned char*) getImageData:(UIImage*)image // from net | something wrong?
{
    CGImageRef imageref=[image CGImage];
    CGColorSpaceRef colorspace=CGColorSpaceCreateDeviceRGB();
    //创建临时上下文
    int width=CGImageGetWidth(imageref);
    int height=CGImageGetHeight(imageref);
    int bytesPerPixel=4;
    int bytesPerRow=bytesPerPixel*width;
    int bitsPerComponent=8;
    unsigned char * imagedata=malloc(width * height * bytesPerPixel);
    CGContextRef cgcnt=CGBitmapContextCreate(imagedata,
                                             width,
                                             height,
                                             bitsPerComponent,
                                             bytesPerRow,
                                             colorspace,
                                             kCGImageAlphaPremultipliedFirst);
    //将图像写入一个矩形
    CGRect therect=CGRectMake(0,0,width,height);
    CGContextDrawImage(cgcnt,therect,imageref);
    CGContextRelease(cgcnt); // zyg add here
    //不知这一句要不要
    //    imagedata=CGBitmapContextGetData(cgcnt); // zyg pass here
    
    //释放资源
    CGColorSpaceRelease(colorspace);
    //    CGContextRelease(cgcnt); // zyg pass here
    return imagedata;
}

CGContextRef createRGBABitmapContext(CGImageRef inImage)
{
	size_t pixelsWide=CGImageGetWidth(inImage);
	size_t pixelsHigh=CGImageGetHeight(inImage);
	int bitmapBytesPerRow=pixelsWide * 4;
	int bitmapByteCount	= bitmapBytesPerRow * pixelsHigh;
    
	CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL)
	{
		fprintf(stderr, "Error allocating color space\n");
        return NULL;
	}
	
	unsigned char* bitmapData=malloc(bitmapByteCount);
	if (bitmapData == NULL)
	{
		fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
    
	CGContextRef context=CGBitmapContextCreate (bitmapData,
                                                pixelsWide,
                                                pixelsHigh,
                                                8,
                                                bitmapBytesPerRow,
                                                colorSpace,
                                                kCGImageAlphaPremultipliedLast);
	
	CGColorSpaceRelease(colorSpace);
    //	free(bitmapData); // can't free it ??
    
	return context;
}

unsigned char* requestImagePixelData(UIImage* inImage)
{
	CGImageRef img=[inImage CGImage];
	CGSize size=[inImage size];
	CGContextRef cgctx=createRGBABitmapContext(img);
	
	if (cgctx == NULL)
		return NULL;
	
	CGRect rect=CGRectMake(0, 0, size.width, size.height);
	CGContextDrawImage(cgctx, rect, img);
	unsigned char *data=CGBitmapContextGetData(cgctx);
	CGContextRelease(cgctx);
	return data;
}

-(UIImage*) createImage:(unsigned char*)imgdata width:(int)width height:(int)height
{
	int bitsPerComponent=8;
	int bitsPerPixel=32;
	CGBitmapInfo bitmapInfo=kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent=kCGRenderingIntentDefault;
	
	int bytesPerRow=4 * width;
	CGDataProviderRef provider=CGDataProviderCreateWithData(NULL, imgdata, bytesPerRow*height, NULL);
	CGColorSpaceRef colorSpaceRef=CGColorSpaceCreateDeviceRGB();
	CGImageRef imageRef=CGImageCreate(width, height,
                                      bitsPerComponent,
                                      bitsPerPixel,
                                      bytesPerRow,
                                      colorSpaceRef,
                                      bitmapInfo,
                                      provider,
                                      NULL, NO, renderingIntent);
	
	UIImage* img=[[UIImage alloc] initWithCGImage:imageRef];
	CFRelease(imageRef);
	
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	return img;
}

-(UIImage*) blurImage:(int)radius
{
	int theheight=(int) self.size.height;
	int thewidth=(int) self.size.width;
    unsigned int linewidth=thewidth * 4;
	
	// Get input and output bits
	unsigned char *inbits=requestImagePixelData(self);
	unsigned char *outbits=(unsigned char*)malloc(theheight * linewidth);
	
	// Find the size of the square with radius radius
	int squared=4 * radius * radius + 4 * radius + 1;
	
	// Iterate through each available pixel (leaving a radius-sized boundary)
	for (unsigned int y=radius; y < (theheight - radius); y++)
    {
		for (unsigned int x=radius; x < (thewidth - radius); x++)
		{
			unsigned int sumr=0;
			unsigned int sumg=0;
			unsigned int sumb=0;
			
			// Iterate through the mask, which is sum/size for blur
			for (int j=-1 * radius; j <= radius; j++)
            {
				for (int i=-1 * radius; i <= radius; i++)
				{
					sumr += (unsigned char) inbits[offR(x+i, y+j, linewidth)];
					sumg += (unsigned char) inbits[offG(x+i, y+j, linewidth)];
					sumb += (unsigned char) inbits[offB(x+i, y+j, linewidth)];
				}
            }
			
			// Assign the outbits
			outbits[offR(x, y, linewidth)]=(unsigned char) (sumr / squared);
			outbits[offG(x, y, linewidth)]=(unsigned char) (sumg / squared);
			outbits[offB(x, y, linewidth)]=(unsigned char) (sumb / squared);
			outbits[offA(x, y, linewidth)]=(unsigned char) inbits[offA(x, y, linewidth)];
		}
    }
    
    UIImage* my_Image=[self createImage:outbits width:thewidth height:theheight];
    //	free(outbits); // can't free it
	return [my_Image autorelease];
}

- (UIImage *) blurImage2:(int)radius
{
	int theheight = (int) self.size.height;
	int thewidth = (int) self.size.width;
	
	// Get input and output bits
	unsigned char *inbits = requestImagePixelData(self);
	unsigned char *outbits = (unsigned char *)malloc(theheight * thewidth * 4);
	
	// Find the size of the square with radius radius
	int squared = 4 * radius * radius + 4 * radius + 1;
	
	// Iterate through each available pixel (leaving a radius-sized boundary)
	for (int y = radius; y < (theheight - radius); y++)
		for (int x = radius; x < (thewidth - radius); x++)
		{
			unsigned int sumr = 0;
			unsigned int sumg = 0;
			unsigned int sumb = 0;
			
			// Iterate through the mask, which is sum/size for blur
			for (int j = -1 * radius; j <= radius; j++)
				for (int i = -1 * radius; i <= radius; i++)
				{
					sumr += (unsigned char) inbits[redOffset(x+i, y+j, thewidth)];
					sumg += (unsigned char) inbits[greenOffset(x+i, y+j, thewidth)];
					sumb += (unsigned char) inbits[blueOffset(x+i, y+j, thewidth)];
				}
			
			// Assign the outbits
			outbits[redOffset(x, y, thewidth)] = (unsigned char) (sumr / squared);
			outbits[greenOffset(x, y, thewidth)] = (unsigned char) (sumg / squared);
			outbits[blueOffset(x, y, thewidth)] = (unsigned char) (sumb / squared);
			outbits[alphaOffset(x, y, thewidth)] = (unsigned char) inbits[alphaOffset(x, y, thewidth)];
		}
	
	NSInteger dataLength = thewidth*theheight* 4;
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, outbits, dataLength, NULL);
	// prep the ingredients
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = 4 * theheight;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	// make the cgimage
	CGImageRef imageRef = CGImageCreate(thewidth, theheight,
										bitsPerComponent,
										bitsPerPixel,
										bytesPerRow,
										colorSpaceRef,
										bitmapInfo,
										provider,
										NULL, NO, renderingIntent);
	
	//	UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
	UIImage *my_Image = [[UIImage alloc] initWithCGImage:imageRef];
	
//	free(outbits);
//	CFRelease(imageRef);
//	CGColorSpaceRelease(colorSpaceRef);
//	CGDataProviderRelease(provider);
	return my_Image;
}

@end
