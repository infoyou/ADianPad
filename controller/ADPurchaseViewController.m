//
//  ADPurchaseViewController.m
//  ADianTaste
//
//  Created by 陈 超 on 14-3-13.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADPurchaseViewController.h"
#import "GDefine.h"
#import "ADProductCell.h"
#import "ADRecentPeopleViewController.h"
#import "ADOrderCell.h"
#import "GJsonCenter.h"
#import "UIView_Extras.h"
#import "ADSessionInfo.h"
#import "GUtil.h"
#import "ADMainViewController.h"
#import "ADCustomerServiceViewController.h"
#import "ADOnlineBuyViewController.h"

#define KSongHuoBtnTag 2332
#define KZhiJieBtnTag 2323
#define KZongJiaLabel 233
#define KInputTag 78
#define KNameINTag 663
#define KAddressTag 767
#define KPhoneTag 565
@interface ADPurchaseViewController ()

@property (nonatomic, copy) NSString *qrCodeUrl;
@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) NSString *cart_id;
@property (nonatomic, copy) NSString *sku_id;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *sku_qty;

@property (nonatomic, retain) UIView *bgViewLeft;
@property (nonatomic, retain) UIView *bgViewTop;

@end

@implementation ADPurchaseViewController
{
    BOOL payResult;
}

@synthesize dataArray;
@synthesize isOrderType;
@synthesize qrCodeUrl;
@synthesize orderId;

@synthesize cart_id;
@synthesize sku_id;
@synthesize size;
@synthesize sku_qty;

@synthesize bgViewLeft;
@synthesize bgViewTop;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter]
         
         addObserver:self
         
         selector:@selector(keyboardWillHide:)
         
         name:UIKeyboardWillHideNotification
         
         object:nil
         
         ];
    }
    return self;
}
- (void)keyboardWillHide:(id)sender
{
    
    [self downLoginViewAnimation];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)keyboardWillChangeFrame:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];//切换语言时键盘高度的变化
    
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.width;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    if (height>352) {
        UIView *view = (UIView *)[self.view viewWithTag:KInputTag];
        [UIView animateWithDuration:animationDuration animations:^{
            view.frame = CGRectMake(KLeftWidthStoreViewW, KBarWidthF+ios7H+60.0+3*KProductCellH+55-250-50, KScreenHeight-KLeftWidthStoreViewW, 180);
        }];
        
    }else{
        UIView *view = (UIView *)[self.view viewWithTag:KInputTag];
        [UIView animateWithDuration:animationDuration animations:^{
            view.frame = CGRectMake(KLeftWidthStoreViewW, KBarWidthF+ios7H+60.0+3*KProductCellH+55-250, KScreenHeight-KLeftWidthStoreViewW, 180);
        }];
        
    }
    
    
    
}
- (void)dealloc
{
    self.qrCodeUrl = nil;
    self.orderId = nil;
    
    self.cart_id = nil;
    self.sku_id = nil;
    self.size = nil;
    self.sku_qty = nil;
    
    [dataArray release];
    tablePurchase.tableDelegate = nil;
    [tablePurchase release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super dealloc];
}

- (void)freshTableView
{
    if ([tablePurchase.dataArray count]>0) {
        [tablePurchase.dataArray removeAllObjects];
    }
    float totalFloat = 0;
    
    for (NSDictionary *dic in dataArray) {
        if (isOrderType==YES) {
            ADOrderCell *cell = [[ADOrderCell alloc] initWithDict:dic];
            cell.isNeedHead = YES;
            cell.noNeedBtn = YES;
            [tablePurchase appendCell:cell];
            [cell release];
            
            NSString *productPrice = [dic objectForKey:@"sku_product_price"];
            totalFloat += [productPrice floatValue];
            
        }else{
            ADProductCell *cell = [[ADProductCell alloc] initWithDict:dic];
            cell.noNeedBtn = YES;
            [tablePurchase appendCell:cell];
            [cell release];
            NSString *productPrice = [[dic objectForKey:@"product_detail"] objectForKey:@"price"];
            totalFloat += [productPrice floatValue];
        }
    }
    
    NSLog(@"totalFloat===%.2f",totalFloat);
    UILabel *priceLabel = (UILabel *)[self.view viewWithTag:KZongJiaLabel];
    if (priceLabel) {
        priceLabel.text = [NSString stringWithFormat:@"%.2f",totalFloat];
    }
    [tablePurchase reloadCell];
}

