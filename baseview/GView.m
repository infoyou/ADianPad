
#import "GView.h"
#import "ImageNetManager.h"
#import "GDefine.h"
#import "UIView_Extras.h"

@implementation GView
@synthesize click;

- (id)initWithFrame:(CGRect)frame 
{
	if((self = [super initWithFrame:frame])) 
	{
        self.opaque=NO;
        self.backgroundColor=KClearColor;
	}
    return self;
}

//-(void) changeBgBack
//{
//    [self setCellFocus:NO];
//    [self setNeedsDisplay];
//}
//
//-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
//{
//    if(!click)
//        [self setCellFocus:YES];
//    
//    [super touchesBegan:touches withEvent:event];
//}
//
//-(void) touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
//{
//    [super touchesCancelled:touches withEvent:event];
//    
//    if(!click)
//        [self performSelector:@selector(changeBgBack) withObject:nil afterDelay:0.2];
//}
//
//-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
//{
//    [super touchesEnded:touches withEvent:event];
//    
//    if(!click)
//        [self performSelector:@selector(changeBgBack) withObject:nil afterDelay:0.2];
//    
//    if(btnaction!=nil && btntarget!=nil && [btntarget respondsToSelector:btnaction])
//    {
//        [btntarget performSelector:btnaction];
//    }   
//}
//
//-(void) setAction:(id)targ action:(SEL)sel
//{
//    btntarget=targ;
//    btnaction=sel;
//}
//
//-(void) addLine
//{
////    CGRect rect = self.frame;
////    UIImage *line = [[UIImage imageNamed:@"message_cell_line.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:1];
////    [self buildImage2:line frame:CGRectMake(0, rect.size.height-1, KScreenWidth, 1)];
//    [self buildBgView:KPTxtLightGray frame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
//}

@end
