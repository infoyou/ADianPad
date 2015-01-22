//
//  ADRecentPeopleViewController.m
//  ADianTaste
//
//  Created by Keil on 14-3-10.
//  Copyright (c) 2014年 Keil. All rights reserved.
//

#import "ADRecentPeopleViewController.h"
#import "GDefine.h"
#import "ADSessionInfo.h"
#import "GJsonCenter.h"
#import "ADPeopleCell.h"
#import "ADMainViewController.h"
#import "ADCustomerServiceViewController.h"
#import "ADRecentPeopleViewController.h"
#import "ADOnlineBuyViewController.h"

@interface ADRecentPeopleViewController ()

@end

@implementation ADRecentPeopleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)dealloc
{
    recentPeopleTable.tableDelegate = nil;
    [recentPeopleTable release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+12, KBarWidthF+16+ios7H, 16, 16)];
    iconImage.image = IMG(xiaolian);
    [self.view addSubview:iconImage];
    [iconImage release];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+12+20.0, KBarWidthF+16+ios7H, 200, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"用户信息";
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(KLeftWidthStoreViewW+12, KBarWidthF+ios7H+20+16+2, KMainMiddleW, 4)];
    lineView.backgroundColor = KSystemBlue;
    [self.view addSubview:lineView];
    [lineView release];
    
    recentPeopleTable = [[GTableViewV2 alloc] initWithFrame:CGRectMake(KLeftWidthStoreViewW, KBarWidthF+ios7H+20+16+8, KScreenHeight-KLeftWidthStoreViewW, KScreenWidth-KBarWidthF-ios7H-20-16-8)];
    recentPeopleTable.tableDelegate=self;
    [recentPeopleTable setEndOfTable:YES];
    recentPeopleTable.backgroundColor=KClearColor;
    recentPeopleTable.separatorColor = KClearColor;
    [recentPeopleTable removeFreshHeader];
    [recentPeopleTable rebuildFreshHeaderWithWidth:KScreenHeight-KLeftWidthStoreViewW];
    [self.view addSubview:recentPeopleTable];
    [recentPeopleTable mainRefresh];
}
#pragma mark baseDelagate
-(NSArray*) reloadTableWithData:(NSString *)param
{
    [GJsonCenter wuAdian_pad_scanlist:@"1" num:@"6" store_id:[ADSessionInfo sharedSessionInfo].store_id jsonDelegate:self].custom = @"yes";
    return nil;
}

-(NSArray*) loadMoreTableFrom:(NSString*)index withNum:(NSString*)num andParam:(NSString*)param
{
    NSString *offset = [NSString stringWithFormat:@"%d",[recentPeopleTable.dataArray count]+1];
    [GJsonCenter wuAdian_pad_scanlist:offset num:@"6" store_id:[ADSessionInfo sharedSessionInfo].store_id jsonDelegate:self].custom = @"no";
    return nil;
}

-(void) getNetData:(NSDictionary*)data withItem:(JsonRequestItem*)item
{

    if ([[data objectForKey:@"rsp"] intValue]==1) {
        NSRange rang = [item.custom rangeOfString:@"yes"];
        if(rang.length > 0)
        {
            [recentPeopleTable.dataArray removeAllObjects];
        }
        if ([[[data objectForKey:@"data"] objectForKey:@"has_next"] intValue]==1) {
            [recentPeopleTable setEndOfTable:NO];
        } else {
            [recentPeopleTable setEndOfTable:YES];
        }
        if ([[[data objectForKey:@"data"] objectForKey:@"lists"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *dataArray = [[data objectForKey:@"data"] objectForKey:@"lists"];
            for (NSDictionary *dic in dataArray) {
                ADPeopleCell *cell = [[ADPeopleCell alloc] initWithDict:dic];
                [recentPeopleTable appendCell:cell];
                [cell release];
            }
            [recentPeopleTable loadNormalStatus];
            [recentPeopleTable reloadCell];
        }
    }else{
        [recentPeopleTable loadNormalStatus];

    }

}

-(void) jsonRequestFailed:(JsonRequestItem*)item
{
    [recentPeopleTable loadNormalStatus];
}

-(void) clickCell:(id)sender
{
    ADPeopleCell *cell = (ADPeopleCell *)sender;
    if (cell) {
        [ADSessionInfo sharedSessionInfo].member_id_string = [[cell.cellData objectForKey:@"member"] objectForKey:@"member_id"];
        for (UIViewController *con in self.navigationController.viewControllers) {
            if ([con isKindOfClass:[ADMainViewController class]]) {
                ADMainViewController *mainCon = (ADMainViewController *)con;
                [mainCon getCustomerInfo];
                [appDelegate resumeBarView];
                [self.navigationController popToViewController:mainCon animated:YES];
            }
        }
    }
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
//
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

                
                ADCustomerServiceViewController *con = [[ADCustomerServiceViewController alloc]init];
                [appDelegate setBarAddLeftDelegate:con];
                [appDelegate.navController pushViewController:con animated:NO];
                [con release];
                
            
            
//            ADCustomerServiceViewController *con = [[ADCustomerServiceViewController alloc] init];
//            [appDelegate setBarAddLeftDelegate:con];
//            [self.navigationController pushViewController:con animated:YES];
//            [con release];
            
        }
            break;
        case 2:
        {
//            ADRecentPeopleViewController *con = [[ADRecentPeopleViewController alloc] init];
//            [appDelegate setBarAddLeftDelegate:con];
//            [self.navigationController pushViewController:con animated:YES];
//            [con release];

            
        }
            break;
        case 3:
        {
            if ([[[appDelegate.navController viewControllers] lastObject] isKindOfClass:[self class]]) {
                [appDelegate loginOut];
            }
            
        }
            break;
        default:
            break;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
