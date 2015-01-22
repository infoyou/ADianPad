//
//  ADAppDelegate.h
//  ADianTaste
//
//  Created by Keil on 14-2-25.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADLoginViewController.h"

@interface ADAppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navController;
    float iosVersion;
    ADLoginViewController *loginController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSString* session;
@property (nonatomic, retain) NSString* uid;
@property (nonatomic, retain) NSString* deviceToken;
@property (nonatomic,retain) NSString *loginname;
@property (nonatomic, retain) NSString* platform;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic,assign)float iosVersion;
-(void) push:(UIViewController*)con animat:(BOOL)animat;
-(void) pop:(BOOL)animat;
-(void) push:(UIViewController*)con;
-(void) pop;

- (void)upDataLeftViewQrcode;
- (void)UPDataLeftViewQrcodeBtn;
-(void) loginAfter;
- (void)loginOut;
-(void)setBarAddLeftDelegate:(id)controller;
- (int)barIndex;
- (void)resumeBarView;
@end
