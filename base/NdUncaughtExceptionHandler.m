
#import "NdUncaughtExceptionHandler.h"
#import "NSString_Extras.h"
#import "GDefine.h"
#import "GUtil.h"
#import "ADAppDelegate.h"

@implementation NdUncaughtExceptionHandler

NSString* applicationDocumentsDirectory()
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

void UncaughtExceptionHandler(NSException* exception)
{
    NSArray *arr=[exception callStackSymbols];
    NSString *reason=[exception reason];
    NSString *name=[exception name];
    NSLog(@"我执行了");
    NSLog(@"reason%@",reason);
    NSLog(@"name%@",name);
    NSString *platfrom=[appDelegate platform];
    NSString *ios=[[UIDevice currentDevice] systemVersion];

    NSString *url=[NSString stringWithFormat:@"=============异常崩溃报告=============\niosVersion:%@\nuserAgent:%@\nplatform:%@\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",ios,[GUtil getUserAgent],platfrom,name,reason,[arr componentsJoinedByString:@"\n"]];
    
    NSString *path=kMistakeFilePath;
    NSLog(@"sdnf\\\%@",path);
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"我请求到的数据%@",[NSString stringWithContentsOfFile:path usedEncoding:nil error:nil]);
}

+(void) setDefaultHandler
{
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
}

+(NSUncaughtExceptionHandler*) getHandler
{
    return NSGetUncaughtExceptionHandler();
}

@end
