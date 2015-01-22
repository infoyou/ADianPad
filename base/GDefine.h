#import "ADAppDelegate.h"

//#define HOST_URL                    @"http://bpotest.5adian.com/tiyandian_test/5aframework/src/init/index.php"
#define HOST_URL                    @"http://www.5adian.com:5902/index.php"
#define PRODUCT_URL                 @"http://112.124.46.131:5902"

//#define HOST_URL                    @"http://112.124.46.131:7000/index.php"
//#define PRODUCT_URL                 @"http://weixin.violet.com.cn:5902"
#define WEIXIN_PAY                  @"http://weixin.violet.com.cn"

#define GP_CustomID @"ITC_01"
#define GP_Variant @"cic_cots"
#define AppServerLang @"zh-chs" // @"en-us"
#define URLENCODEDCONTENT @"application/x-www-form-urlencoded"
#define Application_Server_Language LTXT(KDes_ServerLanguage)
#define KDesNoNetAlert @"NoNetAlert"

#define UITextAlignmentCenter NSTextAlignmentCenter

//#define presentModalViewController
//#define dismissModalViewControllerAnimated

#define KSinaAppKey @"4129790283"
#define KSinaAppSecret @"f625dd47024c1ede53314fa995c917e3"
#define KSinaAppRedirectURI @"https://api.weibo.com/oauth2/default.html"

#define KTencentAPPID @"100335158"
#define KTencentAPPKEY @"f947cba654ff028860fa8e662b644dbf"
//#define KTencentAPPID @"100440211"
//#define KTencentAPPKEY @"fe6969bdb54e27f2a47fadd95a386668"

#define KWXAppID @"wx8a5f08dc5973f09e"
#define KWXAppKey @"ab8848d31c1a37a9beacbcd9f24c1345"

#define kTriggerOffSet 60.0f
#define kleftAndRightWidth  218.0f

#define KUserAgent @"IPHONE_HY/%@ %@"
#define DisplayVersionNumber [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define PublishTime [[[NSBundle mainBundle] infoDictionary] objectForKey:@"PublishTime"]
#define IosVersion floorf([[[UIDevice currentDevice] systemVersion] floatValue])

#define APP [UIApplication sharedApplication]
#define appDelegate ((ADAppDelegate*)APP.delegate)
#define GAlertTitle [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define appActive ([APP applicationState] == UIApplicationStateActive)
#define CacheName(f) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:f]
#define DocName(f) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:f]

#define GSession appDelegate.session
#define GID appDelegate.uid
#define GLAT appDelegate.location.coordinate.latitude
#define GLON appDelegate.location.coordinate.longitude
#define GLAT2 appDelegate.location2.coordinate.latitude
#define GLON2 appDelegate.location2.coordinate.longitude

#define kMistakeFilePath ([[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Exception.txt"])

#define KClearColor [UIColor clearColor]
#define KWhiteColor [UIColor whiteColor]
#define KBlackColor [UIColor blackColor]
#define KGrayColor [UIColor grayColor]
#define KGray2Color [UIColor lightGrayColor]
#define KBlueColor [UIColor blueColor]
#define KRedColor [UIColor redColor]

#define KUrlTxtColor Color(18,168,221)
#define Color(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define ColorA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]
#define ColorI(c) [UIColor colorWithRed:((c>>16)&0xff)/255.0 green:((c>>8)&0xff)/255.0 blue:(c&0xff)/255.0 alpha:1.0] // ColorI(0xbfbfbf)
#define ColorGray(f) [UIColor colorWithWhite:f/255.0 alpha:1.0]
#define ColorGrayA(f,a) [UIColor colorWithWhite:f/255.0 alpha:a/1.0]
#define Font(s) [UIFont systemFontOfSize:s]
#define FontBold(s) [UIFont boldSystemFontOfSize:s]
#define txtLength(t,f,l) [t getWidth:f limit:l]

#define KScreenRect [[UIScreen mainScreen] bounds]
#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define KTabBarFrame CGRectMake(0.0, 460.0-49.0, 320.0, 49.0) // 568 vs 480
#define KContentHeight (KScreenHeight-20) // 568 vs 480
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending) // if(SYSTEM_VERSION_LESS_THAN(@"4.0")) ...
#define isIphone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define LOG     NSLog
#define LOGA(f) NSLog(@"%@",f)
#define LOGS(f) NSLog(@"%s",f)
#define LOGI(f) NSLog(@"%d",f)
#define LOGF(f) NSLog(@"%f",f)
#define LogClass NSLog(@"in -- class: %@",self.class)
#define LOGFUN NSLog(@"%s | %d",__FUNCTION__,__LINE__)
#define LOGFUN3 NSLog(@"%s | %d | %s",__FILE__,__LINE__,__FUNCTION__)
#define LogRect2(rect) NSLog(@"rect x:%f y:%f w:%f h:%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height)
#define LogSign NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
#define LogRect(rect) NSLog(@"%@",NSStringFromCGRect(rect))
#define LogPt(pt) NSLog(@"%@",NSStringFromCGPoint(pt))
#define LogSize(size) NSLog(@"%@",NSStringFromCGSize(size))

