
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "GController.h"

#define kPWWebViewControllerActionSheetTag         5000
#define kPWWebViewControllerActionSheetMailIndex   1
#define kPWWebViewControllerActionSheetSafariIndex 0

@interface PWWebViewController : GController <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
	UIWebView *_webView;
	
	UIToolbar *_toolbar;
	UIBarButtonItem *_actionButton;
	UIBarButtonItem *_reloadButton;
	UIBarButtonItem *_loadingButton;
	UIBarButtonItem *_forwardButton;
	UIBarButtonItem *_backButton;
	UIBarButtonItem *_flexibleSpace;
	
	NSURLRequest *_request;
}

@property (nonatomic, readonly) UIWebView *webView;
@property (nonatomic, readonly) UIToolbar *toolbar;
@property (nonatomic, copy) NSString* navTitle;

-(id) initWithRequest:(NSURLRequest*)request;

-(void) showAvailableActions;
-(void) reload;
-(void) goBack;
-(void) goForward;

@end
