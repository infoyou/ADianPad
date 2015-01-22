//
//  ADOrderFormCell.h
//  ADianTaste
//
//  Created by Keil on 14-3-12.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "GDataObject.h"
#import "ADProductBottomView.h"
@protocol orderProductSelDelegate <NSObject>

@optional

-(void)selCellProduct:(NSMutableDictionary *)dic isDelete:(BOOL)selFlag;
@end
@interface ADOrderFormCell : GDataObject<bottomEventDelgegate,orderProductSelDelegate>
{
    

}

@end

@protocol orderProductSelDelegate;
@interface ADOrderProduct : UIView
{
    NSMutableDictionary *dataDic;
    id <orderProductSelDelegate> delegate;
    BOOL isSelFlag;
    NSMutableArray *arrayCell;
    

}
@property (nonatomic,retain)NSMutableDictionary *dataDic;
@property (nonatomic,assign)id <orderProductSelDelegate> delegate;
@property (nonatomic,assign)BOOL isSelFlag;
@property (nonatomic,retain)NSMutableArray *arrayCell;
- (void)creatViewCell:(NSMutableDictionary *)productData;
@end

