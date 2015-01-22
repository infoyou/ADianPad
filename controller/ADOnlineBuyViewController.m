//
//  ADOnlineBuyViewController.m
//  ADianTaste
//
//  Created by 陈 超 on 14-5-26.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADOnlineBuyViewController.h"
#import "ADMainViewController.h"
#import "GDefine.h"
#import "ADSessionInfo.h"
#import "GUtil.h"
#import "UIView_Extras.h"
#import "ADRecentPeopleViewController.h"
#import "ADPurchaseViewController.h"
#import "ADCustomerServiceViewController.h"
#import "LeftGView.h"
#import "JSONKit.h"

@interface ADOnlineBuyViewController ()

@end

@implementation ADOnlineBuyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //KLeftWidthStoreViewW
    UIWebView *webLoadView = [[UIWebView alloc]initWithFrame:CGRectMake(0, KBarWidthF, KScreenHeight, KScreenWidth -KBarWidthF)];
    webLoadView.delegate = self;
    
    NSString *member_id =nil;
    if ([ADSessionInfo sharedSessionInfo].member_id_string ==nil) {
        member_id = @"";
    } else {
        member_id = [ADSessionInfo sharedSessionInfo].member_id_string;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/webview/prolist.php?cid=%@&user_id=%@&open_id=%@", PRODUCT_URL, [ADSessionInfo sharedSessionInfo].corporation_id, member_id, @""];
    NSLog(@"%@",urlString);
    //    NSURL *url=[NSURL URLWithString:@"www.baidu.com"];
    //    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [webLoadView loadRequest:request];
    webLoadView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:webLoadView];
    [webLoadView release];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    LeftGView *left = (LeftGView*)[appDelegate.navController.view viewWithTag:KLeftViewTag];
    left.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    LeftGView *left = (LeftGView*)[appDelegate.navController.view viewWithTag:KLeftViewTag];
    left.hidden = NO;
}
#pragma mark ADBarAddLeftEventDelegate
- (void)barViewRefreshEvent
{
    NSArray *conTrolArray = [self.navigationController viewControllers];
    for (UIViewController *con in conTrolArray) {
        if ([con isKindOfClass:[ADMainViewController class]]) {
            [appDelegate setBarAddLeftDelegate:con];
            ADMainViewController *tempCon = (ADMainViewController *)con;
            [tempCon backRefreshQrcode];
            [self.navigationController popToViewController:con animated:YES];
        }
    }
}