- (void)creatInputView
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW, KBarWidthF+ios7H+60.0+3*KProductCellH+55, KScreenHeight-KLeftWidthStoreViewW, 180)];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = KInputTag;
    [self.view addSubview:view];
    [view release];
    /// 姓名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60.0, 12.0+(40-20)/2.0, 70, 20)];
    nameLabel.font = [UIFont systemFontOfSize:18.0];
    nameLabel.text = @"姓名：";
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor darkGrayColor];
    [view addSubview:nameLabel];
    [nameLabel release];
    /// 姓名文本框图片
    UIImageView *nameImage = [[UIImageView alloc]initWithFrame:CGRectMake(60.0+55.0, 12.0, 300, 40.0)];
    nameImage.image = [IMG(inputBackYY4) stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
    [view addSubview:nameImage];
    [nameImage release];
    /// 姓名文本框控件
    UITextField *nameInput = [[UITextField alloc]initWithFrame:CGRectMake(60.0+65.0, 12.0+10.0, 290, 20.0)];
    nameInput.delegate = self;
    nameInput.tag = KNameINTag;
    //    nameInput.secureTextEntry = YES;
    nameInput.textColor = [UIColor blackColor];
    nameInput.backgroundColor = [UIColor clearColor];
    nameInput.font= [UIFont systemFontOfSize:18.0];
    nameInput.placeholder = @"请输入姓名";
    [view addSubview:nameInput];
    [nameInput release];
    /// 地址
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(60.0, 12.0+(40-20)/2.0+12.0+40.0, 70, 20)];
    addressLabel.font = [UIFont systemFontOfSize:18.0];
    addressLabel.text = @"地址：";
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textColor = [UIColor darkGrayColor];
    [view addSubview:addressLabel];
    [addressLabel release];
    /// 地址文本框图片
    UIImageView *addressImage = [[UIImageView alloc]initWithFrame:CGRectMake(60.0+55.0, 12.0+12.0+40.0, 590, 40.0)];
    addressImage.image = [IMG(inputBackYY4) stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
    [view addSubview:addressImage];
    [addressImage release];
    /// 地址文本框控件
    UITextField *addressInput = [[UITextField alloc]initWithFrame:CGRectMake(60.0+65.0, 12.0+10.0+12.0+40.0, 590-10, 20.0)];
    addressInput.delegate = self;
    addressInput.tag = KAddressTag;
    //    addressInput.secureTextEntry = YES;
    addressInput.textColor = [UIColor blackColor];
    addressInput.backgroundColor = [UIColor clearColor];
    addressInput.font= [UIFont systemFontOfSize:18.0];
    addressInput.placeholder = @"请输入地址";
    [view addSubview:addressInput];
    [addressInput release];
    /// 电话
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(60.0, 12.0+(40-20)/2.0+(12.0+40.0)*2, 70, 20)];
    phoneLabel.font = [UIFont systemFontOfSize:18.0];
    phoneLabel.text = @"电话：";
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.textColor = [UIColor darkGrayColor];
    [view addSubview:phoneLabel];
    [phoneLabel release];
    /// 电话文本框图片
    UIImageView *phoneImage = [[UIImageView alloc]initWithFrame:CGRectMake(60.0+55.0, 12.0+(12.0+40.0)*2, 300, 40.0)];
    phoneImage.image = [IMG(inputBackYY3) stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
    [view addSubview:phoneImage];
    [phoneImage release];
    /// 电话文本框控件
    UITextField *phoneInput = [[UITextField alloc]initWithFrame:CGRectMake(60.0+65.0, 12.0+10.0+(12.0+40.0)*2, 290.0, 20.0)];
    phoneInput.delegate = self;
    phoneInput.tag = KPhoneTag;
    //    phoneInput.secureTextEntry = YES;
    phoneInput.textColor = [UIColor blackColor];
    phoneInput.backgroundColor = [UIColor clearColor];
    phoneInput.font= [UIFont systemFontOfSize:18.0];
    phoneInput.placeholder = @"请输入电话";
    [view addSubview:phoneInput];
    [phoneInput release];
    /// 调用dismissKeyBoard方法消失键盘
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [view addGestureRecognizer:tapGesture];
    [tapGesture release];
    
}
///键盘退出
- (void)dismissKeyBoard
{
    UITextField *textAd = (UITextField *)[self.view viewWithTag:KAddressTag];
    UITextField *textPhone= (UITextField *)[self.view viewWithTag:KPhoneTag];
    UITextField *textName = (UITextField *)[self.view viewWithTag:KNameINTag];
    [textAd resignFirstResponder];
    [textPhone resignFirstResponder];
    [textName resignFirstResponder];
    [self downLoginViewAnimation];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [appDelegate UPDataLeftViewQrcodeBtn];
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+12, KBarWidthF+ios7H+20+2, 15, 16)];
    iconImage.image = IMG(shangpinqueren_icon);
    [self.view addSubview:iconImage];
    [iconImage release];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+12+28, KBarWidthF+ios7H+20, 200, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = LTXT(TKN_PUARECHASE_TITLE);
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+12, KBarWidthF+ios7H+20*2+2, KMainMiddleW, 4)];
    lineView.backgroundColor = KSystemBlue;
    [self.view addSubview:lineView];
    [lineView release];
    
    UIImageView *tableViewBackRect = [[UIImageView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+10, KBarWidthF+ios7H+60.0, KMainMiddleW, 3*KProductCellH)];
    tableViewBackRect.image = [IMG(srcoll_back) stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
    [self.view addSubview:tableViewBackRect];
    [tableViewBackRect release];
    
    tablePurchase = [[GTableViewV2 alloc] initWithFrame:CGRectMake(KLeftWidthStoreViewW+12, KBarWidthF+ios7H+62.0, KMainMiddleW-4, 3*KProductCellH-4)];
    tablePurchase.tableDelegate=self;
    [tablePurchase setEndOfTable:YES];
    tablePurchase.backgroundColor=KClearColor;
    tablePurchase.separatorColor = KClearColor;
    [tablePurchase removeFreshHeader];
    [self.view addSubview:tablePurchase];
    /// 送货上门图片
    UIImageView *songHuoImage = [[UIImageView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+10+20.0, KBarWidthF+ios7H+60.0+3*KProductCellH+15.0-3.5, 17.0, 20.0)];
    songHuoImage.tag = KSongHuoBtnTag;
    songHuoImage.image = IMG(gouwu_sel);
    [self.view addSubview:songHuoImage];
    [songHuoImage release];
    /// 送货上门label
    UILabel *songHuoLabel = [[UILabel alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+10+20.0+12+7.0, KBarWidthF+ios7H+60.0+3*KProductCellH+10.0, 100, 20)];
    songHuoLabel.font = [UIFont systemFontOfSize:20];
    songHuoLabel.backgroundColor = [UIColor clearColor];
    songHuoLabel.textColor = [UIColor darkGrayColor];
    songHuoLabel.text = @"送货上门";
    songHuoLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:songHuoLabel];
    [songHuoLabel release];
    
    /// 送货上门按钮
    UIButton *songHuoClike = [UIButton buttonWithType:UIButtonTypeCustom];
    songHuoClike.frame = CGRectMake(KLeftWidthStoreViewW+10+20.0, KBarWidthF+ios7H+60.0+3*KProductCellH+10.0, 100, 20);
    songHuoClike.tag = KSongHuoBtnTag +1;
    [songHuoClike addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:songHuoClike];
    
    /// 直接提货图片
    UIImageView *zhiJieImage = [[UIImageView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+10+20.0+200, KBarWidthF+ios7H+60.0+3*KProductCellH+15.0-3.5, 17.0, 20)];
    zhiJieImage.tag = KZhiJieBtnTag;
    zhiJieImage.image = IMG(gouwu_unsel);
    [self.view addSubview:zhiJieImage];
    [zhiJieImage release];
    /// 直接提货label
    UILabel *zhijieLabel = [[UILabel alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+10+20.0+12+200+7.0, KBarWidthF+ios7H+60.0+3*KProductCellH+10.0, 100, 20)];
    zhijieLabel.font = [UIFont systemFontOfSize:20];
    zhijieLabel.backgroundColor = [UIColor clearColor];
    zhijieLabel.textColor = [UIColor darkGrayColor];
    zhijieLabel.text = @"直接提货";
    zhijieLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:zhijieLabel];
    [zhijieLabel release];
    
    /// 直接提货按钮
    UIButton *zhiJieClike = [UIButton buttonWithType:UIButtonTypeCustom];
    zhiJieClike.frame = CGRectMake(KLeftWidthStoreViewW+10+20.0+200.0, KBarWidthF+ios7H+60.0+3*KProductCellH+10.0, 100, 20);
    zhiJieClike.tag = KZhiJieBtnTag +1;
    [zhiJieClike addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhiJieClike];
    /// 总价label
    UILabel *zongJiaNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+10+20.0+200.0+300.0, KBarWidthF+ios7H+60.0+3*KProductCellH+10.0, 100, 20)];
    zongJiaNameLabel.font = [UIFont systemFontOfSize:22];
    zongJiaNameLabel.backgroundColor = [UIColor clearColor];
    zongJiaNameLabel.textColor = [UIColor darkGrayColor];
    zongJiaNameLabel.text = @"总价：";
    zongJiaNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:zongJiaNameLabel];
    [zongJiaNameLabel release];
    /// 总价的值
    UILabel *zongJiaLabel = [[UILabel alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+10+20.0+200.0+300.0+60, KBarWidthF+ios7H+60.0+3*KProductCellH+10.0, 100, 20)];
    zongJiaLabel.font = [UIFont systemFontOfSize:20];
    zongJiaLabel.backgroundColor = [UIColor clearColor];
    zongJiaLabel.textColor = [UIColor redColor];
    zongJiaLabel.tag = KZongJiaLabel;
    //    zongJiaLabel.text = @"23232";
    zongJiaLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:zongJiaLabel];
    [zongJiaLabel release];
    
    [self creatInputView];
    [self freshTableView];
    /// 支付宝支付
    UIButton *zhiFuBaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zhiFuBaoBtn.frame = CGRectMake(KLeftWidthStoreViewW+250, KBarWidthF+ios7H+60.0+3*KProductCellH+55+180, 159, 54);
    [zhiFuBaoBtn setBackgroundImage:[UIImage imageNamed:@"btnOrange.png"] forState:UIControlStateNormal];
    [zhiFuBaoBtn setTitle:@"支付宝支付" forState:UIControlStateNormal];
    [zhiFuBaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zhiFuBaoBtn addTarget:self action:@selector(zhifuBaoClike) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhiFuBaoBtn];
    /// 微信支付
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake(KLeftWidthStoreViewW+250+159+20, KBarWidthF+ios7H+60.0+3*KProductCellH+55+180, 159, 54);
    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"btnLightGreen.png"] forState:UIControlStateNormal];
    [weixinBtn setTitle:@"微信支付" forState:UIControlStateNormal];
    [weixinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(weixinClike) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinBtn];
    /// 当面支付
    UIButton *dangmianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dangmianBtn.frame = CGRectMake(KLeftWidthStoreViewW+250+(159+20)*2, KBarWidthF+ios7H+60.0+3*KProductCellH+55+180, 159, 54);
    [dangmianBtn setBackgroundImage:[UIImage imageNamed:@"btnGreen.png"] forState:UIControlStateNormal];
    [dangmianBtn setTitle:@"当面支付" forState:UIControlStateNormal];
    [dangmianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dangmianBtn addTarget:self action:@selector(dangmianClike) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dangmianBtn];
    NSLog(@"dataArray=====%@",dataArray);
    isPayType = YES;
}

