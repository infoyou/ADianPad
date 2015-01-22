//
//  ADLoginViewController.m
//  ADianTaste
//
//  Created by 陈 超 on 14-2-27.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADLoginViewController.h"
#import "ADAppDelegate.h"
#import "GJsonCenter.h"
#import "GDefine.h"
#import "UIView_Extras.h"
#import "ADSessionInfo.h"
#import "GUtil.h"

#define KLoginBigViewTag 2550
#define KNameTextTag 1001
#define KPasstexttag 1002

@interface ADLoginViewController ()

@end

@implementation ADLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)Aro
{
    NSLog(@"222");
}

- (void)upLoginViewAnimation
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Aro)];
    
    UIView *view = [self.view viewWithTag:KLoginBigViewTag];
    
    [view addGestureRecognizer:tapGesture];
    if (view) {
        
        [UIView animateWithDuration:0.2 animations:^{
            view.frame = CGRectMake((KScreenHeight-753)/2.0, (KScreenWidth-805/2.0)/2.0+220.0-190.0, 753,  179);
            view.backgroundColor = [UIColor whiteColor];
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (void)downLoginViewAnimation
{
   UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Aro
                                                                                                            )];
    UIView *view = [self.view viewWithTag:KLoginBigViewTag];
    [view addGestureRecognizer:tapGesture];
    if (view) {
        [UIView animateWithDuration:0.2 animations:^{
            view.frame = CGRectMake((KScreenHeight-753)/2.0, (KScreenWidth-805/2.0)/2.0+220.0, 753,  179);
            view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {


        }];
    }
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    UITapGestureRecognizer * tapBigGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
//    [self.view addGestureRecognizer:tapBigGesture];
//    [tapBigGesture release];
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenHeight, KScreenWidth)];
    backImage.image = [UIImage imageNamed:@"loginBg.png"];
    [self.view addSubview:backImage];
    [backImage release];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((KScreenHeight-753)/2.0, (KScreenWidth-805/2.0)/2.0+220.0, 753,  179)];
    view.backgroundColor = [UIColor clearColor];
    view.tag = KLoginBigViewTag;
    [self.view addSubview:view];
    [view release];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, (179-64)/2.0, 220, 32.0)];
    nameLabel.text = @"ID            用户名：";
    nameLabel.font = [UIFont systemFontOfSize:26.0];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    [view addSubview:nameLabel];
    [nameLabel release];
    
    UIImageView *nameImage = [[UIImageView alloc]initWithFrame:CGRectMake(280, (179-64)/2.0-10.0, 753-80.0-280.0, 58.0)];
    nameImage.image = IMG(iptLogin);
    [view addSubview:nameImage];
    [nameImage release];
    /// 用户登录ID文本框控件
    UITextField *inputNameText = [[UITextField alloc] initWithFrame:CGRectMake(280.0+55.0,(179-64)/2.0-20.0, 753-80.0-280.0-100.0, 32)];
    inputNameText.delegate = self;
    inputNameText.textAlignment = NSTextAlignmentCenter;
    inputNameText.tag = KNameTextTag;
    inputNameText.textColor = [UIColor darkGrayColor];
    inputNameText.backgroundColor = [UIColor clearColor];
    inputNameText.font= [UIFont systemFontOfSize:24.0];
    inputNameText.placeholder = LTXT(TKN_LOGIN_NAME_TISHI);
    [view addSubview:inputNameText];
    [inputNameText release];
    
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 179-52.0, 220, 32.0)];
    passwordLabel.text = @"Password  密 码：";
    passwordLabel.font = [UIFont systemFontOfSize:26.0];
    passwordLabel.textAlignment = NSTextAlignmentLeft;
    passwordLabel.backgroundColor = [UIColor clearColor];
    passwordLabel.textColor = [UIColor blackColor];
    [view addSubview:passwordLabel];
    [passwordLabel release];
    
    UIImageView *pwImage = [[UIImageView alloc]initWithFrame:CGRectMake(280, 179-62.0, 753-80.0-280.0, 58.0)];
    pwImage.image = IMG(iptLogin);
    [view addSubview:pwImage];
    [pwImage release];
    
    UITextField *inputPasswordText = [[UITextField alloc] initWithFrame:CGRectMake(280.0+55.0, 179-62.0-10.0, 753-80.0-280.0-100.0, 32)];
    inputPasswordText.delegate = self;
    inputPasswordText.textAlignment = NSTextAlignmentCenter;
    inputPasswordText.tag = KPasstexttag;
    inputPasswordText.secureTextEntry = YES;
    inputPasswordText.textColor = [UIColor darkGrayColor];
    inputPasswordText.backgroundColor = [UIColor clearColor];
    inputPasswordText.font= [UIFont systemFontOfSize:24.0];
    inputPasswordText.placeholder = LTXT(TKN_LOGIN_PASSWORD_TISHI);
    [view addSubview:inputPasswordText];
    [inputPasswordText release];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setImage:[UIImage imageNamed:@"btnLogin.png"] forState:UIControlStateNormal];
    loginBtn.frame = CGRectMake((KScreenHeight-228.0)/2.0, (KScreenWidth-805/2.0)/2.0+220.0+40.0+179.0, 228.0, 66.0);
    [loginBtn addTarget:self action:@selector(loginClike) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
//    UIImageView *inputBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 969/2.0, 805/2.0)];
//    inputBackImage.image = [UIImage imageNamed:@"loginTxtBg.png"];
//    [view addSubview:inputBackImage];
//    [inputBackImage release];
//    
//    UIImageView *loginTitle = [[UIImageView alloc]initWithFrame:CGRectMake((969/2.0-805/2.0)/2.0, 0-2.0, 805/2.0, 167.0/2.0)];
//    loginTitle.image = [UIImage imageNamed:@"loginTit.png"];
//    [view addSubview:loginTitle];
//    [loginTitle release];
//    
//    UIImageView *input1 = [[UIImageView alloc]initWithFrame:CGRectMake((969/2.0-376)/2.0, 0+140.0, 396-20, 58)];
//    input1.image = [[UIImage imageNamed:@"loginIpt.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
//    [view addSubview:input1];
//    [input1 release];
//    
//    UITextField *inputNameText = [[UITextField alloc] initWithFrame:CGRectMake((969/2.0-376)/2.0+49.0, 0+140.0+(58.0-32)/2.0, 396-20-55.0, 32)];
//    inputNameText.delegate = self;
//    inputNameText.tag = KNameTextTag;
//    inputNameText.textColor = [UIColor darkGrayColor];
//    inputNameText.backgroundColor = [UIColor clearColor];
//    inputNameText.font= [UIFont systemFontOfSize:28.0];
//    inputNameText.placeholder = LTXT(TKN_LOGIN_NAME_TISHI);
//    [view addSubview:inputNameText];
//    [inputNameText release];
//    
//    UIImageView *nameIcon = [[UIImageView alloc]initWithFrame:CGRectMake((969/2.0-376)/2.0+10.0, 0+140.0+(58.0-32.0)/2.0, 29.0, 32.0)];
//    nameIcon.image = [UIImage imageNamed:@"loginNameIcon.png"];
//    [view addSubview:nameIcon];
//    [nameIcon release];
//    
//    UIImageView *input2 = [[UIImageView alloc]initWithFrame:CGRectMake((969/2.0-376)/2.0, 0+140.0+58+15.0, 396-20, 58)];
//    input2.image = [[UIImage imageNamed:@"loginIpt.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
//    [view addSubview:input2];
//    [input2 release];
//    
//    UITextField *inputPasswordText = [[UITextField alloc] initWithFrame:CGRectMake((969/2.0-376)/2.0+49.0, 0+140.0+58+15.0+(58.0-32)/2.0, 396-20-55.0, 32)];
//    inputPasswordText.delegate = self;
//    inputPasswordText.tag = KPasstexttag;
//    inputPasswordText.secureTextEntry = YES;
//    inputPasswordText.textColor = [UIColor darkGrayColor];
//    inputPasswordText.backgroundColor = [UIColor clearColor];
//    inputPasswordText.font= [UIFont systemFontOfSize:28.0];
//    inputPasswordText.placeholder = LTXT(TKN_LOGIN_PASSWORD_TISHI);
//    [view addSubview:inputPasswordText];
//    [inputPasswordText release];
//    
//    
//    
//    UIImageView *passwordIcon = [[UIImageView alloc]initWithFrame:CGRectMake((969/2.0-376)/2.0+10.0, 0+140.0+58+15.0+(58.0-33.0)/2.0, 30.0, 33.0)];
//    passwordIcon.image = [UIImage imageNamed:@"loginPasswordIcon.png"];
//    [view addSubview:passwordIcon];
//    [passwordIcon release];
//    
//    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [loginBtn setImage:[UIImage imageNamed:@"loginBtn.png"] forState:UIControlStateNormal];
//    loginBtn.frame = CGRectMake((969/2.0-733/2.0)/2.0, 0+140.0+58*2+15.0*2, 733/2.0, 107/2.0);
//    [loginBtn addTarget:self action:@selector(loginClike) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:loginBtn];
    
//    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
//    [view addGestureRecognizer:tapGesture];
//    [tapGesture release];
    

    
}

