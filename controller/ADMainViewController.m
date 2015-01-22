//
//  ADMainViewController.m
//  ADianTaste
//
//  Created by Keil on 14-3-4.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADMainViewController.h"
#import "GDefine.h"
#import "JsonNetManager.h"
#import "ADSessionInfo.h"
#import "GJsonCenter.h"
#import "ADOrderCell.h"
#import "GUtil.h"
#import "UIView_Extras.h"
#import "ADRecentPeopleViewController.h"
#import "ADPurchaseViewController.h"
#import "ADCustomerServiceViewController.h"
#import "ADOnlineBuyViewController.h"
#define KtiYanDanTable @"tabletiyandan"
#define KtiYanCheTable @"tabletiyanche"
#define KonLineTable @"tableonline"
#define KdidTiYanTable @"tabledidtiyan"
#define KshouCangTable @"tableshoucang"
#define KhistoryTable @"tablehistory"


@interface ADMainViewController ()

@end

@implementation ADMainViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isFirst = YES;
        gouMaiArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}
- (void)dealloc
{
    tiYanDanTable.tableDelegate=nil;
    [tiYanDanTable release];
    tiYanCheTable.tableDelegate=nil;
    [tiYanCheTable release];
    onLineTable.tableDelegate=nil;
    [onLineTable release];
    didTiYanTable.tableDelegate=nil;
    [didTiYanTable release];
    shouCangTable.tableDelegate=nil;
    [shouCangTable release];
    historyTable.tableDelegate=nil;
    [historyTable release];
    tabView.delegate = nil;
    [tabView release];
    [userInfoView release];
    bottomView.delegate = nil;
    [bottomView release];
    [gouMaiArray release];
    [alertLabel release];
    //    [offsetArray release];
    [super dealloc];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)updateStatusBar
{
    [self setNeedsStatusBarAppearanceUpdate];
    
}
-(void)animationUserInfoView
{
    [UIView animateWithDuration:0.2 animations:^{
        userInfoView.frame = CGRectMake(KScreenHeight, KBarWidthF+ios7H, KScreenHeight-KLeftWidthStoreViewW, KPeopleInfoViewHeiht);
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)animationBarView:(BOOL)isOut
{
    float x = KScreenHeight;
    if (isOut==NO) {
        x = KLeftWidthStoreViewW;
    }
    if (isOut) {
        
    }
    [UIView animateWithDuration:0.2 animations:^{
        tabView.frame = CGRectMake(x, KBarWidthF+ios7H+KPeopleInfoViewHeiht, KScreenHeight-KLeftWidthStoreViewW, 58);
    } completion:^(BOOL finished) {
        
    }];
    
    
}
- (void)hiddenBottomView
{
    bottomView.hidden = YES;
    
}

- (void)showTable:(UIView *)table
{
    tableViewBackRect.frame = CGRectMake(KLeftWidthStoreViewW+10, KBarWidthF+ios7H+KPeopleInfoViewHeiht+7+58, KMainMiddleW, KMainMiddleH);
    if (table == tiYanDanTable) {
        tiYanDanTable.hidden = NO;
        bottomView.hidden = NO;
        [bottomView hiddenTiyanBtn:NO];
    }else{
        tiYanDanTable.hidden = YES;
        
    }
    if (table == tiYanCheTable) {
        tiYanCheTable.hidden = NO;
        bottomView.hidden = NO;
        [bottomView hiddenTiyanBtn:NO];
    }else{
        tiYanCheTable.hidden = YES;
        
    }
    if (table == onLineTable) {
        onLineTable.hidden = NO;
        bottomView.hidden = YES;
        
    }else{
        onLineTable.hidden = YES;
        
    }
    if (table == didTiYanTable) {
        didTiYanTable.hidden = NO;
        bottomView.hidden = NO;
        [bottomView hiddenTiyanBtn:YES];
        
        
    }else{
        didTiYanTable.hidden = YES;
        
    }
    if (table == shouCangTable) {
        tableViewBackRect.frame = CGRectMake(KLeftWidthStoreViewW+10, KBarWidthF+ios7H+KPeopleInfoViewHeiht+7+58, KMainMiddleW, KMainMiddleH+90);
        shouCangTable.hidden = NO;
        bottomView.hidden = YES;
        
    }else{
        shouCangTable.hidden = YES;
        
    }
    if (table == historyTable) {
        tableViewBackRect.frame = CGRectMake(KLeftWidthStoreViewW+10, KBarWidthF+ios7H+KPeopleInfoViewHeiht+7+58, KMainMiddleW, KMainMiddleH+90);
        historyTable.hidden = NO;
        bottomView.hidden = YES;
        
    }else{
        historyTable.hidden = YES;
        
    }
    if (table == nil) {
        alertLabel.hidden = NO;
        bottomView.hidden = YES;
    }else{
        alertLabel.hidden = YES;
        
    }
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateStatusBar];
    
    userInfoView = [[ADInfoView alloc]initWithFrame:CGRectMake(KScreenHeight, KBarWidthF+ios7H, KScreenHeight-KLeftWidthStoreViewW, KPeopleInfoViewHeiht)];
    [self.view addSubview:userInfoView];
    
    tabView = [[ADTabView alloc]initWithFrame:CGRectMake(KScreenHeight, KBarWidthF+ios7H+KPeopleInfoViewHeiht, KScreenHeight-KLeftWidthStoreViewW, 58)];
    tabView.delegate = self;
    [self.view addSubview:tabView];
    
    tableViewBackRect = [[UIImageView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+10, KBarWidthF+ios7H+KPeopleInfoViewHeiht+7+58, KMainMiddleW, KMainMiddleH)];
    tableViewBackRect.image = [IMG(srcoll_back) stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
    [self.view addSubview:tableViewBackRect];
    
    
    alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+10, KBarWidthF+ios7H+KPeopleInfoViewHeiht+7+58+100, KMainMiddleW, 40.0)];
    alertLabel.font = [UIFont systemFontOfSize:40.0];
    alertLabel.backgroundColor = [UIColor clearColor];
    alertLabel.textColor = [UIColor blackColor];
    alertLabel.text = LTXT(TKN_ALERT_STRING);
    alertLabel.hidden = YES;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:alertLabel];
    
    bottomView = [[ADProductBottomView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW, KBarWidthF+ios7H+KPeopleInfoViewHeiht+7+58+15+KMainMiddleH, KMainMiddleW, 64)];
    bottomView.hidden = NO;
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    
    
    tiYanDanTable = [[GTableViewV2 alloc] initWithFrame:CGRectMake(KLeftWidthStoreViewW+12, KBarWidthF+ios7H+KPeopleInfoViewHeiht+7+58+2, KMainMiddleW-4, KMainMiddleH-4)];
    
    tiYanDanTable.tableDelegate=self;
    tiYanDanTable._contentType = KtiYanDanTable;
    [tiYanDanTable setEndOfTable:YES];
    tiYanDanTable.backgroundColor=KClearColor;
    tiYanDanTable.separatorColor = KClearColor;
    [tiYanDanTable removeFreshHeader];
    [tiYanDanTable rebuildFreshHeaderWithWidth:KMainMiddleW];
    [self.view addSubview:tiYanDanTable];
    
    tiYanCheTable = [[GTableViewV2 alloc] initWithFrame:CGRectMake(KLeftWidthStoreViewW+12, KBarWidthF+ios7H+KPeopleInfoViewHeiht+7+58+2, KMainMiddleW-4, KMainMiddleH-4)];
    tiYanCheTable.tableDelegate=self;
    tiYanCheTable._contentType = [KtiYanCheTable retain];
    [tiYanCheTable setEndOfTable:YES];
    tiYanCheTable.backgroundColor=KClearColor;
    tiYanCheTable.separatorColor = KClearColor;
    [tiYanCheTable removeFreshHeader];
    [tiYanCheTable rebuildFreshHeaderWithWidth:KMainMiddleW];
    [self.view addSubview:tiYanCheTable];
    
    onLineTable = [[GTableViewV2 alloc] initWithFrame:CGRectMake(KLeftWidthStoreViewW+12, KBarWidthF+ios7H+KPeopleInfoViewHeiht+7+58+2, KMainMiddleW-4, KMainMiddleH-4)];
    onLineTable.tableDelegate=self;
    onLineTable._contentType = KonLineTable;
    [onLineTable setEndOfTable:YES];
    onLineTable.backgroundColor=KClearColor;
    onLineTable.separatorColor = KClearColor;
    [onLineTable removeFreshHeader];
    [onLineTable rebuildFreshHeaderWithWidth:KMainMiddleW];
    [self.view addSubview:onLineTable];
    
    didTiYanTable = [[GTableViewV2 alloc] initWithFrame:CGRectMake(KLeftWidthStoreViewW+12, KBarWidthF+ios7H+KPeopleInfoViewHeiht+7+58+2, KMainMiddleW-4, KMainMiddleH-4)];
    didTiYanTable.tableDelegate=self;
    didTiYanTable._contentType = KdidTiYanTable;
    [didTiYanTable setEndOfTable:YES];
    didTiYanTable.backgroundColor=KClearColor;
    didTiYanTable.separatorColor = KClearColor;
    [didTiYanTable removeFreshHeader];
    [didTiYanTable rebuildFreshHeaderWithWidth:KMainMiddleW];
    [self.view addSubview:didTiYanTable];
    
    shouCangTable = [[GTableViewV2 alloc] initWithFrame:CGRectMake(KLeftWidthStoreViewW+12, KBarWidthF+ios7H+KPeopleInfoViewHeiht+7+58+2, KMainMiddleW-4, KMainMiddleH+95)];
    shouCangTable.tableDelegate=self;
    shouCangTable._contentType = KshouCangTable;
    [shouCangTable setEndOfTable:YES];
    shouCangTable.backgroundColor=KClearColor;
    shouCangTable.separatorColor = KClearColor;
    [shouCangTable removeFreshHeader];
    [shouCangTable rebuildFreshHeaderWithWidth:KMainMiddleW];
    [self.view addSubview:shouCangTable];
    
    historyTable = [[GTableViewV2 alloc] initWithFrame:CGRectMake(KLeftWidthStoreViewW+12, KBarWidthF+ios7H+KPeopleInfoViewHeiht+7+58+2, KMainMiddleW-4, KMainMiddleH+95)];
    historyTable.tableDelegate=self;
    historyTable._contentType = KhistoryTable;
    [historyTable setEndOfTable:YES];
    historyTable.backgroundColor=KClearColor;
    historyTable.separatorColor = KClearColor;
    [historyTable removeFreshHeader];
    [historyTable rebuildFreshHeaderWithWidth:KMainMiddleW];
    [self.view addSubview:historyTable];
    
    [self showTable:nil];
    //    offsetArray = [[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0", nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [appDelegate setBarAddLeftDelegate:self];
    if (isFirst==YES) {
        [self performSelectorInBackground:@selector(timerStart) withObject:nil];
        isFirst = NO;
    }
    
    
    
}