-(void)alertTitleMa
{
    if ([dataArray count]==0) {
        Alert(@"请选择商品");
        return;
    }
    
    UITextField *textAd = (UITextField *)[self.view viewWithTag:KAddressTag];
    UITextField *textPhone= (UITextField *)[self.view viewWithTag:KPhoneTag];
    UITextField *textName = (UITextField *)[self.view viewWithTag:KNameINTag];
    if ([textName.text isEqualToString:@""]||textName.text == nil) {
        Alert(@"请完善送货信息");
        return;
    }
    if ([textAd.text isEqualToString:@""]||textAd.text == nil) {
        Alert(@"请完善送货信息");
        return;
    }
    if ([textPhone.text isEqualToString:@""]||textPhone.text == nil) {
        Alert(@"请完善送货信息");
        return;
    }
    if ([GUtil phoneNumCheck:textPhone.text]==NO) {
        Alert(@"请输入正确格式的手机号码");
        return;
    }
//    Alert(@"该服务商还没有此业务");
}

-(void)weixinClike
{
    payResult = NO;
    
    UILabel *priceLabel = (UILabel *)[self.view viewWithTag:KZongJiaLabel];
    [self getPayQRCode:priceLabel.text];
    
    /*
    if (isPayType == YES) {
        [self alertTitleMa];
    } else {
        Alert(@"该服务商还没有此业务");
    }
     */
}

