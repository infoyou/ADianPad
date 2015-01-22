#import "HudViewController.h"
#import "GDefine.h"
#import "ADAppDelegate.h"
#import "UIView_Extras.h"

#define KOffsetY 60

@implementation HudViewController
@synthesize indicatorView, textLabel, hudimage;

-(id) init
{
    if((self=[super init]))
    {
        self.wantsFullScreenLayout=YES;
    }
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.view.frame=CGRectMake(0, KOffsetY, KScreenWidth, KScreenHeight-KOffsetY);
    
    UIImage* img=IMG(backhud2);
    img=[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
    self.hudimage=[self.view buildImage2:img frame:CGRectMake(74, 381-KOffsetY, 173, 36)];
    hudimage.image=img;
    hudimage.hidden = YES;
    
//    self.indicatorView = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(98, 388-KOffsetY, 20.0, 20.0)] autorelease];
//    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//    indicatorView.backgroundColor = [UIColor clearColor];
//    [indicatorView startAnimating];
//    [self.view addSubview:indicatorView];
//    [indicatorView release];
//    indicatorView.hidden = YES;
    
    self.textLabel=[[[UILabel alloc] initWithFrame:CGRectMake(122, 383-KOffsetY, 96, 29)] autorelease];
    [self.view addSubview:textLabel];
    [textLabel release];
    textLabel.text=Landing_Processing;
    textLabel.textAlignment=NSTextAlignmentCenter;
    textLabel.textColor=KWhiteColor;
    [textLabel setBackgroundColor:KClearColor];
    textLabel.hidden = YES;
}

-(void) dealloc
{
	self.indicatorView = nil;
    self.hudimage=nil;
    self.textLabel=nil;
    [super dealloc];
}

-(void) killHUD
{
	[indicatorView stopAnimating];
}

-(void) presentHUD:(NSString*)text
{
//	textLabel.text = text;
    textLabel.hidden = YES;
	[appDelegate.window addSubview:self.view];
}

@end
