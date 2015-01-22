
#import "UIViewController_Extras.h"
#import "GDefine.h"

@implementation UIViewController(Extras)

-(void) pop:(UIViewController*)controller animated:(BOOL)animat
{
    if(IosVersion>=5.0)
        [self presentViewController:controller animated:YES completion:nil];
    else
        [self presentModalViewController:controller animated:YES];
}

-(void) dismiss:(BOOL)animat
{
    if(IosVersion>=5.0)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self dismissModalViewControllerAnimated:YES];
}

@end