-(void)zhifuBaoClike
{
    if (isPayType == YES) {
        [self alertTitleMa];
    } else {
        Alert(@"该服务商还没有此业务");
    }
}

-(void)dangmianClike
{
    if (isPayType==YES) {
        if ([dataArray count]==0) {
            Alert(@"请选择商品");
            return;
        }
        UITextField *textAd = (UITextField *)[self.view viewWithTag:KAddressTag];
        UITextField *textPhone= (UITextField *)[self.view viewWithTag:KPhoneTag];
        UITextField *textName = (UITextField *)[self.view viewWithTag:KNameINTag];
        if ([textName.text isEqualToString:@""]||textName.text == nil) {
            Alert(@"请完善送货信息");
            return;
        }
        if ([textAd.text isEqualToString:@""]||textAd.text == nil) {
            Alert(@"请完善送货信息");
            return;
        }
        if ([textPhone.text isEqualToString:@""]||textPhone.text == nil) {
            Alert(@"请完善送货信息");
            return;
        }
        if ([GUtil phoneNumCheck:textPhone.text]==NO) {
            Alert(@"请输入正确格式的手机号码");
            return;
        }
        [self paoLoading:@"请稍后"];
        
        NSMutableDictionary *customerInfo = [NSMutableDictionary dictionary];
        [customerInfo setObject:textName.text forKey:@"name"];
        [customerInfo setObject:textPhone.text forKey:@"phone"];
        [customerInfo setObject:textAd.text forKey:@"address"];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        if (isOrderType == YES) {
            for (NSDictionary *dic in dataArray) {
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                [tempDic setObject:[dic objectForKey:@"order_detail_id"] forKey:@"order_detail_id"];
                [tempDic setObject:[dic objectForKey:@"sku_id"] forKey:@"sku_id"];
                [tempDic setObject:[dic objectForKey:@"sku_product_qty"] forKey:@"sku_qty"];
                [tempDic setObject:[dic objectForKey:@"size"] forKey:@"size"];
                [tempArray addObject:tempDic];
            }
        } else {
            for (NSDictionary *dic in dataArray) {
                NSMutableDictionary *tempdic = [NSMutableDictionary dictionary];
                [tempdic setObject:[[dic objectForKey:@"product_detail"] objectForKey:@"sku_id"] forKey:@"sku_id"];
                [tempdic setObject:[dic objectForKey:@"sku_qty"] forKey:@"sku_qty"];
                [tempdic setObject:[dic objectForKey:@"size"] forKey:@"size"];
                if ([dic objectForKey:@"cart_id"]!=nil) {
                    [tempdic setObject:[dic objectForKey:@"cart_id"] forKey:@"cart_id"];
                }
                [tempArray addObject:tempdic];
            }
        }
        
        [GJsonCenter wuAdian_pad_createorder:tempArray delivery_mode:@"1" pay_type:@"1" store_id:[ADSessionInfo sharedSessionInfo].store_id delivery_info:customerInfo jsonDelegate:self];
        
    } else {
        [self paoLoading:@"请稍后"];
        NSMutableArray *tempArray = [NSMutableArray array];
        if (isOrderType == YES) {
            for (NSDictionary *dic in dataArray) {
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                [tempDic setObject:[dic objectForKey:@"order_detail_id"] forKey:@"order_detail_id"];
                [tempDic setObject:[dic objectForKey:@"sku_id"] forKey:@"sku_id"];
                [tempDic setObject:[dic objectForKey:@"sku_product_qty"] forKey:@"sku_qty"];
                [tempDic setObject:[dic objectForKey:@"size"] forKey:@"size"];
                [tempArray addObject:tempDic];
            }
        } else {
            for (NSDictionary *dic in dataArray) {
                NSMutableDictionary *tempdic = [NSMutableDictionary dictionary];
                [tempdic setObject:[[dic objectForKey:@"product_detail"] objectForKey:@"sku_id"] forKey:@"sku_id"];
                [tempdic setObject:[dic objectForKey:@"sku_qty"] forKey:@"sku_qty"];
                [tempdic setObject:[dic objectForKey:@"size"] forKey:@"size"];
                
                if ([dic objectForKey:@"cart_id"]!=nil) {
                    [tempdic setObject:[dic objectForKey:@"cart_id"] forKey:@"cart_id"];
                }
                [tempArray addObject:tempdic];
            }
        }
        
        [GJsonCenter wuAdian_pad_createorder:tempArray delivery_mode:@"2" pay_type:@"1" store_id:[ADSessionInfo sharedSessionInfo].store_id delivery_info:nil jsonDelegate:self];
    }
}