-(void)timerStart
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    if (timer) {
        [timer release];
    }
    timer = [[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(sendLoopRequest) userInfo:nil repeats:YES] retain];
    [timer fire];
    [runLoop run];
    [pool release];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopLoop];
    //    if (timer) {
    //        [timer invalidate];
    //        timer = nil;
    //
    //    }
}
- (void)stopLoop
{
    if (timer) {
        isTiming=NO;
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)sendLoopRequest{
    @autoreleasepool {
        isTiming=YES;
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:[ADSessionInfo sharedSessionInfo].scene_id,@"scene_id",[ADSessionInfo sharedSessionInfo].store_id,@"store_id",[ADSessionInfo sharedSessionInfo].creat_time,@"since", nil];
        NSDictionary *dic = [JsonRequestItem requestSyncJson:data withCmd:@"wuadian_pad_polling" withPost:YES];
        NSLog(@"dic=====%@",dic);
        if ([[dic objectForKey:@"rsp"] intValue]==1) {
            if ([[dic objectForKey:@"data"] objectForKey:@"member_id"]&&![[[dic objectForKey:@"data"] objectForKey:@"member_id"] isEqualToString:@""]) {
                [ADSessionInfo sharedSessionInfo].member_id_string = [[dic objectForKey:@"data"] objectForKey:@"member_id"];
                [self performSelectorOnMainThread:@selector(getCustomerInfo) withObject:nil waitUntilDone:NO];
            }
        }
    }
}