#define DEL(f) { if(f!=nil) [f release]; f=nil; }
#define ReleaseTable(f) { if(f != nil) { f.delegate = nil; f.dataSource = nil; [f release]; f = nil;  } }
#define KCanCamera [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
#define FileExsit(name) [[NSFileManager defaultManager] fileExistsAtPath:name]
#define SHOW(m) [self.view buildQiaoTips2:m]
#define Alert(f) SHOW(f)
#define Alert0(f) [GUtil alert:(f)]
#define AlertNetError Alert(LTXT(PP_ConnectTimeOut))

#define GP_AlertTitle NSLocalizedString(@"TKN_ALERT_TIP", @"")

#define IsMan [appDelegate.gender isEqualToString:@"M"]
#define UseBigImage appDelegate.useBigImage
#define BigImageLen 640
#define LiteImageLen 320

#define LTXT(s) NSLocalizedString(@"" #s "",@"")
#define IMG(s) [UIImage imageNamed:@"" #s ".png"]
#define IMG0(s) [UIImage imageNamed:s]
//#define IMGW(s) [WebPImage loadWebPFromFile:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],@"" #s ".webp"]]
//#define IMGW0(s) [WebPImage loadWebPFromFile:s]
#define Str(s) (s==nil ? @"" : s)
#define StrNull(f) (f==nil || ![f isKindOfClass:[NSString class]] || ([f isKindOfClass:[NSString class]] && [f isEqualToString:@""]))
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f) (StrValid(f) ? f:@"")
#define HasString(str,eky) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]] && [f count]>0)
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidLat (GLAT!=0)

#define Landing_Processing NSLocalizedString(@"PP_LANDING_PROCESSING", @"NO_Contacts")
#define DataStr(str) [str dataUsingEncoding:NSUTF8StringEncoding]
#define StrData(data) [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]

#define KQiqoEventUrlKey @"__qe.add"
#define QiaoEventUrl(url) [NSString stringWithFormat:@"%@%@",url,KQiqoEventUrlKey]

#define SF(f) [NSString stringWithFormat:@"%@",f]
#define SFI(f) [NSString stringWithFormat:@"%d",f]
#define SFF(f) [NSString stringWithFormat:@"%f",f]
#define Replace(s,a,b) [s stringByReplacingOccurrencesOfString:a withString:b]
#define UrlEncode(s) [(NSString*)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)s,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8) autorelease]
#define UrlDecode2(s) [[[[[s \
stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"] \
stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"] \
stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"] \
stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""] \
stringByReplacingOccurrencesOfString:@"&apos;" withString:@"|'"]

#define KSecond_Year    31536000
#define KSecond_Week    604800
#define KSecond_Day     86400
#define KSecond_Hour    3600
#define KSecond_Minute  60

#define KJsonHttpHeaderSendLength 370
#define KJsonHttpHeaderRecvLength 260
#define KImageHttpHeaderSendLength 260
#define KImageHttpHeaderRecvLength 260

#define KNavStatusHeight 20
#define KNavBarHeight 44
#define KNavBarHeightOff 0 // 1.5
#define KBottomHeight 49

#define KNavTitleTop 7
#define KNavTitleLeft 68 // 56
#define KNavTitleWidth 180 // 204
#define KNavTitleFont FontBold(18) // FontBold(20)

#define KNavLeftBtnRect CGRectMake(6, 8, 28, 27)
#define KNavRightBtnRect CGRectMake(269, 9, 50, 30)
#define KPathContentWidth 280
#define KCameraBarHeight 56

#define KTxtLineHeight 20
#define KC_CELL_LINE Color(241,241,241)
#define KTableFootHeight 50
#define KTableFootMoreY 8
#define KTableFootIndicatorY 12
#define KTableFootTipY 13

#define KImageUploadLen 616
#define KImageLiteLen 200
#define KJpgQuality 0.8
#define KJpgLiteQuality 0.3
#define kWebpQuality 80

#define KOffsetArrow 12
#define KOffsetTips 10

#define KSendPhotoMaxSecond    10

#define KListGetNum @"5"
#define KListAppendNum @"5"
#define KTimeLimit 30
#define KCommentCountLimit 3
#define KCommentTagOffset 3540
#define KCommentHeadTagOffset 3530
#define KCommentNameTagOffset 3520
#define KCommentTimeTagOffset 3510
#define KVolumeHeight 20

#define KLeftGImageTagOffset 3640
#define KLeftTimeLabelTagOffset 3740
#define KLeftTimeBGTagOffset 3840
#define KLeftPlayBtnTagOffset 3940


#define KColorListBg ColorGray(238)
#define KColorListSelect ColorGray(219)
#define KColorFindBg Color(231,231,231)
#define KColorPlayLine Color(50,60,233)
#define kTitleColor [UIColor colorWithRed:46.0/255.0 green:46.0/255.0 blue:46.0/255.0 alpha:1.0]
#pragma mark - for view tag
// ------------------------------------------------
#define KTagGImageView  1188