//-(void)dismissKeyBoard
//{
//    UITextField *nameText = (UITextField *)[self.view viewWithTag:KNameTextTag];
//    UITextField *passText = (UITextField *)[self.view viewWithTag:KPasstexttag];
//    [nameText resignFirstResponder];
//    [passText resignFirstResponder];
//    [self downLoginViewAnimation];
//
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    UITextField *nameText = (UITextField *)[self.view viewWithTag:KNameTextTag];
    UITextField *passText = (UITextField *)[self.view viewWithTag:KPasstexttag];
    if (nameText||passText) {
        nameText.text = @"";
        passText.text = @"";
    }
    if (ValidDict([GUtil getInfo:KUserDicKey])) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"rsp",[GUtil getInfo:KUserDicKey],@"data",nil];
        [self getNetData:dic withItem:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)loginClike
{
    
    UITextField *nameText = (UITextField *)[self.view viewWithTag:KNameTextTag];
    UITextField *passText = (UITextField *)[self.view viewWithTag:KPasstexttag];
    if (nameText.text==nil||[nameText.text isEqualToString:@""]) {
        Alert(LTXT(TKN_NAME_NULL));
        return;
    }
    if (passText.text==nil||[passText.text isEqualToString:@""]) {
        Alert(LTXT(TKN_PASS_NULL));
        return;
    }
    
    [GJsonCenter User_Login_Phone:nameText.text password:passText.text jsonDelegate:self];

    
    [self paoLoading:@"请稍后"];

    [nameText resignFirstResponder];
    [passText resignFirstResponder];



}
#pragma base delegate
-(void) jsonRequestFailed:(JsonRequestItem*)item
{
    [super jsonRequestFailed:item];
}
-(void) getNetData:(NSDictionary *)dict withItem:(JsonRequestItem *)item
{
    NSLog(@"dict=======%@",dict);
    [self paoCancelLoading];
    if ([[dict objectForKey:@"rsp"] intValue]==1) {
        NSDictionary *dic = [dict objectForKey:@"data"];
        if (ValidDict(dic)) {
            if (StrValid([dic objectForKey:@"corporation_member_id"])) {
                [ADSessionInfo sharedSessionInfo].corporation_member_id = [dic objectForKey:@"corporation_member_id"];
            }
            if (StrValid([dic objectForKey:@"corporation_id"])) {
                [ADSessionInfo sharedSessionInfo].corporation_id = [dic objectForKey:@"corporation_id"];
            }
            if (StrValid([dic objectForKey:@"store_id"])) {
                [ADSessionInfo sharedSessionInfo].store_id = [dic objectForKey:@"store_id"];
            }
            if (StrValid([dic objectForKey:@"nick_name"])) {
                [ADSessionInfo sharedSessionInfo].nick_name = [dic objectForKey:@"nick_name"];
            }
            if (StrValid([dic objectForKey:@"store_name"])) {
                [ADSessionInfo sharedSessionInfo].store_name = [dic objectForKey:@"store_name"];
            }
            if (StrValid([dic objectForKey:@"store_address"])) {
                [ADSessionInfo sharedSessionInfo].store_address = [dic objectForKey:@"store_address"];
            }
            if (StrValid([dic objectForKey:@"telephone"])) {
                [ADSessionInfo sharedSessionInfo].store_telephone = [dic objectForKey:@"telephone"];
            }
            if (StrValid([dic objectForKey:@"mobilephone"])) {
                [ADSessionInfo sharedSessionInfo].store_mobilephone = [dic objectForKey:@"mobilephone"];
            }
            if ([[dic objectForKey:@"qrcode_info"] isKindOfClass:[NSDictionary class]]) {
                if (StrValid([[dic objectForKey:@"qrcode_info"] objectForKey:@"qrcode_url"])) {
                    [ADSessionInfo sharedSessionInfo].qrcode_url = [[dic objectForKey:@"qrcode_info"] objectForKey:@"qrcode_url"];
                }
                if (StrValid([[dic objectForKey:@"qrcode_info"] objectForKey:@"scene_id"])) {
                    [ADSessionInfo sharedSessionInfo].scene_id = [[dic objectForKey:@"qrcode_info"] objectForKey:@"scene_id"];
                }
                //if (StrValid([[dic objectForKey:@"qrcode_info"] objectForKey:@"create_time"])) {
                //            NSLog(@"class==%@",NSStringFromClass([[[dic objectForKey:@"qrcode_info"] objectForKey:@"create_time"] class]));
                [ADSessionInfo sharedSessionInfo].creat_time = [[dic objectForKey:@"qrcode_info"] objectForKey:@"create_time"];
                //}
                if (StrValid([[dic objectForKey:@"qrcode_info"] objectForKey:@"type"])) {
                    [ADSessionInfo sharedSessionInfo].qrcode_type = [[dic objectForKey:@"qrcode_info"] objectForKey:@"type"];
                }
            }

            [GUtil setInfo:dic withKey:KUserDicKey];
            [appDelegate loginAfter];
        }

        
        
    }else if ([[dict objectForKey:@"rsp"] intValue]==0){
    
        Alert(@"登录错误");
     
    }
    


}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)keyboardWillChangeFrame:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];//更改后的键盘
    
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.origin.x;
    if (height> 416) {
        [self downLoginViewAnimation];
    }
    
    
	
}
/// 键盘出现 文本框上移
#pragma textFiled delegate
static bool isBegin = false;
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == KPasstexttag||textField.tag == KNameTextTag) {
        [self upLoginViewAnimation];
        

    }
    isBegin = true;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    UITextField *nameText = (UITextField *)[self.view viewWithTag:KNameTextTag];
    UITextField *passText = (UITextField *)[self.view viewWithTag:KPasstexttag];
    if (textField.tag == KNameTextTag) {
        [passText becomeFirstResponder];
        [self upLoginViewAnimation];

    }else{
        [textField resignFirstResponder];
        [self downLoginViewAnimation];
    
    }


    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