- (void)getCustomerInfo
{
    [tabView setIndex:0];
    [self showTable:tiYanDanTable];
    [tiYanDanTable mainRefresh];
    [appDelegate UPDataLeftViewQrcodeBtn];
    [self stopLoop];
}

- (void)refreshQrcode
{
    @autoreleasepool {
        
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:[ADSessionInfo sharedSessionInfo].store_id,@"store_id", nil];
        
        NSDictionary *dic = [JsonRequestItem requestSyncJson:data withCmd:@"wuadian_pad_generateqrcode" withPost:YES];
        
        if ([[dic objectForKey:@"rsp"] intValue]==1) {
            
            if (StrValid([[dic objectForKey:@"data"] objectForKey:@"scene_id"])) {
                [ADSessionInfo sharedSessionInfo].scene_id = [[dic objectForKey:@"data"] objectForKey:@"scene_id"];
            }
            if (StrValid([[dic objectForKey:@"data"] objectForKey:@"create_time"])){
                [ADSessionInfo sharedSessionInfo].creat_time = [[dic objectForKey:@"data"] objectForKey:@"create_time"];
            }
            if (StrValid([[dic objectForKey:@"data"] objectForKey:@"qrcode_url"])) {
                [ADSessionInfo sharedSessionInfo].qrcode_url = [[dic objectForKey:@"data"] objectForKey:@"qrcode_url"];
            }
            
            NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[GUtil getInfo:KUserDicKey]];
            if (userDic) {
                [userDic setObject:[dic objectForKey:@"data"] forKey:@"qrcode_info"];
            }
            
            NSLock *lock = [[NSLock alloc] init];
            [lock lock];
            [GUtil removeInfo:KUserDicKey];
            [GUtil setInfo:userDic withKey:KUserDicKey];
            [lock unlock];
            [lock release];
            
            [self performSelectorOnMainThread:@selector(updateQRCodeImage) withObject:nil waitUntilDone:NO];
        }
    }
}

