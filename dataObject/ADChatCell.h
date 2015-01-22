//
//  ADChatCell.h
//  ADianTaste
//
//  Created by 陈 超 on 14-5-5.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "GDataObject.h"

@interface ADChatCell : GDataObject
{

    BOOL isSelfUser;
    
}
@property (nonatomic,assign)BOOL isSelfUser;
@end
