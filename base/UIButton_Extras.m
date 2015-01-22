
#import "UIButton_Extras.h"
#import "GDefine.h"

@implementation UIButton(Extras)

-(void) setTxt:(NSString*)txt
{
    [self setTitle:txt forState:UIControlStateNormal];
    [self setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
}

@end