#define KLimitLen sizeof(int)*1000

#define Shadow(lab,color,size) lab.shadowColor=color; lab.shadowOffset=size
#define SetShadow(lab) Shadow(lab,KBlackColor,CGSizeMake(0, -1.5))

#define AlertBar(msg) [appDelegate asynchronousOperationStatusBar:1 changeLabel:msg]
#define AlertBar2(msg) [appDelegate asynchronousOperationStatusBar:0 changeLabel:msg]

#define KMaxLeftMessageCount 50
#define KMaxLeftMessageUnReadCount 500
#define KPhotoDisplay 19191
#define KPhotoBGDisplay 19192

// 动态获取设备参数SCREEN_WIDTH
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//for new font
#define kSubDisplayFont10 [UIFont systemFontOfSize:10]
#define kDisplayFont12 [UIFont systemFontOfSize:12]
#define kDisplayFont14 [UIFont systemFontOfSize:14]
#define kDisplayFont14Bold [UIFont boldSystemFontOfSize:14]
#define kDisplayFont16 [UIFont systemFontOfSize:16]
#define kBoldFont16 [UIFont boldSystemFontOfSize:16]
#define kTabBarFont [UIFont boldSystemFontOfSize:14]
#define kTitleFont [UIFont boldSystemFontOfSize:15]
#define kTipFont [UIFont systemFontOfSize:14]
#define kInputFont [UIFont systemFontOfSize:14]
#define kBoldFont13 [UIFont boldSystemFontOfSize:13]
#define kBoldFont34 [UIFont boldSystemFontOfSize:34]


//for paopaoxiu font
#define kCellNameFont kBoldFont16
#define kCellBigTextFont kDisplayFont16
#define kCellTextFont kDisplayFont14
#define kCellTimeFont kDisplayFont12


#define KTransformString(str) if(![str isKindOfClass:[NSString class]]){DEL(str)}

#define KTransformStringEmpty(str) if(![str isKindOfClass:[NSString class]] || [str length]<=0){str = @"";}

#define KPTxtMainMuneCellColor ColorGray(208)
#define KPTxtDeepGray ColorGray(88)
#define KPTxtLightGray ColorGray(176)
#define KPTxtGreenColor Color(56,127,61)
#define KPTableHeadTextColor Color(98,60,0)

#define kPPTabViewItemImage @"kPPTabViewItemImage"
#define kPPTabViewItemImageSel @"kPPTabViewItemImageSel"

#define kCellNameColor Color(88,88,88)
#define kCellTextColor ColorGray(176)

#define KLimitInput 300

#define KCommentLinkTextColor [UIColor colorWithRed:71/255.0 green:110/255.0 blue:150/255.0 alpha:1.0]

#define KPageBackgroundColor [UIColor whiteColor]

#define KPhotoListDatabaseName @"%@photodatabase.sqlite"

#define KShareSheetTag  11100000

#define kMessageGoodListFilePath ([[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"%@messageGoodListFile.plist"])

#define kMessageCommentListFilePath ([[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"%@messageCommentListFile.plist"])

#define kShareSnsListFilePath ([[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"%@shareSNSListFile.plist"])



#define KAppVersion @"1.0.0220"

#define KDingdanCellHeight 70
#define KDingdanCell2Height 110

#define KUserDicKey @"UserDicKey"
#define KBarBackColor [UIColor colorWithRed:231.0/255.0 green:111.0/255.0 blue:27.0/255.0 alpha:1.0]
#define KLeftViewBackColor [UIColor colorWithRed:216.0/255.0 green:236.0/255.0 blue:225.0/255.0 alpha:1.0]
#define KBarWidthF 50.0
#define ios7H ((appDelegate.iosVersion>=7.0)?20:0)
#define IsIos7Version ((appDelegate.iosVersion>=7.0)?YES:NO)
#define KLeftWidthStoreViewW 200
#ifndef UIStatusBarStyleLightContent
#define UIStatusBarStyleLightContent 1
#endif
#define KBarViewTag 8902
#define KLeftViewTag 2830
#define KGreenTitleColor [UIColor colorWithRed:24.0/255.0 green:137.0/255.0 blue:66.0/255.0 alpha:1.0]
#define KPeopleInfoViewHeiht 110
#define KMainBottomViewH 110
#define KMainMiddleH (KScreenWidth-ios7H-KBarWidthF-KPeopleInfoViewHeiht-58+9.0-KMainBottomViewH)
#define KMainMiddleW (KScreenHeight-KLeftWidthStoreViewW-20)
#define KProductCellH KMainMiddleH/4.0
#define KProductCellW KMainMiddleW-4
#define KSystemBlue [UIColor colorWithRed:21.0/255.0 green:93.0/255.0 blue:171.0/255.0 alpha:1.0]
#define KSystemYellow [UIColor colorWithRed:231.0/255.0 green:111.0/255.0 blue:27.0/255.0 alpha:1.0]
#define KCellBackColr [UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0]
#define KCellTitleBackColr [UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1.0]


