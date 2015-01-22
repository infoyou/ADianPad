//
//  ADCustomerServiceViewController.m
//  ADianTaste
//
//  Created by 陈 超 on 14-5-4.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADCustomerServiceViewController.h"
#import "ADMainViewController.h"
#import "GDefine.h"
#import "ADRecentPeopleViewController.h"
#import "ADSessionInfo.h"
#import "GJsonCenter.h"
#import "ADChatCell.h"
#import "UIView_Extras.h"
#import "ADOnlineBuyViewController.h"

#define KCustomerListKey @"CustomerListKey"
#define KChatListKey @"ChatListKey"


@interface ADCustomerServiceViewController ()

@end

@implementation ADCustomerServiceViewController
@synthesize member_id_single;
@synthesize open_id_single;
@synthesize corporation_member_id_single;
@synthesize message_id_id_single;
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

    customerList.extendDelegate = nil;
    [customerList release];
    chatList.extendDelegate = nil;
    [chatList release];
    self.member_id_single = nil;
    self.open_id_single =nil;
    self.corporation_member_id_single = nil;
    self.message_id_id_single = nil;
    [contentTextView release];
    [super dealloc];
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
        UIView *view = (UIView *)[self.view viewWithTag:456];
        [UIView animateWithDuration:animationDuration animations:^{
            view.frame = CGRectMake(KLeftWidthStoreViewW+12+250, KBarWidthF+ios7H+102.0+(KScreenWidth-KBarWidthF-ios7H-20-16-40-100)-352-50.0, 520.0, 60.0);
        }];
        chatList.frame = CGRectMake(KLeftWidthStoreViewW+12+250, KBarWidthF+ios7H+102.0, 520.0, KScreenWidth-KBarWidthF-ios7H-20-16-40-100-352-50);
//        [self rollTable];
    }else{
        UIView *view = (UIView *)[self.view viewWithTag:456];
        [UIView animateWithDuration:animationDuration animations:^{
            view.frame = CGRectMake(KLeftWidthStoreViewW+12+250, KBarWidthF+ios7H+102.0+(KScreenWidth-KBarWidthF-ios7H-20-16-40-100)-352, 520.0, 60.0);
        }];
        chatList.frame = CGRectMake(KLeftWidthStoreViewW+12+250, KBarWidthF+ios7H+102.0, 520.0, KScreenWidth-KBarWidthF-ios7H-20-16-40-100-352);
//        [self rollTable];

    }


	
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.member_id_single = @"";
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+12, KBarWidthF+16+ios7H, 16, 16)];
    iconImage.image = IMG(customer_service);
    [self.view addSubview:iconImage];
    [iconImage release];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+12+20.0, KBarWidthF+16+ios7H, 200, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"在线客服";
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+12, KBarWidthF+ios7H+20+16+2, KMainMiddleW, 4)];
    lineView.backgroundColor = KSystemBlue;
    [self.view addSubview:lineView];
    [lineView release];
    
    UIImageView *tableFirstTitle = [[UIImageView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+12+40+50.0, KBarWidthF+ios7H+72.0-40.0+15.0, 150.0, 40)];
    tableFirstTitle.image = [[UIImage imageNamed:@"tabSelNew.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
    [self.view addSubview:tableFirstTitle];
    [tableFirstTitle release];
    
    UIImageView *iconImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(150-18.0-5.0, (40 -18.0)/2.0, 18.0, 18.0)];
    iconImage2.image = IMG(chat_icon1);
    [tableFirstTitle addSubview:iconImage2];
    [iconImage2 release];
    
    UILabel *labelIcon = [[UILabel alloc]initWithFrame:CGRectMake(0, (40-25.0)/2.0, 150-18.0-5.0, 25.0)];
    labelIcon.text = @"未读消息";
    labelIcon.textColor = [UIColor whiteColor];
    labelIcon.backgroundColor = [UIColor clearColor];
    labelIcon.font = [UIFont systemFontOfSize:20.0];
    labelIcon.textAlignment = NSTextAlignmentRight;
    [tableFirstTitle addSubview:labelIcon];
    [labelIcon release];
    

    
    customerList = [[GTableViewV2 alloc] initWithFrame:CGRectMake(KLeftWidthStoreViewW+12, KBarWidthF+ios7H+72.0+15.0, 240.0, KScreenWidth-KBarWidthF-ios7H-20-16-50-15.0)];
    customerList.tableDelegate=self;
    customerList._contentType = KCustomerListKey;
    [customerList setEndOfTable:YES];
    customerList.backgroundColor=KClearColor;
    customerList.separatorColor = KClearColor;
    [customerList removeFreshHeader];
    [customerList rebuildFreshHeaderWithWidth:240.0];
    [self.view addSubview:customerList];
    [customerList mainRefresh];
    
    UIView *backTab = [[UIView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+12+250, KBarWidthF+ios7H+102.0, 520.0, KScreenWidth-KBarWidthF-ios7H-20-16-40-100)];
    backTab.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0];
    [self.view addSubview:backTab];
    [backTab release];
    

