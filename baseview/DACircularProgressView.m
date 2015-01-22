//
//  DACircularProgressView.m
//  DACircularProgress
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import "DACircularProgressView.h"

#define DEGREES_2_RADIANS(x) (0.0174532925 * (x))

@implementation DACircularProgressView

//@synthesize trackTintColor = _trackTintColor;
//@synthesize progressTintColor =_progressTintColor;
@synthesize progress = _progress;

-(id) init
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];//背景设为透明
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    CGPoint centerPoint=CGPointMake(rect.size.height/2, rect.size.width/2);
    CGFloat radius=MIN(rect.size.height, rect.size.width)/2;
    CGFloat pathWidth=radius*0.3f;
    
    CGFloat radians=DEGREES_2_RADIANS((self.progress*355)-90);
    CGFloat xOffset=radius*(1+0.85*cosf(radians));
    CGFloat yOffset=radius*(1+0.85*sinf(radians));
    CGPoint endPoint=CGPointMake(xOffset, yOffset);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    // bg circle
    [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f] setFill];
//    [self.progressTintColor serFill];
    CGMutablePathRef trackPath=CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), DEGREES_2_RADIANS(-90), NO);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextFillPath(context);
    CGPathRelease(trackPath);
    
    // active circle
    radius *= 0.95;
    pathWidth=radius*0.3f;
    [[UIColor whiteColor] setFill];
//    [self.progressTintColor setFill];
    CGMutablePathRef progressPath=CGPathCreateMutable();
    CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), radians, NO);
    CGPathCloseSubpath(progressPath);
    CGContextAddPath(context, progressPath);
    CGContextFillPath(context);
    CGPathRelease(progressPath);
    
    // start circle
    CGContextAddEllipseInRect(context, CGRectMake(centerPoint.x-pathWidth/2+0.05*radius, 0.05*radius, pathWidth, pathWidth));
    CGContextFillPath(context);
    
    // end circle
    xOffset=radius*(1+0.85*cosf(radians));
    yOffset=radius*(1+0.85*sinf(radians));
    endPoint=CGPointMake(xOffset, yOffset);
    CGContextAddEllipseInRect(context, CGRectMake(endPoint.x-pathWidth/2+0.05*radius, endPoint.y-pathWidth/2+0.05*radius, pathWidth, pathWidth));
    CGContextFillPath(context);
    
    // draw blank center
    CGFloat innerRadius=radius*0.7;
	CGPoint newCenterPoint=CGPointMake(centerPoint.x-innerRadius, centerPoint.y-innerRadius);
    CGContextSetBlendMode(context, kCGBlendModeClear);
	CGContextAddEllipseInRect(context, CGRectMake(newCenterPoint.x, newCenterPoint.y, innerRadius*2, innerRadius*2));
	CGContextFillPath(context);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    // bg circle
    radius*=0.7;
    pathWidth=radius*0.3f;
    [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f] setFill];
//    [self.progressTintColor serFill];
    trackPath=CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), DEGREES_2_RADIANS(-90), NO);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextFillPath(context);
    CGPathRelease(trackPath);
    
    // draw blank center
    radius=MIN(rect.size.height, rect.size.width)/2;
    pathWidth=radius*0.3f;
    innerRadius=radius*0.62;
	newCenterPoint=CGPointMake(centerPoint.x-innerRadius, centerPoint.y-innerRadius);
    CGContextSetBlendMode(context, kCGBlendModeClear);
	CGContextAddEllipseInRect(context, CGRectMake(newCenterPoint.x, newCenterPoint.y, innerRadius*2, innerRadius*2));
	CGContextFillPath(context);
}

#pragma mark - Property Methods

//- (UIColor *)trackTintColor
//{
//    if (!_trackTintColor)
//    {
//        _trackTintColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3f];
//    }
//    return _trackTintColor;
//}
//
//- (UIColor *)progressTintColor
//{
//    if (!_progressTintColor)
//    {
//        _progressTintColor = [UIColor whiteColor];
//    }
//    return _progressTintColor;
//}

- (void)setProgress:(float)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

@end