- (void)addFacePayView
{
    
    UITableViewCell *facePay = [[[NSBundle mainBundle] loadNibNamed:@"FacePayView" owner:self options:nil] lastObject];
    facePay.tag = 10003;
    UILabel *priceLabel = (UILabel *)[self.view viewWithTag:KZongJiaLabel];
    UILabel *codePriceLabel = (UILabel *)[facePay viewWithTag:101];
    codePriceLabel.text = [NSString stringWithFormat:@"￥%@", priceLabel.text];
    
    GImageView *barCodeImg = (GImageView *)[facePay viewWithTag:100];
    NSString *codeUrl = self.qrCodeUrl;
    [barCodeImg loadImage:codeUrl defalutImage:IMG(bItem_iconDefalut)];
    
    facePay.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    facePay.backgroundColor = Color(111, 113, 121);
    facePay.alpha = 0.8;
    
    UIView *barCodeBG = (UIView *)[facePay viewWithTag:99];
    barCodeBG.backgroundColor = [UIColor whiteColor];
    barCodeBG.alpha = 1;
    
    // back ground
    self.bgViewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT-70, 200)];
    self.bgViewLeft.backgroundColor = Color(111, 113, 121);
    self.bgViewLeft.alpha = 0.8;
    self.bgViewLeft.tag = 10001;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.bgViewLeft];

    self.bgViewTop = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 0, 70, SCREEN_HEIGHT)];
    self.bgViewTop.backgroundColor = Color(111, 113, 121);
    self.bgViewTop.alpha = 0.8;
    self.bgViewTop.tag = 10002;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.bgViewTop];
    
    [self.view addSubview:facePay];
}