//    [addWhoLabel release];
    
    chatList = [[GTableViewV2 alloc] initWithFrame:CGRectMake(KLeftWidthStoreViewW+12+250, KBarWidthF+ios7H+102.0, 520.0, KScreenWidth-KBarWidthF-ios7H-20-16-40-100)];
    chatList.tableDelegate=self;
    chatList._contentType = KChatListKey;
    [chatList setEndOfTable:YES];
    chatList.backgroundColor=[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0];
    chatList.separatorColor = KClearColor;
    [chatList removeFreshHeader];
    [chatList rebuildFreshHeaderWithWidth:520.0];
    [self.view addSubview:chatList];

//    [chatList mainRefresh];
    
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+12+250, KBarWidthF+ios7H+102.0+(KScreenWidth-KBarWidthF-ios7H-20-16-40-100), 520.0, 60.0)];
    bottomView.tag = 456;
    [self.view addSubview:bottomView];
    [bottomView release];
    
    
    UIImageView *inputView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 350.0, 60.0)];
    inputView.image = [UIImage imageNamed:@"chat_text_rect.png"];
    [bottomView addSubview:inputView];
    [inputView release];
    
    contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(5.0, 5.0, 340.0, 50)];
    contentTextView.delegate = self;
    contentTextView.font = [UIFont systemFontOfSize:20.0];
    contentTextView.textAlignment = NSTextAlignmentLeft;
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.textColor = [UIColor blackColor];
    [bottomView addSubview:contentTextView];
    
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(inputView.frame.origin.x+350.0, inputView.frame.origin.y, 170.0, 60.0);
    [sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setImage:[UIImage imageNamed:@"chat_send.png"] forState:UIControlStateNormal];
    [bottomView addSubview:sendButton];
    
    
    
    UIImageView *imageTable2 = [[UIImageView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+12+250, KBarWidthF+ios7H+102.0-40.0, 520.0, 40)];
    imageTable2.image = [[UIImage imageNamed:@"tabSelNew.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
    [self.view addSubview:imageTable2];
    [imageTable2 release];
    
    
    
    addWhoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 520.0-20.0, 20.0)];
    //    addWhoLabel.text = @"未读消息";
    addWhoLabel.textColor = [UIColor whiteColor];
    addWhoLabel.backgroundColor = [UIColor clearColor];
    addWhoLabel.font = [UIFont systemFontOfSize:20.0];
    addWhoLabel.textAlignment = NSTextAlignmentLeft;
    [imageTable2 addSubview:addWhoLabel];

    
	// Do any additional setup after loading the view.
}
-(void)sendMessage
{
    [self paoLoading:@"请稍后"];
    [contentTextView resignFirstResponder];
    if (contentTextView.text == nil||[contentTextView.text isEqualToString:@""]) {
        Alert(@"发送内容不能为空！！");
        return;
    }
    [GJsonCenter wuadian_message_send:self.corporation_member_id_single message_id:self.message_id_id_single open_id:self.open_id_single content:contentTextView.text jsonDelegate:self];



}
-(void)animationButtomView:(BOOL)isUp
{
    float y = 0;
    if (isUp) {
        y = KBarWidthF+ios7H+102.0+(KScreenWidth-KBarWidthF-ios7H-20-16-40-100)-352;
    }else{
        y = KBarWidthF+ios7H+102.0+(KScreenWidth-KBarWidthF-ios7H-20-16-40-100);
    }
    UIView *view = (UIView *)[self.view viewWithTag:456];
   [UIView animateWithDuration:0.2 animations:^{
    view.frame = CGRectMake(KLeftWidthStoreViewW+12+250, y, 520.0, 60.0);
    }];
    if (isUp) {
        chatList.frame = CGRectMake(KLeftWidthStoreViewW+12+250, KBarWidthF+ios7H+102.0-352, 520.0, KScreenWidth-KBarWidthF-ios7H-20-16-40-100);
    }else{
          chatList.frame = CGRectMake(KLeftWidthStoreViewW+12+250, KBarWidthF+ios7H+102.0, 520.0, KScreenWidth-KBarWidthF-ios7H-20-16-40-100);
    
    }

}
#pragma mark baseDelagate
-(NSArray*) reloadTableWithData:(NSString *)param
{
    if ([param isEqualToString:KCustomerListKey]) {
       [GJsonCenter wuadian_message_getcontactlist:[ADSessionInfo sharedSessionInfo].corporation_member_id offset:@"0" num:@"100" jsonDelegate:self].custom = @"yes";
    }else if ([param isEqualToString:KChatListKey]){
        NSString *offset = [NSString stringWithFormat:@"%d",[chatList.dataArray count]];
        [GJsonCenter wuadian_message_getconversationlist:offset num:@"100" server_id:[ADSessionInfo sharedSessionInfo].corporation_member_id member_id:self.member_id_single open_id:self.open_id_single jsonDelegate:self];
    
    }

    return nil;
}

