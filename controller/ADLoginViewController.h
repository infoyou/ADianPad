//
//  ADLoginViewController.h
//  ADianTaste
//
//  Created by 陈 超 on 14-2-27.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GController.h"

@interface ADLoginViewController : GController<UITextFieldDelegate>
{
}

-(void) getNetData:(NSDictionary *)dict withItem:(JsonRequestItem *)item;

@end