- (void)getPayQRCode:(NSString*)priceStr
{
    
    for (NSDictionary *dic in dataArray) {
        
        if ([dic objectForKey:@"cart_id"]!=nil) {
            self.cart_id = [dic objectForKey:@"cart_id"];
        }
        
        if ([[dic objectForKey:@"product_detail"] objectForKey:@"sku_id"] != nil) {
            self.sku_id = [[dic objectForKey:@"product_detail"] objectForKey:@"sku_id"];
        }
        
        if ([dic objectForKey:@"sku_qty"]!=nil) {
            self.sku_qty = [dic objectForKey:@"sku_qty"];
        }
        
        if ([dic objectForKey:@"size"]!=nil) {
            self.size = [dic objectForKey:@"size"];
        }
    }
    
    //第一步，创建URL
    UITextField *textAd = (UITextField *)[self.view viewWithTag:KAddressTag];
    UITextField *textPhone= (UITextField *)[self.view viewWithTag:KPhoneTag];
    UITextField *textName = (UITextField *)[self.view viewWithTag:KNameINTag];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/payment/weixpayDemo/createnativeurl.php?productName=test_pay&price=%@&cart_id=%@&sku_qty=%@&size=%@&sku_id=%@&name=%@&address=%@&phone=%@", WEIXIN_PAY, priceStr, self.cart_id, self.sku_qty, self.size, self.sku_id, textName.text, textAd.text, textPhone.text];
    NSString *targetString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:targetString];
    
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:9];
    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
    //    其中缓存协议是个枚举类型包含：
    //    NSURLRequestUseProtocolCachePolicy（基础策略）
    //    NSURLRequestReloadIgnoringLocalCacheData（忽略本地缓存）
    //    NSURLRequestReturnCacheDataElseLoad（首先使用缓存，如果没有本地缓存，才从原地址下载）
    //    NSURLRequestReturnCacheDataDontLoad（使用本地缓存，从不下载，如果本地没有缓存，则请求失败，此策略多用于离线操作）
    //    NSURLRequestReloadIgnoringLocalAndRemoteCacheData（无视任何缓存策略，无论是本地的还是远程的，总是从原地址重新下载）
    //    NSURLRequestReloadRevalidatingCacheData（如果本地缓存是有效的则不下载，其他任何情况都从原地址重新下载）
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *str = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"qrcode = %@", [dict objectForKey:@"qrcode"]);
    NSLog(@"order_id = %@", [dict objectForKey:@"order_id"]);
    
    self.qrCodeUrl = [dict objectForKey:@"qrcode"];
    self.orderId = [dict objectForKey:@"order_id"];
    
    [self addFacePayView];
    
    [self performSelector:@selector(checkPayResult)
               withObject:nil
               afterDelay:1.f];
}