-(NSArray*) loadMoreTableFrom:(NSString*)index withNum:(NSString*)num andParam:(NSString*)param
{
    if ([param isEqualToString:KChatListKey]){
        return nil;
    }

    NSString *offset = [NSString stringWithFormat:@"%d",[customerList.dataArray count]];
    [GJsonCenter wuadian_message_getcontactlist:[ADSessionInfo sharedSessionInfo].corporation_member_id offset:offset num:@"9" jsonDelegate:self].custom = @"no";
    return nil;
}

-(void) getNetData:(NSDictionary*)data withItem:(JsonRequestItem*)item
{
    
    if([item.type isEqualToString:@"wuadian_message_getcontactlist"])
    {
    
        if ([[data objectForKey:@"rsp"] intValue]==1) {
            
            NSRange rang = [item.custom rangeOfString:@"yes"];
            if(rang.length > 0)
            {
                [customerList.dataArray removeAllObjects];
            }
            if ([[[data objectForKey:@"data"] objectForKey:@"has_next"] intValue]==1) {
                [customerList setEndOfTable:NO];
            } else {
                [customerList setEndOfTable:YES];
            }
            
            if ([[[data objectForKey:@"data"] objectForKey:@"lists"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *dataArray = [[data objectForKey:@"data"] objectForKey:@"lists"];
                self.member_id_single = [[[dataArray objectAtIndex:0] objectForKey:@"member_summary"] objectForKey:@"member_id"];
                self.open_id_single = [[dataArray objectAtIndex:0] objectForKey:@"open_id"];
                self.corporation_member_id_single = [[dataArray objectAtIndex:0] objectForKey:@"corporation_member_id"];
                self.message_id_id_single = [[dataArray objectAtIndex:0] objectForKey:@"id"];
                addWhoLabel.text = [NSString stringWithFormat:@"与%@的对话",[[[dataArray objectAtIndex:0]  objectForKey:@"member_summary"] objectForKey:@"nick_name"]];
                for (int i = 0;i<[dataArray count];i++) {
                    ADCustomerCell *cell = [[ADCustomerCell alloc] initWithDict:[dataArray objectAtIndex:i]];
                    cell.delegate = self;
                    if (rang.length > 0) {
                        if (i==0) {
                            
                            cell.isYes = NO;
                        }else{
                            cell.isYes = YES;
                        }
                    }else{
                        cell.isYes = YES;

                    }
           
                    [customerList appendCell:cell];
                    [cell release];
                }
                [customerList loadNormalStatus];
                [customerList reloadCell];
                if (rang.length > 0) {
                    [self performSelector:@selector(getChatList) withObject:nil afterDelay:0.5];

                }
 

            }
            
            
            
            
            
            
        }else{
            [customerList loadNormalStatus];
        }
    
    
    }else if([item.type isEqualToString:@"wuadian_message_getconversation"]){
        if ([[data objectForKey:@"rsp"] intValue]==1) {
            NSRange rang = [item.custom rangeOfString:@"yes"];
            if(rang.length > 0)
            {
                [chatList.dataArray removeAllObjects];
            }
            if ([[[data objectForKey:@"data"] objectForKey:@"lists"] isKindOfClass:[NSArray class]]) {
            
                NSMutableArray *dataArray = [[data objectForKey:@"data"] objectForKey:@"lists"];
                for (int i = [dataArray count]-1;i>0;i--) {
                    ADChatCell *cell = [[ADChatCell alloc] initWithDict:[dataArray objectAtIndex:i]];
                    if ([[[dataArray objectAtIndex:i] objectForKey:@"fromuser"] isEqualToString:@"1"]) {
                        cell.isSelfUser = YES;
                    }else if([[[dataArray objectAtIndex:i] objectForKey:@"fromuser"] isEqualToString:@"2"]){
                        cell.isSelfUser = NO;
                    }
                    [chatList insetCell:cell];
                    [cell release];
                }
                [chatList loadNormalStatus];
                [chatList reloadCell];
                if ([chatList.dataArray count]>0) {
                    [self rollTable];
                }
  
            
            }
        
        
        
        }else{
            [chatList loadNormalStatus];

            NSLog(@"%@",[[data objectForKey:@"msg"] objectForKey:@"115001"]);
        }
    
    
    
    
    }else if ([item.type isEqualToString:@"wuadian_message_send"]){
        [self paoCancelLoading];
        if ([[data objectForKey:@"rsp"] intValue]==1) {
            if ([[[data objectForKey:@"data"] objectForKey:@"is_success"] boolValue]) {
//                [chatList.dataArray removeAllObjects];
                ADChatCell *cell = [[ADChatCell alloc] initWithDict:[data objectForKey:@"data"]];
                if ([[[data objectForKey:@"data"] objectForKey:@"fromuser"] isEqualToString:@"1"]) {
                    cell.isSelfUser = YES;
                }else if([[[data objectForKey:@"data"] objectForKey:@"fromuser"] isEqualToString:@"2"]){
                    cell.isSelfUser = NO;
                }
                [chatList appendCell:cell];
                [cell release];
                [chatList loadNormalStatus];
                [chatList reloadCell];
                [self performSelectorOnMainThread:@selector(rollTable) withObject:nil waitUntilDone:YES];
                contentTextView.text = @"";

            }
        }else{
            if ([[data objectForKey:@"msg"] isKindOfClass:[NSString class]]) {
                Alert([data objectForKey:@"msg"]);

            }else{
            
                Alert(@"发送失败！！！！");

            }

        }
        

    }


}
-(void)rollTable
{
    id lastOject = [chatList.dataArray lastObject];
    
    int indexOfLastRow = [chatList.dataArray indexOfObject:lastOject];
    
    [chatList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexOfLastRow inSection:0]
     
                              atScrollPosition:UITableViewScrollPositionBottom
     
                                      animated:NO];
    

}
-(void)getChatList
{
    [chatList.dataArray removeAllObjects];
    if ([self.member_id_single isEqualToString:@""]==NO) {
        [chatList mainRefresh];
    }

}
-(void) jsonRequestFailed:(JsonRequestItem*)item
{
    [customerList loadNormalStatus];
    
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
- (void)changeClikeEvent:(int)indexTag
{

    switch (indexTag) {
        case 0:
        {

  
                ADOnlineBuyViewController *con = [[ADOnlineBuyViewController alloc]init];
                [appDelegate setBarAddLeftDelegate:con];
                [appDelegate.navController pushViewController:con animated:NO];
                [con release];
                
            
        }
            break;
        case 1:
        {
            
//            ADCustomerServiceViewController *con = [[ADCustomerServiceViewController alloc] init];
//            [appDelegate setBarAddLeftDelegate:con];
//            [self.navigationController pushViewController:con animated:YES];
//            [con release];
            
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
- (void)clikeCustomerCellId:(NSString *)memberId open_id:(NSString *)open_id_str
{
    self.member_id_single = memberId;
    self.open_id_single = open_id_str;
    for (ADCustomerCell *cell in customerList.cellDataArray) {
        if ([[[cell.cellData objectForKey:@"member_summary"] objectForKey:@"member_id"] isEqualToString:memberId]) {
            addWhoLabel.text = [NSString stringWithFormat:@"与%@的对话",[[cell.cellData objectForKey:@"member_summary"] objectForKey:@"nick_name"]];
            self.corporation_member_id_single = [cell.cellData objectForKey:@"corporation_member_id"];
            self.message_id_id_single = [cell.cellData objectForKey:@"id"];
            [cell hiddenBack:NO];
        }else{
            [cell hiddenBack:YES];

        }
        
    }
    
    [self getChatList];

}
-(void) listScrolled
{
    if ([contentTextView isFirstResponder]) {
        [contentTextView resignFirstResponder];

    }
}
#pragma mark textDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{

//    [self animationButtomView:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView{

    [self animationButtomView:NO];


}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
