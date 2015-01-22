#import <UIKit/UIKit.h>


@interface HudViewController : UIViewController
{
    UIActivityIndicatorView* indicatorView;
    UILabel* textLabel;
    UIImageView* hudimage;
}

@property (nonatomic, retain) UIActivityIndicatorView* indicatorView;
@property (nonatomic, retain) UILabel* textLabel;
@property (nonatomic, retain) UIImageView* hudimage;

-(void) presentHUD:(NSString*)text;
-(void) killHUD;

@end
