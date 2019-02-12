//
//  MuPubMacros.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/7.
//  Copyright © 2019年 cbg. All rights reserved.
//

#ifndef MuPubMacros_h
#define MuPubMacros_h

// 应用程序托管
#define AppDelegateInstance                            ((AppDelegate*)([UIApplication sharedApplication].delegate))

#define isIOS11 [[UIDevice currentDevice].systemVersion floatValue] >= 11
#define isIOS7 [[UIDevice currentDevice].systemVersion floatValue] >= 7
//
#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX kScreenWidth >=375.0f && kScreenHeight >=812.0f&& kIs_iphone

/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
/*导航栏高度*/
#define kNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(kIs_iPhoneX?(88.0):(64.0))
/*TabBar高度*/
#define kTabBarHeight (CGFloat)(kIs_iPhoneX?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
/*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight (CGFloat)(kIs_iPhoneX?(24.0):(0))
/*导航条和Tabbar总高度*/
#define kNavAndTabHeight (kNavBarAndStatusBarHeight + kTabBarHeight)

//请求超时时间
#define HTTPTimeoutInterval 20.0f
//获取图片资源
#define GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//在Main线程上运行
#define DISPATCH_ON_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//在Global Queue上运行
#define DISPATCH_ON_GLOBAL_QUEUE_HIGH(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), globalQueueBlocl);
#define DISPATCH_ON_GLOBAL_QUEUE_DEFAULT(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);
#define DISPATCH_ON_GLOBAL_QUEUE_LOW(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), globalQueueBlocl);
#define DISPATCH_ON_GLOBAL_QUEUE_BACKGROUND(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), globalQueueBlocl);

// 其它的宏定义
#ifdef DEBUG
#define                                         LOG(...) NSLog(__VA_ARGS__)
#define                                         LOG_METHOD NSLog(@"%s", __func__)
#define                                         LOGERROR(...) NSLog(@"%@传入数据有误",__VA_ARGS__)
#define SysBDebudLog(...) NSLog(__VA_ARGS__)
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define                                         LOG(...)
#define                                         LOG_METHOD
#define                                         LOGERROR(...) NSLog(@"%@传入数据有误",__VA_ARGS__)
#define SysBDebudLog(...)
#define NSLog(...)
#endif

///当前日期字符串
#define DATE_STRING \
({NSDateFormatter *fmt = [[NSDateFormatter alloc] init];\
[fmt setDateFormat:@"YYYY-MM-dd hh:mm:ss"];\
[fmt stringFromDate:[NSDate date]];})

///------ <强烈推荐❤️>替换NSLog使用，debug模式下可以打印很多方法名、行信息(方便查找)，release下不会打印 ------
#ifdef DEBUG
//-- 区分设备和模拟器,
//解决Product -> Scheme -> Run -> Arguments -> OS_ACTIVITY_MODE为disable时，真机下 Xcode Debugger 不打印的bug ---
#if TARGET_OS_IPHONE
/*iPhone Device*/
#define DLog(format, ...) printf("%s:Dev: %s [Line %d]\n%s\n\n", [DATE_STRING UTF8String], __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
/*iPhone Simulator*/
#define DLog(format, ...) NSLog((@":Sim: %s [Line %d]\n%@\n\n"), __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:format, ##__VA_ARGS__])
#endif
#else
#define DLog(...)
#endif

//屏幕宽度、大小以及对比
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
//十六进制颜色值
#define ColorFromHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ColorFromHexRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

/**  颜色值 */
#define MainTitleColor      ColorFromHexRGB(0x111111) //主标题
#define SubTitleColor       ColorFromHexRGB(0x666666) //次标题
#define WhiteColor          ColorFromHexRGB(0xffffff)    //whiteColor
#define ListViewBackColor   ColorFromHexRGB(0xf0f0f0)    //列表背景 相对下面更淡
#define SeparatorColor      ColorFromHexRGB(0xe6e6e6)    //分割线
#define MarkLabelBackColor  ColorFromHexRGBA(0x000000,0.7) // 标签的背景
#define MainThemeRedColor   ColorFromHexRGB(0xea292a) //红色主题色
#define MainThemeBlueColor  ColorFromHexRGB(0x148aff) //蓝色主题色

///------ 有效性验证<字符串、数组、字典等> ------
#define VALID_STRING(str)      ((str) && ([(str) isKindOfClass:[NSString class]]) && ([(str) length] > 0))
#define VALID_ARRAY(arr)       ((arr) && ([(arr) isKindOfClass:[NSArray class]]) && ([(arr) count] > 0))
#define VALID_DICTIONARY(dict) ((dict) && ([(dict) isKindOfClass:[NSDictionary class]]) && ([(dict) count] > 0))
#define VALID_NUMBER(number)   ((number) && ([(number) isKindOfClass:NSNumber.class]))


//---------------------------------------------------------------------------------------------------------
#define DOCUMENTS_PATH      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]    //itunes 会同步
#define CACHES_PATH         [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]      //不会同步
#define LIBRARY_PATH        [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]     //会同步 配置信息
#define TEMP_PATH           NSTemporaryDirectory() // 临时文件 程序运行期间
//---------------------------------------------------------------------------------------------------------

//版本号
#define VersionAPP [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]


//#define BASE_HTTP_SERVER (@"http://inspection.museum.cqcztech.com")
#define BASE_HTTP_SERVER (@"http://inspection.chinamuseum.cn")
//测试地址：http://inspection.museum.cqcztech.com/login
//正式地址：http://inspection.chinamuseum.cn/login
#endif /* MuPubMacros_h */
