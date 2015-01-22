//
//  ADProductBottomView.h
//  ADianTaste
//
//  Created by Keil on 14-3-12.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol bottomEventDelgegate;
@interface ADProductBottomView : UIView
{

    id <bottomEventDelgegate> delegate;

}
@property (nonatomic,assign)id <bottomEventDelgegate> delegate;
- (void)createBottomView;
- (void)hiddenTiyanBtn:(BOOL)isHidden;
- (void)updateNumLabel:(NSString *)numString;
@end


@protocol bottomEventDelgegate <NSObject>

@optional

- (void)clikeTasteEvent;
- (void)clikeShoppingEvent;

@end
