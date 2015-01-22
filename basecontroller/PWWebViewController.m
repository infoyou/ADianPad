
#import "PWWebViewController.h"
#import "GDefine.h"
#import "GUtil.h"
#import "UIView_Extras.h"
#import "ADAppDelegate.h"

@interface PWWebViewController (Private)
-(void) checkNavigationStatus;
@end

@implementation PWWebViewController
@synthesize navTitle;

- (id)initWithRequest:(NSURLRequest*)request
{
    if(self = [super init])
    {
        _request = [request retain];
		self.hidesBottomBarWhenPushed = YES;
		
		// Create toolbar (to make sure that we can access it at any time)
		_toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    }
    return self;
}

-(void) viewDidLoad
{
//	[super viewDidLoad];
	[self buildNavBarWithTitle:navTitle];
	[self buildNavLeftBtn:IMG(back) target:self action:@selector(back:)];
}

//-(void) back:(id)sender
//{
//    [appDelegate pop:NO];
//}

-(void) loadView
{
	[super loadView];
	CGRect frame = self.view.bounds;
	
	// Load web view
	_webView = [[UIWebView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+41, frame.size.width, frame.size.height - 44.0 - 41)];
	_webView.delegate = self;
	_webView.scalesPageToFit = YES;
	_webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin);
	[self.view addSubview:_webView];
	
	[_webView loadRequest:_request];
	_actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showAvailableActions)];
	_reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)];

	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityView startAnimating];
	_loadingButton = [[UIBarButtonItem alloc] initWithCustomView:activityView];
	[activityView release];
	
	_forwardButton = [[UIBarButtonItem alloc] initWithImage:IMG(forword2) style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
	_forwardButton.enabled = NO;
	
	_backButton = [[UIBarButtonItem alloc] initWithImage:IMG(back2) style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	_backButton.enabled = NO;
	
	_toolbar.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height - 44.0, frame.size.width, 44.0);
	_toolbar.barStyle = UIBarStyleBlackTranslucent;
	_toolbar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight);
	[self.view addSubview:_toolbar];
	
	_flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
	_toolbar.items = [NSArray arrayWithObjects:_actionButton, _flexibleSpace, _backButton, _flexibleSpace, _forwardButton, _flexibleSpace, _reloadButton, nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void) viewDidUnload
{
	[_request release];
	_request = [_webView.request retain];
	
	[_webView release];
	_webView = nil;
	
	[_actionButton release];
	_actionButton = nil;
	
	[_reloadButton release];
	_reloadButton = nil;
	
	[_loadingButton release];
	_loadingButton = nil;
	
	[_forwardButton release];
	_forwardButton = nil;
	
	[_backButton release];
	_backButton = nil;
	
	[_flexibleSpace release];
	_flexibleSpace = nil;
}

-(void) dealloc
{
	[_webView release];
	[_request release];
	
	[_toolbar release];
	[_actionButton release];
	[_reloadButton release];
	[_loadingButton release];
	[_forwardButton release];
	[_backButton release];
	[_flexibleSpace release];
    
    [navTitle release];
	
    [super dealloc];
}

#pragma mark Accessors
- (UIWebView*)webView
{
	return _webView;
}

- (UIToolbar*)toolbar
{
	return _toolbar;
}

#pragma mark Button actions
-(void) showAvailableActions
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[self.webView.request.URL absoluteString] delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	
	[actionSheet addButtonWithTitle:LTXT(PP_OpenSafari)];
	[actionSheet addButtonWithTitle:LTXT(PP_CANCEL)];
	actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
	
	actionSheet.tag = kPWWebViewControllerActionSheetTag;
	[actionSheet showFromToolbar:_toolbar];
	[actionSheet release];
}

-(void) reload
{
	[self.webView reload];
}

-(void) goBack
{
	if(self.webView.canGoBack == YES)
    {
		[self.webView goBack];
		
		[self checkNavigationStatus];
	}
}

-(void) goForward
{
	if(self.webView.canGoForward == YES)
    {
		[self.webView goForward];
		
		[self checkNavigationStatus];
	}
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* url=[[request URL] absoluteString];
	NSLog(@"adv web request url --- %@", url);
    if([url hasPrefix:@"itms"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return NO;
    }
	return YES;
}

-(void) webViewDidStartLoad:(UIWebView*)webView
{
	_toolbar.items = [NSArray arrayWithObjects:_actionButton, _flexibleSpace, _backButton, _flexibleSpace, _forwardButton, _flexibleSpace, _loadingButton, nil];
	self.title = NSLocalizedString(@"PP_Processing", nil);
}

-(void) webViewDidFinishLoad:(UIWebView*)webView
{
	_toolbar.items = [NSArray arrayWithObjects:_actionButton, _flexibleSpace, _backButton, _flexibleSpace, _forwardButton, _flexibleSpace, _reloadButton, nil];
	NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	self.title = title;
	
	[self checkNavigationStatus];
}

-(void) webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
	_toolbar.items = [NSArray arrayWithObjects:_actionButton, _flexibleSpace, _backButton, _flexibleSpace, _forwardButton, _flexibleSpace, _reloadButton, nil];
	[self checkNavigationStatus];
	self.title = LTXT(PP_FailToOpenWebPage);
	
	Alert(LTXT(PP_ConnectError));
}

#pragma mark UIActionSheetDelegate
-(void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(actionSheet.tag == kPWWebViewControllerActionSheetTag && buttonIndex != actionSheet.cancelButtonIndex)
    {
		if(buttonIndex == kPWWebViewControllerActionSheetSafariIndex)
        {
			if([[UIApplication sharedApplication] canOpenURL:self.webView.request.URL] == YES)
            {
				BOOL ret = [[UIApplication sharedApplication] openURL:self.webView.request.URL];
				if(ret == YES)
                {
					NSLog(@"fail to open in safari");
				}
			}
            else
            {
				Alert(LTXT(PP_InvalidLink));
			}
		}
        else if(buttonIndex == kPWWebViewControllerActionSheetMailIndex)
        {
			MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
			[controller setMessageBody:[self.webView.request.URL absoluteString] isHTML:NO];
			controller.mailComposeDelegate = self;
			[self pop:controller animated:YES];
			[controller release];
		}
	}
}

#pragma mark MFMailComposeViewControllerDelegate
-(void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	if(result == MFMailComposeResultFailed && error != nil)
    {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LTXT(PP_MailSendFail) message:[error localizedDescription] delegate:nil cancelButtonTitle:LTXT(PP_OK) otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	
	[controller dismiss:YES];
}

#pragma mark Private methods
-(void) checkNavigationStatus
{
	_backButton.enabled = self.webView.canGoBack;
	_forwardButton.enabled = self.webView.canGoForward;
}

@end
