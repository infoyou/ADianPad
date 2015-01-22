//
//  ADRecentPeopleViewController.h
//  ADianTaste
//
//  Created by Keil on 14-3-10.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "GController.h"
#import "GTableViewV2.h"
@interface ADRecentPeopleViewController : GController<GTableViewDelegate>
{
    GTableViewV2 *recentPeopleTable;

}
@end
