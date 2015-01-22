//
//  ADTabView.h
//  ADianTaste
//
//  Created by Keil on 14-3-5.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol changeTabDelegate;
@interface ADTabView : UIView
{

    NSMutableArray *dataTitle;
    NSMutableArray *btnArray;
    id <changeTabDelegate> delegate;
    int indexSel;
}
@property (nonatomic,assign)id <changeTabDelegate> delegate;
@property (nonatomic,assign)int indexSel;

- (void)setIndex:(int)tagDex;
@end


@protocol changeTabDelegate <NSObject>

- (void)changeTabClike:(int)indexTag;

@end