- (void)updateQRCodeImage
{
    [ADSessionInfo sharedSessionInfo].member_id_string = @"";
    [appDelegate upDataLeftViewQrcode];
    [self animationUserInfoView];
    [self animationBarView:YES];
    [self showTable:nil];
    
    if (isTiming==NO) {
        [self performSelectorInBackground:@selector(timerStart) withObject:nil];
    }
}

#pragma mark baseDelagate
-(NSArray*) reloadTableWithData:(NSString *)param
{
    if ([param isEqualToString:KtiYanDanTable]) {
        [GJsonCenter wuADianPadGetCustomerInfo:@"0" num:@"4" jsonDelegate:self].custom =@"yes";
    }else if ([param isEqualToString:KtiYanCheTable]){
        [GJsonCenter wuAdian_member_get_shoppingCarList:@"0" num:@"4" cartType:@"1" jsonDelegate:self].custom = @"yes";
        
    }else if ([param isEqualToString:KonLineTable]){
        [GJsonCenter wuAdian_order_getdeffstatueorderlist:@"0" num:@"4" orderType:@"1" status:@[@"1"] cid:KonLineTable jsonDelegate:self].custom = @"yes";
        
    }else if ([param isEqualToString:KdidTiYanTable]){
        [GJsonCenter wuAdian_order_getdeffstatueorderlist:@"0" num:@"4" orderType:@"2" status:@[@"8"] cid:KdidTiYanTable jsonDelegate:self].custom = @"yes";
        
    }else if ([param isEqualToString:KshouCangTable]){
        [GJsonCenter wuAdian_member_getfavoriteslist:@"0" num:@"4" jsonDelegate:self].custom = @"yes";
        
    }else if ([param isEqualToString:KhistoryTable]){
        [GJsonCenter wuAdian_member_getbrowsehistorylist:@"0" num:@"4" jsonDelegate:self].custom = @"yes";
    }
    
    return nil;
    
}
-(NSArray*) loadMoreTableFrom:(NSString*)index withNum:(NSString*)num andParam:(NSString*)param
{
    if ([param isEqualToString:KtiYanDanTable]) {
        NSString *offset = [NSString stringWithFormat:@"%d",[tiYanDanTable.dataArray count]];
        [GJsonCenter wuADianPadGetCustomerInfo:offset num:@"4" jsonDelegate:self].custom = @"no";
    }else if ([param isEqualToString:KtiYanCheTable]){
        NSString *offset = [NSString stringWithFormat:@"%d",[tiYanCheTable.dataArray count]];
        [GJsonCenter wuAdian_member_get_shoppingCarList:offset num:@"4" cartType:@"1" jsonDelegate:self].custom = @"no";
        
    }else if ([param isEqualToString:KonLineTable]){
        NSString *offset = [NSString stringWithFormat:@"%d",[onLineTable.dataArray count]];
        [GJsonCenter wuAdian_order_getdeffstatueorderlist:offset num:@"4" orderType:@"1" status:@[@"1"] cid:KonLineTable jsonDelegate:self].custom = @"no";
        
    }else if ([param isEqualToString:KdidTiYanTable]){
        NSString *offset = [NSString stringWithFormat:@"%d",[didTiYanTable.dataArray count]];
        [GJsonCenter wuAdian_order_getdeffstatueorderlist:offset num:@"4" orderType:@"2" status:@[@"8"] cid:KdidTiYanTable jsonDelegate:self].custom = @"no";
        
    }else if ([param isEqualToString:KshouCangTable]){
        NSString *offset = [NSString stringWithFormat:@"%d",[shouCangTable.dataArray count]];
        [GJsonCenter wuAdian_member_getfavoriteslist:offset num:@"4" jsonDelegate:self].custom = @"no";
    }else if ([param isEqualToString:KhistoryTable]){
        NSString *offset = [NSString stringWithFormat:@"%d",[historyTable.dataArray count]];
        [GJsonCenter wuAdian_member_getbrowsehistorylist:offset num:@"4" jsonDelegate:self].custom = @"no";
    }
    return nil;
    
}
-(void) getNetData:(NSDictionary*)data withItem:(JsonRequestItem*)item
{
    NSRange rang = [item.custom rangeOfString:@"yes"];
    
    if ([[data objectForKey:@"rsp"] intValue]==1&&rang.length > 0) {
        if ([gouMaiArray count]>0) {
            [gouMaiArray removeAllObjects];
            [bottomView updateNumLabel:[NSString stringWithFormat:@"%d",[gouMaiArray count]]];
            
        }
    }
    if([item.type isEqualToString:@"wuadian_pad_getcustomerinfo"])
    {
        if ([[data objectForKey:@"rsp"] intValue]==1) {
            if ([[[data objectForKey:@"data"] objectForKey:@"member"] isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *userDic = [[data objectForKey:@"data"] objectForKey:@"member"];
                [userInfoView updateInfoNum:userDic];
                [self animationBarView:NO];
            }
            NSRange rang = [item.custom rangeOfString:@"yes"];
            if(rang.length > 0)
            {
                [tiYanDanTable.dataArray removeAllObjects];
            }
            if ([[[[data objectForKey:@"data"] objectForKey:@"orders"] objectForKey:@"lists"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:[[[data objectForKey:@"data"] objectForKey:@"orders"] objectForKey:@"lists"]];
                if ([array count]==0) {
                    [self hiddenBottomView];
                }
                for (NSDictionary *dic in array) {
                    if ([[[dic objectForKey:@"orderDetail"] objectForKey:@"lists"] isKindOfClass:[NSArray class]]) {
                        NSMutableArray *array =[NSMutableArray arrayWithArray:[[dic objectForKey:@"orderDetail"] objectForKey:@"lists"]];
                        
                        for (int i= 0; i<[array count]; i++) {
                            
                            ADOrderCell *cell = [[ADOrderCell alloc] initWithDict:[array objectAtIndex:i]];
                            if (i==0) {
                                cell.dingdanHao = [dic objectForKey:@"order_code"];
                                cell.isNeedHead = YES;
                            }else{
                                cell.isNeedHead = NO;
                                
                            }
                            [tiYanDanTable appendCell:cell];
                            [cell release];
                            
                            
                        }
                    }
                    
                }
                [tiYanDanTable reloadCell];
                
            }
            [tiYanDanTable loadNormalStatus];
            
        }else{
            [tiYanDanTable loadNormalStatus];
            
        }
        
    }else if ([item.type isEqualToString:@"wuadian_member_getshoppingcartlist"]){
        if ([[data objectForKey:@"rsp"] intValue]==1) {
            NSRange rang = [item.custom rangeOfString:@"yes"];
            if(rang.length > 0)
            {
                [tiYanCheTable.dataArray removeAllObjects];
            }
            if ([[[data objectForKey:@"data"] objectForKey:@"has_next"] intValue]==1) {
                [tiYanCheTable setEndOfTable:NO];
            }else{
                [tiYanCheTable setEndOfTable:YES];
                
            }
            if ([[[data objectForKey:@"data"] objectForKey:@"lists"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *dataArray = [[data objectForKey:@"data"] objectForKey:@"lists"];
                if ([dataArray count]==0) {
                    [self hiddenBottomView];
                }
                for (NSDictionary *dic in dataArray) {
                    ADProductCell *cell = [[ADProductCell alloc] initWithDict:dic];
                    [tiYanCheTable appendCell:cell];
                    [cell release];
                }
                [tiYanCheTable loadNormalStatus];
                [tiYanCheTable reloadCell];
                
            }
        }else{
            [tiYanCheTable loadNormalStatus];
            
        }
        
    }else if ([item.type isEqualToString:@"wuadian_member_getfavoriteslist"]){
        if ([[data objectForKey:@"rsp"] intValue]==1) {
            NSRange rang = [item.custom rangeOfString:@"yes"];
            if(rang.length > 0)
            {
                [shouCangTable.dataArray removeAllObjects];
            }
            if ([[[data objectForKey:@"data"] objectForKey:@"has_next"] intValue]==1) {
                [shouCangTable setEndOfTable:NO];
            }else{
                [shouCangTable setEndOfTable:YES];
                
            }
            if ([[[data objectForKey:@"data"] objectForKey:@"lists"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *dataArray = [[data objectForKey:@"data"] objectForKey:@"lists"];
                if ([dataArray count]==0) {
                    [self hiddenBottomView];
                }
                int iIndex = 0;
                for (NSDictionary *dic in dataArray) {
                    ADProductCell *cell = [[ADProductCell alloc] initWithDict:dic];
                    cell.delegate = self;
                    cell.indexCell = iIndex;
                    cell.noNeedBtn =YES;
                    cell.isBackBtn = YES;
                    [shouCangTable appendCell:cell];
                    [cell release];
                    iIndex++;
                    
                }
                [shouCangTable loadNormalStatus];
                [shouCangTable reloadCell];
                
            }
        }else{
            [shouCangTable loadNormalStatus];
            
        }
        
        
        
    }else if ([item.type isEqualToString:@"wuadian_member_getbrowsehistorylist"]){
        if ([[data objectForKey:@"rsp"] intValue]==1) {
            NSRange rang = [item.custom rangeOfString:@"yes"];
            if(rang.length > 0)
            {
                [historyTable.dataArray removeAllObjects];
            }
            if ([[[data objectForKey:@"data"] objectForKey:@"has_next"] intValue]==1) {
                [historyTable setEndOfTable:NO];
            }else{
                [historyTable setEndOfTable:YES];
                
            }
            if ([[[data objectForKey:@"data"] objectForKey:@"lists"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *dataArray = [[data objectForKey:@"data"] objectForKey:@"lists"];
                if ([dataArray count]==0) {
                    [self hiddenBottomView];
                }
                for (NSDictionary *dic in dataArray) {
                    ADProductCell *cell = [[ADProductCell alloc] initWithDict:dic];
                    cell.noNeedBtn =YES;
                    [historyTable appendCell:cell];
                    [cell release];
                }
                [historyTable loadNormalStatus];
                [historyTable reloadCell];
                
            }
        }else{
            [historyTable loadNormalStatus];
            
        }
        
        
        
    }else if ([item.type isEqualToString:@"wuadian_order_getdeffstatusorders"]){
        
        if ([item.subType isEqualToString:KonLineTable]) {
            if ([[data objectForKey:@"rsp"] intValue]==1) {
                NSRange rang = [item.custom rangeOfString:@"yes"];
                if(rang.length > 0)
                {
                    [onLineTable.dataArray removeAllObjects];
                }
                if ([[[data objectForKey:@"data"]  objectForKey:@"lists"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:[[data objectForKey:@"data"]  objectForKey:@"lists"]];
                    if ([array count]==0) {
                        [self hiddenBottomView];
                    }
                    for (NSDictionary *dic in array) {
                        if ([[[dic objectForKey:@"orderDetail"] objectForKey:@"lists"] isKindOfClass:[NSArray class]]) {
                            NSMutableArray *array =[NSMutableArray arrayWithArray:[[dic objectForKey:@"orderDetail"] objectForKey:@"lists"]];
                            
                            for (int i= 0; i<[array count]; i++) {
                                
                                ADOrderCell *cell = [[ADOrderCell alloc] initWithDict:[array objectAtIndex:i]];
                                if (i==0) {
                                    cell.dingdanHao = [dic objectForKey:@"order_code"];
                                    cell.isNeedHead = YES;
                                }else{
                                    cell.isNeedHead = NO;
                                    
                                }
                                cell.noNeedBtn =YES;
                                [onLineTable appendCell:cell];
                                [cell release];
                                
                                
                            }
                        }
                    }
                    [onLineTable reloadCell];
                    
                }
                [onLineTable loadNormalStatus];
                
            }else{
                [onLineTable loadNormalStatus];
                
            }
        }else if ([item.subType isEqualToString:KdidTiYanTable])
        {
            if ([[data objectForKey:@"rsp"] intValue]==1) {
                NSRange rang = [item.custom rangeOfString:@"yes"];
                if(rang.length > 0)
                {
                    [didTiYanTable.dataArray removeAllObjects];
                }
                if ([[[data objectForKey:@"data"]  objectForKey:@"lists"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:[[data objectForKey:@"data"]  objectForKey:@"lists"]];
                    if ([array count]==0) {
                        [self hiddenBottomView];
                    }
                    for (NSDictionary *dic in array) {
                        if ([[[dic objectForKey:@"orderDetail"] objectForKey:@"lists"] isKindOfClass:[NSArray class]]) {
                            NSMutableArray *array =[NSMutableArray arrayWithArray:[[dic objectForKey:@"orderDetail"] objectForKey:@"lists"]];
                            
                            for (int i= 0; i<[array count]; i++) {
                                
                                ADOrderCell *cell = [[ADOrderCell alloc] initWithDict:[array objectAtIndex:i]];
                                if (i==0) {
                                    cell.dingdanHao = [dic objectForKey:@"order_code"];
                                    cell.isNeedHead = YES;
                                }else{
                                    cell.isNeedHead = NO;
                                    
                                }
                                [didTiYanTable appendCell:cell];
                                [cell release];
                                
                                
                            }
                        }
                    }
                    [didTiYanTable reloadCell];
                    
                }
                [didTiYanTable loadNormalStatus];
                
            }else{
                [didTiYanTable loadNormalStatus];
                
            }
            
            
        }
        
        
        
    }else if ([item.type isEqualToString:@"wuadian_order_experience"]){
        [self paoCancelLoading];
        if ([[data objectForKey:@"rsp"] intValue]==1) {
            if ([[[data objectForKey:@"data"] objectForKey:@"is_success"] intValue]==1 ) {
                [tabView setIndex:3];
                [self showTable:didTiYanTable];
                [didTiYanTable mainRefresh];
            }
        }else{
            Alert(@"体验失败");
            
        }
        
        
    }else if ([item.type isEqualToString:@"wuadian_pad_cartexperience"]){
        [self paoCancelLoading];
        if ([[data objectForKey:@"rsp"] intValue]==1) {
            if ([[[data objectForKey:@"data"] objectForKey:@"is_success"] intValue]==1 ) {
                [tabView setIndex:3];
                [self showTable:didTiYanTable];
                [didTiYanTable mainRefresh];
            }
        }else{
            Alert(@"体验失败");
            
        }
        
    }
    
    
    
    
}
-(void) jsonRequestFailed:(JsonRequestItem*)item
{
    if([item.type isEqualToString:@"wuadian_pad_getcustomerinfo"])
    {   [tiYanDanTable loadNormalStatus];
    }else if ([item.type isEqualToString:@"wuadian_member_getshoppingcartlist"]){
        [tiYanCheTable loadNormalStatus];
    }else if ([item.type isEqualToString:@"wuadian_member_getfavoriteslist"]){
        [shouCangTable loadNormalStatus];
    }else if ([item.type isEqualToString:@"wuadian_member_getbrowsehistorylist"]){
        [historyTable loadNormalStatus];
    }else if ([item.type isEqualToString:@"wuadian_order_getdeffstatusorders"]){
        if ([item.subType isEqualToString:KdidTiYanTable]) {
            [didTiYanTable loadNormalStatus];
            
        }else if ([item.subType isEqualToString:KonLineTable]){
            [onLineTable loadNormalStatus];
            
        }
    }else if ([item.type isEqualToString:@"wuadian_order_experience"]){
        
        Alert(@"体验失败");
        
    }else if ([item.type isEqualToString:@"wuadian_pad_cartexperience"]){
        
        Alert(@"体验失败");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark ADBarAddLeftEventDelegate
- (void)barViewBackEvent
{
    
    //    if ([[[appDelegate.navController viewControllers] lastObject] isKindOfClass:[self class]]) {
    //        [appDelegate loginOut];
    //    }
    //    [appDelegate.navController popToViewController:self animated:YES];
}
- (void)backRefreshQrcode
{
    [self performSelectorInBackground:@selector(refreshQrcode) withObject:nil];
}
- (void)barViewRefreshEvent
{
    NSLog(@"刷新");
    [self performSelectorInBackground:@selector(refreshQrcode) withObject:nil];
    //    switch ([appDelegate barIndex]) {
    //        case 0:
    //        {
    //        //首页刷新
    //        }
    //            break;
    //        case 1:
    //        {
    //        //客服刷新
    //        }
    //            break;
    //        case 2:
    //        {
    //        //历史记录刷新
    //        }
    //            break;
    //        case 3:
    //        {
    //        //设置刷新
    //        }
    //            break;
    //        default:
    //            break;
    //    }
    
    
}
- (void)changeClikeEvent:(int)indexTag
{
    switch (indexTag) {
        case 0:
        {
            ADOnlineBuyViewController *con = [[ADOnlineBuyViewController alloc] init];
            [appDelegate setBarAddLeftDelegate:con];
            [appDelegate.navController pushViewController:con animated:NO];
            [con release];
        }
            break;
        case 1:
        {
            
            ADCustomerServiceViewController *con = [[ADCustomerServiceViewController alloc] init];
            [appDelegate setBarAddLeftDelegate:con];
            [appDelegate.navController pushViewController:con animated:NO];
            [con release];
        }
            break;
        case 2:
        {
            ADRecentPeopleViewController *con = [[ADRecentPeopleViewController alloc] init];
            [appDelegate setBarAddLeftDelegate:con];
            [appDelegate.navController pushViewController:con animated:NO];
            [con release];
            
        }
            break;
        case 3:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认退出？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    
                    if ([[[appDelegate.navController viewControllers] lastObject] isKindOfClass:[self class]]) {
                        [appDelegate loginOut];
                    }
                }
            }];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark tabViewDelegate
- (void)changeTabClike:(int)indexTag
{
    if ([gouMaiArray count]>0) {
        [gouMaiArray removeAllObjects];
    }
    [bottomView updateNumLabel:[NSString stringWithFormat:@"%d",[gouMaiArray count]]];
    
    NSLog(@"changeTabClike%d",indexTag);
    switch (indexTag) {
        case 0:
        {
            
            [self showTable:tiYanDanTable];
            [tiYanDanTable mainRefresh];
            
        }
            break;
        case 1:
        {
            [self showTable:tiYanCheTable];
            [tiYanCheTable mainRefresh];
            
        }
            break;
        case 2:
        {
            [self showTable:onLineTable];
            [onLineTable mainRefresh];
            
            
        }
            break;
        case 3:
        {
            [self showTable:didTiYanTable];
            [didTiYanTable mainRefresh];
            
        }
            break;
        case 4:
        {
            [self showTable:shouCangTable];
            [shouCangTable mainRefresh];
            
            
        }
            break;
        case 5:
        {
            [self showTable:historyTable];
            [historyTable mainRefresh];
            
            
        }
            break;
        default:
            break;
    }
    
    
}
#pragma mark bottomDelegate
- (void)clikeTasteEvent{
    if ([gouMaiArray count]==0) {
        Alert(@"请选择商品");
        return;
    }
    switch (tabView.indexSel) {
        case 0:case 2:
        {
            NSMutableArray *arrayDataId = [NSMutableArray array];
            for (NSDictionary *dic in gouMaiArray) {
                [arrayDataId addObject:[dic objectForKey:@"order_detail_id"]];
            }
            [GJsonCenter WuAdian_order_experience:arrayDataId jsonDelegate:self];
            [self paoLoading:@"请稍后"];
            
        }
            break;
        case 1:{
            NSMutableArray *arrayData = [NSMutableArray array];
            for (NSDictionary *dic in gouMaiArray) {
                NSMutableDictionary *tempdic = [NSMutableDictionary dictionary];
                [tempdic setObject:[dic objectForKey:@"cart_id"] forKey:@"cart_id"];
                [tempdic setObject:[[dic objectForKey:@"product_detail"] objectForKey:@"sku_id"] forKey:@"sku_id"];
                [tempdic setObject:[dic objectForKey:@"sku_qty"] forKey:@"sku_qty"];
                [tempdic setObject:[dic objectForKey:@"size"] forKey:@"size"];
                [arrayData addObject:tempdic];
                
            }
            [GJsonCenter wuAdian_pad_cartexperience:arrayData jsonDelegate:self];
            [self paoLoading:@"请稍后"];
            
            
        }
            break;
        case 3:case 5:case 4:
        {
            
            
        }
            break;
        default:
            break;
    }
    
    
    
}
- (void)clikeShoppingEvent{
    if ([gouMaiArray count]==0) {
        Alert(@"请选择商品");
        return;
    }
    switch (tabView.indexSel) {
        case 1:
        {
            
            
            NSLog(@"gouMaiArray====%@",gouMaiArray);
            ADPurchaseViewController *con = [[ADPurchaseViewController alloc]init];
            [appDelegate setBarAddLeftDelegate:con];
            con.isOrderType = NO;
            con.dataArray = [NSMutableArray arrayWithArray:gouMaiArray];
            [self.navigationController pushViewController:con animated:YES];
            [con release];
            
        }
            break;
        case 0:case 3:
        {
            
            ADPurchaseViewController *con = [[ADPurchaseViewController alloc]init];
            con.isOrderType = YES;
            [appDelegate setBarAddLeftDelegate:con];
            con.dataArray = [NSMutableArray arrayWithArray:gouMaiArray];
            [self.navigationController pushViewController:con animated:YES];
            [con release];
            
            return;
            
        }
            break;
        default:
            break;
    }
    
}
-(void) clickCell:(id)sender
{
    switch (tabView.indexSel) {
        case 1:
        {
            
            ADProductCell *cell = (ADProductCell *)sender;
            [cell setSelImage];
            if (cell.isSel==YES) {
                [gouMaiArray addObject:cell.cellData];
            }else{
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:gouMaiArray];
                for (NSDictionary *dic in tempArray) {
                    if ([[dic objectForKey:@"cart_id"] isEqualToString:[cell.cellData objectForKey:@"cart_id"]]) {
                        [gouMaiArray removeObject:dic];
                    }
                }
            }
            NSLog(@"gouMaiArray====%@",gouMaiArray);
            
            
        }
            break;
        case 3:
        {
            
            ADProductCell *cell = (ADProductCell *)sender;
            [cell setSelImage];
            if (cell.isSel==YES) {
                [gouMaiArray addObject:cell.cellData];
            }else{
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:gouMaiArray];
                for (NSDictionary *dic in tempArray) {
                    if ([[dic objectForKey:@"order_detail_id"] isEqualToString:[cell.cellData objectForKey:@"order_detail_id"]]) {
                        [gouMaiArray removeObject:dic];
                    }
                }
            }
            NSLog(@"gouMaiArray====%@",gouMaiArray);
            
        }
            break;
        case 0:case 2:
        {
            ADOrderCell *cell = (ADOrderCell *)sender;
            [cell setSelImage];
            if (cell.isSel==YES) {
                [gouMaiArray addObject:cell.cellData];
            }else{
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:gouMaiArray];
                for (NSDictionary *dic in tempArray) {
                    if ([[dic objectForKey:@"order_detail_id"] isEqualToString:[cell.cellData objectForKey:@"order_detail_id"]]) {
                        [gouMaiArray removeObject:dic];
                    }
                }
            }
            
            
        }
            break;
        default:
            break;
            
    }
    
    [bottomView updateNumLabel:[NSString stringWithFormat:@"%d",[gouMaiArray count]]];
}

- (void)removeTTTIndex:(int )dataCell
{
    [shouCangTable removeCell:dataCell];
    for (int i = 0;i < [shouCangTable.dataArray count]; i++) {
        ADProductCell *cell = (ADProductCell *)[shouCangTable.dataArray objectAtIndex:i];
        cell.indexCell = i;
    }
    [shouCangTable reloadCell];
}


@end