- (void)checkPayResult
{
    if (payResult) {
        return;
    }
    
    //第一步，创建URL
    NSString *urlStr = [NSString stringWithFormat:@"%@/payment/getOrderStatus.php?order_id=%@", WEIXIN_PAY, self.orderId];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:9];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    if (![str isEqualToString:@"2"]) {
        payResult = NO;
        
        [self performSelector:@selector(checkPayResult)
                   withObject:nil
                   afterDelay:1.f];
    } else {
        payResult = YES;
        Alert(@"支付成功!");
        [self autoCloseFacePayCodeView];
    }
    
    NSLog(@"%@",str);
}

- (void)autoCloseFacePayCodeView
{
    payResult = YES;
    
    [self.bgViewLeft removeFromSuperview];
    [self.bgViewTop removeFromSuperview];
    
    UITableViewCell *facePay = (UITableViewCell *)[self.view viewWithTag:10003];
    [facePay removeFromSuperview];
    
    // Back
    ADOnlineBuyViewController *con = [[ADOnlineBuyViewController alloc] init];
    [appDelegate setBarAddLeftDelegate:con];
    [appDelegate.navController pushViewController:con animated:NO];
    [appDelegate.navController popToViewController:con/*[self.navigationController.viewControllers objectAtIndex:2]*/ animated:YES];
    [con release];
    
}

