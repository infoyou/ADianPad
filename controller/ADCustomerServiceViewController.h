//
//  ADCustomerServiceViewController.h
//  ADianTaste
//
//  Created by 陈 超 on 14-5-4.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "GController.h"
#import "GTableViewV2.h"
#import "ADCustomerCell.h"

@interface ADCustomerServiceViewController : GController<GTableViewDelegate,clickCustomerCellDelegate,UITextViewDelegate>
{
    GTableViewV2 *customerList;
    GTableViewV2 *chatList;
    NSString *member_id_single;
    NSString *open_id_single;
    NSString *corporation_member_id_single;
    NSString *message_id_id_single;
    UILabel *addWhoLabel;
    UITextView *contentTextView;

}
@property (nonatomic,retain)NSString *member_id_single;
@property (nonatomic,retain)NSString *open_id_single;
@property (nonatomic,retain)NSString *corporation_member_id_single;
@property (nonatomic,retain)NSString *message_id_id_single;
-(void)rollTable;
@end
