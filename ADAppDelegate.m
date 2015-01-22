//
//  ADAppDelegate.m
//  ADianTaste
//
//  Created by Keil on 14-2-25.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADAppDelegate.h"
#import "ADMainViewController.h"
#import "GDefine.h"
#import "LeftGView.h"
#import "ADBarVIew.h"
#import "GUtil.h"
@implementation ADAppDelegate
@synthesize session,uid,deviceToken,loginname,platform;
@synthesize navController;
@synthesize iosVersion;
- (void)dealloc
{
    [loginController release];
    [super dealloc];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    loginController=[[ADLoginViewController alloc] init];
    navController=[[UINavigationController alloc] initWithRootViewController:loginController];
    navController.navigationBarHidden=YES;
    self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void) push:(UIViewController*)con animat:(BOOL)animat
{
    [navController pushViewController:con animated:animat];
}

-(void) pop:(BOOL)animat
{
    [navController popViewControllerAnimated:animat];
}

-(void) push:(UIViewController*)con
{
    [self push:con animat:YES];
}

-(void) pop
{
    [self pop:YES];
}

-(void)creatLeftView
{
    LeftGView *leftview = nil;
    leftview = (LeftGView*)[self.navController.view viewWithTag:KLeftViewTag];
    if (leftview) {
        leftview.hidden = NO;
        [self upDataLeftViewQrcode];
    }else{
        leftview = [[LeftGView alloc]initWithFrame:CGRectMake(0, ios7H+KBarWidthF, KLeftWidthStoreViewW, KScreenWidth-ios7H-KBarWidthF)];
        leftview.tag =KLeftViewTag;
        [self.navController.view addSubview:leftview];
        [leftview release];
    }
}

-(void)removeLeftView
{
    LeftGView *left = (LeftGView*)[self.navController.view viewWithTag:KLeftViewTag];
    if (left) {
        left.hidden = YES;

    }


}
- (void)upDataLeftViewQrcode
{
    LeftGView *left = (LeftGView*)[self.navController.view viewWithTag:KLeftViewTag];
    if (left) {
        [left upQrcodeImg];
        [left animationQrcodeImg];
    }
}

- (void)UPDataLeftViewQrcodeBtn
{
    LeftGView *left = (LeftGView*)[self.navController.view viewWithTag:KLeftViewTag];
    if (left) {
        [left upQrcodeImgBtn];
    }

}
- (void)setBarAddLeftDelegate:(id)controller
{
    LeftGView *left = (LeftGView*)[self.navController.view viewWithTag:KLeftViewTag];
    if (left) {
        
    }
    ADBarVIew *bar = (ADBarVIew*)[self.navController.view viewWithTag:KBarViewTag];
    if (bar) {
        if (bar.delegate) {
            bar.delegate = nil;
        }
        bar.delegate = controller;
    }
}

- (void)creatBarView
{
    ADBarVIew *barview = nil;
    barview = (ADBarVIew*)[self.navController.view viewWithTag:KBarViewTag];
    if (barview) {
        barview.hidden = NO;
    }else{
        barview = [[ADBarVIew alloc] initWithFrame:CGRectMake(0, 20-ios7H, KScreenHeight, KBarWidthF+ios7H)];
        barview.tag =KBarViewTag;
        [self.navController.view addSubview:barview];
        [barview release];
    }
}

- (void)removeBarView
{
    ADBarVIew *bar = (ADBarVIew*)[self.navController.view viewWithTag:KBarViewTag];
    if (bar) {
        bar.hidden = YES;
    }
}

- (int)barIndex
{
    ADBarVIew *bar = (ADBarVIew*)[self.navController.view viewWithTag:KBarViewTag];
    if (bar) {
        return bar.flagIndex;
    }
    return 0;
}

- (void)resumeBarView
{
    ADBarVIew *bar = (ADBarVIew*)[self.navController.view viewWithTag:KBarViewTag];
    if (bar) {
        [bar resumeView];
    }
}

- (void)loginAfter
{
    
    ADMainViewController *mainController=[[[ADMainViewController alloc] init] autorelease];
    [self.navController popToRootViewControllerAnimated:NO];
    [self.navController pushViewController:mainController animated:YES];
    [self creatBarView];
    [self creatLeftView];
    [self setBarAddLeftDelegate:mainController];
}

- (void)loginOut
{
    [self removeBarView];
    [self removeLeftView];
    [GUtil removeInfo:KUserDicKey];
    [self.navController popToViewController:loginController animated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