- (IBAction)closeFacePayCodeView
{
    payResult = YES;
    
    [self.bgViewLeft removeFromSuperview];
    [self.bgViewTop removeFromSuperview];
    
    UITableViewCell *facePay = (UITableViewCell *)[self.view viewWithTag:10003];
    [facePay removeFromSuperview];

}

- (void)changeType:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    UIImageView *image1 = (UIImageView*)[self.view viewWithTag:KSongHuoBtnTag];
    UIImageView *image2 = (UIImageView*)[self.view viewWithTag:KZhiJieBtnTag];
    UIView *view = (UIView *)[self.view viewWithTag:KInputTag];
    
    if (btn.tag == KSongHuoBtnTag +1) {
        
        image1.image = IMG(gouwu_sel);
        view.hidden = NO;
        isPayType = YES;
        image2.image = IMG(gouwu_unsel);
    } else if (btn.tag == KZhiJieBtnTag +1) {
        
        view.hidden = YES;
        isPayType = NO;
        image1.image = IMG(gouwu_unsel);
        image2.image = IMG(gouwu_sel);
        
    }
    
}

-(void) getNetData:(NSDictionary*)data withItem:(JsonRequestItem*)item
{
    
    [self paoCancelLoading];
    
    if ([[data objectForKey:@"rsp"] intValue]==1) {
        if ([[[data objectForKey:@"data"] objectForKey:@"is_success"] intValue]==1 ) {
            Alert(@"支付成功");
        }
    } else {
        Alert(@"支付失败");
    }
}

-(void) jsonRequestFailed:(JsonRequestItem*)item
{
    
    [self paoCancelLoading];
    Alert(@"支付失败");
}

- (BOOL) tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath{
    return YES;
}

-(void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [dataArray removeObjectAtIndex:indexPath.row];
        [self freshTableView];
    }
}

-(UITableViewCellEditingStyle) tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return UITableViewCellEditingStyleDelete;
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
    //    NSArray *conTrolArray = [self.navigationController viewControllers];
    //    if ([conTrolArray count]>=2) {
    //        UIViewController *con = [conTrolArray objectAtIndex:[conTrolArray count]-2];
    //        if (con) {
    //            [appDelegate setBarAddLeftDelegate:con];
    //        }
    //    }
    //    [self.navigationController popViewControllerAnimated:YES];
}

- (void)upLoginViewAnimation
{
    UIView *view = [self.view viewWithTag:KInputTag];
    if (view) {
        [UIView animateWithDuration:0.2 animations:^{
            view.frame = CGRectMake(KLeftWidthStoreViewW, KBarWidthF+ios7H+60.0+3*KProductCellH+55-250, KScreenHeight-KLeftWidthStoreViewW, 180);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

- (void)downLoginViewAnimation
{
    UIView *view = [self.view viewWithTag:KInputTag];
    if (view) {
        [UIView animateWithDuration:0.2 animations:^{
            view.frame = CGRectMake(KLeftWidthStoreViewW, KBarWidthF+ios7H+60.0+3*KProductCellH+55, KScreenHeight-KLeftWidthStoreViewW, 180);
        } completion:^(BOOL finished) {
        }];
    }
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    [self upLoginViewAnimation];
//    return YES;
//}
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    if (textField.tag ==KPhoneTag) {
//        [self downLoginViewAnimation];
//    }
//    return YES;
//}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if (textField.tag == KPhoneTag) {
//        [self downLoginViewAnimation];
//        [textField resignFirstResponder];
//
//    }
//    UITextField *textAd = (UITextField *)[self.view viewWithTag:KAddressTag];
//    if (textField.tag == KNameINTag) {
//        [textAd becomeFirstResponder];
//    }
//
//    UITextField *text = (UITextField *)[self.view viewWithTag:KPhoneTag];
//    if (textField.tag == KAddressTag) {
//        [text becomeFirstResponder];
//    }
//    return YES;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
