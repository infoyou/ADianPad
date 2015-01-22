
#import <UIKit/UIKit.h>

@interface GView : UIView
{
    id  btntarget;
    SEL btnaction;
    BOOL click;
}

@property (nonatomic,assign) BOOL click;

//-(void) setAction:(id)targ action:(SEL)sel;
//
//-(void) addLine;

@end