- (void)barViewBackEvent
{
    NSArray *conTrolArray = [self.navigationController viewControllers];
    for (UIViewController *con in conTrolArray) {
        if ([con isKindOfClass:[ADMainViewController class]]) {
            [appDelegate setBarAddLeftDelegate:con];
            [self.navigationController popToViewController:con animated:YES];
        }
    }
    //    if ([conTrolArray count]>=2) {
    //        UIViewController *con = [conTrolArray objectAtIndex:[conTrolArray count]-2];
    //        if (con) {
    //            [appDelegate setBarAddLeftDelegate:con];
    //        }
    //    }
    //    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeClikeEvent:(int)indexTag
{
    
    switch (indexTag) {
        case 0:
        {
        }
            break;
            
        case 1:
        {
            ADCustomerServiceViewController *con = [[ADCustomerServiceViewController alloc]init];
            [appDelegate setBarAddLeftDelegate:con];
            [appDelegate.navController pushViewController:con animated:NO];
            [con release];
        }
            break;

        case 2:
        {
            ADRecentPeopleViewController *con = [[ADRecentPeopleViewController alloc]init];
            [appDelegate setBarAddLeftDelegate:con];
            [appDelegate.navController pushViewController:con animated:NO];
            [con release];
        }
            break;
            
        case 3:
        {
            //先这样
            if ([[[appDelegate.navController viewControllers] lastObject] isKindOfClass:[self class]]) {
                [appDelegate loginOut];
            }
        }
            break;
        default:
            break;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"adv web request url --- %@", [[[request URL] absoluteURL] absoluteString]);
    if ([request.URL.scheme isEqualToString:@"bianxiang"]) {
        NSString *url = [[[request URL] absoluteURL] absoluteString];
        NSRange range_sku_id = [url rangeOfString:@"sku_id"];
        NSRange range_skq_qty = [url rangeOfString:@"skq_qty"];
        NSRange range_skq_size = [url rangeOfString:@"size"];
        NSString *cart_id_string = @"";
        NSString *sku_id_string = @"";
        NSString *skq_qty_string = @"";
        NSString *size_string = @"";
        NSString *product_name_string = @"";
        NSString *thumbnail_url_string = @"";
        NSString *price_string = @"";
        NSString *specification_value_string = @"";
        NSString *dataGBK  = @"";
        
        if (range_sku_id.location != NSNotFound && range_skq_qty.location != NSNotFound&& range_skq_size.location != NSNotFound) {
            
            NSRange range1 = [url rangeOfString:@"?"];
            NSString *productdata = [url substringFromIndex:range1.location+1];
            NSArray *array = [productdata componentsSeparatedByString:@"&"];
            
            for (int i = 0; i< [array count]; i++) {
                
                NSString *dataSingle = [array objectAtIndex:i];
                NSRange range1 = [dataSingle rangeOfString:@"cart_id"];
                NSRange range2 = [dataSingle rangeOfString:@"sku_id"];
                NSRange range3 = [dataSingle rangeOfString:@"skq_qty"];
                NSRange range4 = [dataSingle rangeOfString:@"size"];
                NSRange range5 = [dataSingle rangeOfString:@"product_name"];
                NSRange range6 = [dataSingle rangeOfString:@"thumbnail_url"];
                NSRange range7 = [dataSingle rangeOfString:@"price"];
                NSRange range8 = [dataSingle rangeOfString:@"specification_value"];
                
                if (range1.location != NSNotFound) {
                    cart_id_string = [dataSingle substringFromIndex:range1.location+range1.length+1];
                }else if (range2.location != NSNotFound) {
                    sku_id_string = [dataSingle substringFromIndex:range2.location+range2.length+1];
                }else if(range3.location != NSNotFound){
                    skq_qty_string = [dataSingle substringFromIndex:range3.location+range3.length+1];
                }else if(range4.location != NSNotFound){
                    size_string = [[dataSingle substringFromIndex:range4.location+range4.length+1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }else if(range5.location != NSNotFound){
                    product_name_string = [dataSingle substringFromIndex:range5.location+range5.length+1];
                    dataGBK = [product_name_string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }else if(range6.location != NSNotFound){
                    thumbnail_url_string = [dataSingle substringFromIndex:range6.location+range6.length+1];
                }else if(range7.location != NSNotFound){
                    price_string = [dataSingle substringFromIndex:range7.location+range7.length+1];
                }else if(range8.location != NSNotFound){
                    specification_value_string = [[dataSingle substringFromIndex:range8.location+range8.length+1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding
                                                  ];
                }
            }
            
            if ([sku_id_string isEqualToString:@""]!=YES && [skq_qty_string isEqualToString:@""]!=YES && [size_string isEqualToString:@""]!=YES) {
                
                NSMutableDictionary *dicTemp = [NSMutableDictionary dictionary];
                [dicTemp setObject:cart_id_string forKey:@"cart_id"];
                [dicTemp setObject:size_string forKey:@"size"];
                [dicTemp setObject:skq_qty_string forKey:@"sku_qty"];
                NSMutableDictionary *detailTemp = [NSMutableDictionary dictionary];
                [detailTemp setObject:price_string forKey:@"price"];
                [detailTemp setObject:dataGBK forKey:@"product_name"];
                [detailTemp setObject:thumbnail_url_string forKey:@"thumbnail_url"];
                [detailTemp setObject:specification_value_string forKey:@"specification_value"];
                [detailTemp setObject:sku_id_string forKey:@"sku_id"];
                [dicTemp setObject:detailTemp forKey:@"product_detail"];
                
                ADPurchaseViewController *con = [[ADPurchaseViewController alloc] init];
                [appDelegate setBarAddLeftDelegate:con];
                con.isOrderType = NO;
                con.dataArray = [NSMutableArray arrayWithArray:[NSArray arrayWithObject:dicTemp]];
                [self.navigationController pushViewController:con animated:YES];
                [con release];
            }
        }
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{}
- (void)webViewDidFinishLoad:(UIWebView *)webView{}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
