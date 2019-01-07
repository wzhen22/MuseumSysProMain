//
//  SwTool.m
//  MuseumSysPro
//
//  Created by admin on 2019/1/7.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import "SwTool.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation SwTool

//时间戳字符串转时间字符串
+(NSString *)timestampToDate:(double)timestamp DateFormat:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

//时间转字符串
+(NSString *)dateToString:(NSDate *)theDate DateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate:theDate];
    
    return dateString;
}

//字符串转时间
+(NSDate *)stringToDate:(NSString *)string DateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
    
    return date;
}

//字符串转 时间戳
+(double )stringToTimestamp:(NSString *)string DateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
    NSTimeInterval dateTime = [date timeIntervalSince1970];
    return dateTime;
}


//时间减天数
+(NSString *)dateDecDays:(NSInteger)day DateFormat:(NSString *)format
{
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
    double doub=(double)(nowtime-day*24*3600);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:doub];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

//时间加天数
+(NSString *)dateAddDays:(NSInteger)day DateFormat:(NSString *)format
{
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
    double doub=(double)(nowtime+day*24*3600);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:doub];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

//时间间隔
+(NSString *)intervalSinceNow:(NSString *)theDate DateFormat:(NSString *)format
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    NSDate *d=[formatter dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[date timeIntervalSince1970]*1;
    NSString *timeString;
    NSTimeInterval cha=now-late;
    
    if (cha/60<1)
    {
        if (cha<=6)
        {
            timeString = @"刚刚";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString = [NSString stringWithFormat:@"%@秒前", timeString];
        }
    }
    else if (cha/60>1&&cha/3600<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
    }
    else if (cha/3600>1&&cha/86400<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
    }
    else if (cha/86400>1&&cha/864000<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@天前", timeString];
    }
    else
    {
        NSArray *array = [theDate componentsSeparatedByString:@" "];
        timeString = [array objectAtIndex:0];
    }
    
    return timeString;
}

//获取当前星期几，返回整形
+(NSInteger)getWeek
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:date];
    
    return [comps weekday];
}

//获取当前星期几，返回字符串
+(NSString *)getWeeks:(NSInteger)week
{
    NSString *weeks = nil;
    
    switch (week)
    {
        case 1:
            weeks = @"星期天";
            break;
            
        case 2:
            weeks = @"星期一";
            break;
            
        case 3:
            weeks = @"星期二";
            break;
            
        case 4:
            weeks = @"星期三";
            break;
            
        case 5:
            weeks = @"星期四";
            break;
            
        case 6:
            weeks = @"星期五";
            break;
            
        case 7:
            weeks = @"星期六";
            break;
            
        default:
            break;
    }
    
    return weeks;
}

//设置控件圆角边框
+(void)setWidgetRim:(id)widget cornerRadius:(float)radius rimLine:(BOOL)tags
{
    CALayer *roundCorner = [widget layer];
    [roundCorner setMasksToBounds:YES];
    [roundCorner setCornerRadius:radius];
    
    if (tags)
    {
        [roundCorner setBorderColor:[UIColor darkGrayColor].CGColor];
        [roundCorner setBorderWidth:0.6];
    }
}

//对象截取
+(NSRange)rangeMake:(NSInteger)location length:(NSInteger)len
{
    NSRange range;
    range.location = location;
    range.length = len;
    
    return range;
}

//UIColor 转换为 UIImage
+(UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

//获取文件后缀名
+(NSString *)theNameSuffix:(NSString *)fileName
{
    NSArray *array = [fileName componentsSeparatedByString:@"."];
    if ([array count] >= 2)
    {
        NSString *fileType = [array objectAtIndex:[array count]-1];
        return fileType;
    }
    else
    {
        return fileName;
    }
}

//获取本地视频缩略图
+(UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return thumb;
}

//创建本地文件夹
+(void)createVideoDir
{
    NSString *documents_path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *categoryPath = [documents_path stringByAppendingPathComponent:@"video"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:categoryPath])
    {
        [manager createDirectoryAtPath:categoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

//获取本地文件大小
+(uint64_t)getFileSize:(NSString *)filePath
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSDictionary  * dict = [fileManager attributesOfItemAtPath:filePath error:nil];
    
    return [dict fileSize];
}

//获取本地视频长度
+ (CGFloat)getLocalVedioTimeScaleWithURL:(NSURL *)fileURL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *  urlAsset = [AVURLAsset URLAssetWithURL:fileURL options:opts];  // 初始化视频媒体文件
    //    CGFloat minute  = 0;
    CGFloat second = 0;
    
    second = CMTimeGetSeconds(urlAsset.duration); // 获取视频总时长,单位秒
    
    if (second == 0) {
        second = 1;
    }
    //    if (second >= 60) {
    //        int index   = second / 60;
    //        minute      = index;
    //        second      = second - index*60;
    //    }
    return second;
}

//判断字符串是否为空
+(NSString *)stringWithObj:(NSString *)obj
{
    if (obj == nil)
    {
        return @"";
    }
    
    if (obj == NULL)
    {
        return @"";
    }
    
    if ([obj isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    
    //    if ([[obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] <= 0) {
    //        return @"";
    //    }
    
    return [NSString stringWithFormat:@"%@",obj];
}

//判断一段字符串只包含数字
+(NSInteger)NSStringToInt:(NSString *)string
{
    // NSString *regex = @"^[A-Za-z]+[0-9]+[A-Za-z0-9]*|[0-9]+[A-Za-z]+[A-Za-z0-9]*$";//判断一段字符串只包含字母和数字
    NSString *regex = @"^[0-9]*$";//判断一段字符串只包含数字
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([[self stringWithObj:string] isEqual:@""])
    {
        return 0;
    }
    else
    {
        if ([predicate evaluateWithObject:string] == YES)
        {
            return [string intValue];
        }
        else
        {
            return 0;
        }
    }
}

//MD5加密
+(NSString *)encodeMD5:(NSString *)string
{
    const char *original_str = [string UTF8String];
    if (original_str == NULL)
        original_str = "";
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (uint32_t)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
}

//ftp地址格式
+(NSURL *)smartURLForString:(NSString *)string
{
    NSURL       *result;
    NSString    *trimmedStr;
    NSRange     schemeMarkerRange;
    NSString    *scheme;
    
    assert(string != nil);
    
    result = nil;
    
    trimmedStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) )
    {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound)
        {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"ftp://%@", trimmedStr]];
        }
        else
        {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"ftp"  options:NSCaseInsensitiveSearch] == NSOrderedSame) )
            {
                result = [NSURL URLWithString:trimmedStr];
            }
            else
            {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }
    NSLog(@"url---> %@", result);
    return result;
}

//利用正则表达式验证邮箱的合法性
+(BOOL)validateEmail:(NSString *)email;
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//判断设备型号
+(NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad mini 3 (WLAN)";
    
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2 (WLAN)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

//UITableView隐藏多余的分割线
+(void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//UIImage缩小
+(UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL)isValidEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    //    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
/*des 加密  解密*/
+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOperation == kCCDecrypt)
    {
        NSData *decryptData = [GTMBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];
        //NSData *decryptData = [GTMBase64 decodeString:sText ];
        plainTextBufferSize = [decryptData length];
        vplainText = [decryptData bytes];
    }
    else
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [encryptData length];
        vplainText = (const void *)[encryptData bytes];
    }
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    NSString *initVec = @"12345678";
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    const void *vkey = (const void *) [key UTF8String];
    
    CCCryptorStatus ccStatus = CCCrypt(encryptOperation,
                                       kCCAlgorithm3DES,
                                       kCCOptionPKCS7Padding,
                                       vkey,
                                       kCCKeySize3DES,
                                       vinitVec,
                                       vplainText,
                                       plainTextBufferSize,
                                       (void *)bufferPtr,
                                       bufferPtrSize,
                                       &movedBytes);
    NSLog(@"%d",ccStatus);
    NSString *result = nil;
    if (ccStatus == kCCSuccess)
    {
        if (encryptOperation == kCCDecrypt)
        {
            result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding] ;
        }
        else
        {
            NSData *data = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
            result = [GTMBase64 stringByEncodingData:data];
            // NSLog(@"result:%@",result);
            // NSData *temp = [GTMBase64 decodeString:result];
        }
    }
    return result;
}

+ (NSString *)encryptDESWithText:(NSString *)sText theKey:(NSString *)aKey
{
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:aKey];
}

+ (NSString *)decryptDESWithText:(NSString *)sText theKey:(NSString *)aKey
{
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:aKey];
}
//获取手机IP地址
+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}
#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}
+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}
+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
//二进制转换为十六进制的方法
+(NSString *) parseByte2HexString:(Byte *) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            i++;
        }
        
    }
    //     NSLog(@"bytes 的16进制数为:%@",hexStr);
    return hexStr;
}
//ipv4Url转换为域名地址的url
+(NSString *)becomeDomainUrl:(NSString *)ipUrlString{
    if (ipUrlString.length <2) {
        return @"";
    }
    NSString *DomainUrlString;
    NSRange subRange1 = [ipUrlString rangeOfString:@"//"];
    NSString *urlString = [ipUrlString substringFromIndex:subRange1.location+2];
    NSLog(@"urlString:%@",urlString);
    NSRange subRange2 = [urlString rangeOfString:@"/"];
    NSString *urlString2 = [urlString substringToIndex:subRange2.location];
    NSLog(@"urlString2:%@",urlString2);
    NSArray *dataArray = [urlString2 componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    if (dataArray.count) {
        NSString *subSdd = [dataArray objectAtIndex:0];
        NSScanner* scan = [NSScanner scannerWithString:subSdd];
        int val;
        BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
        if (isNum) {
            //做对应的域名url替换
            //hwrss.cbg.cn     219.153.252.34
            if ([urlString2 isEqualToString:@"219.153.252.34"]) {
                NSMutableString *muString = [[NSMutableString alloc]initWithString:ipUrlString];
                [muString replaceCharactersInRange:NSMakeRange(subRange1.location+2, urlString2.length) withString:@"hwrrs.cbg.cn"];
                DomainUrlString = muString;
            }else{
                DomainUrlString = ipUrlString;
            }
            
        }else{
            DomainUrlString = ipUrlString;
        }
    }else{
        DomainUrlString = ipUrlString;
    }
    NSLog(@"DomainUrlString:%@",DomainUrlString);
    return DomainUrlString;
}

//ipv4Url转换为数字地址的url
+(NSString *)becomeNumUrl:(NSString *)ipUrlString{
    NSString *numUrlString;
    NSRange subRange1 = [ipUrlString rangeOfString:@"//"];
    NSString *urlString = [ipUrlString substringFromIndex:subRange1.location+2];
    NSLog(@"urlString:%@",urlString);
    NSRange subRange2 = [urlString rangeOfString:@"/"];
    NSString *urlString2 = [urlString substringToIndex:subRange2.location];
    NSLog(@"urlString2:%@",urlString2);
    NSArray *dataArray = [urlString2 componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    if (dataArray.count) {
        NSString *subSdd = [dataArray objectAtIndex:0];
        NSScanner* scan = [NSScanner scannerWithString:subSdd];
        int val;
        BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
        if (isNum) {
            //做对应的数字url替换
            NSString *subUrl = [self ipv4ToIntNum:urlString2];
            NSMutableString *muString = [[NSMutableString alloc]initWithString:ipUrlString];
            [muString replaceCharactersInRange:NSMakeRange(subRange1.location+2, urlString2.length) withString:subUrl];
            numUrlString = muString;
        }else{
            numUrlString = ipUrlString;
        }
    }
    NSLog(@"numUrlString:%@",numUrlString);
    return numUrlString;
}
//ipv4地址转为数字地址的方法
+(NSString *)ipv4ToIntNum:(NSString *)ipString{
    NSString *intNum;
    NSArray *dataArray = [ipString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    NSMutableString *erString = [[NSMutableString alloc]initWithCapacity:10];//二进制字符
    for (long i = 0; i<dataArray.count; i++) {
        NSString *ipSubStr = [dataArray objectAtIndex:i];
        ipSubStr = [self toBinarySystemWithDecimalSystem:ipSubStr];
        NSLog(@"ipSubStr:%@",ipSubStr);
        [erString appendString:ipSubStr];
    }
    //把二进制字符转为十进制字符
    NSLog(@"erString:%@",erString);
    intNum = [self toDecimalSystemWithBinarySystem:erString];
    NSLog(@"intNum:%@",intNum);
    return intNum;
}
//  十进制转八位的二进制数
+ (NSString *)toBinarySystemWithDecimalSystem:(NSString *)decimal
{
    int num = [decimal intValue];
    int remainder = 0;      //余数
    int divisor = 0;        //除数
    
    NSString * prepare = @"";
    
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%d",remainder];
        
        if (divisor == 0)
        {
            break;
        }
    }
    
    NSString * result = @"";
    for (long i = prepare.length - 1; i >= 0; i --)
    {
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    //补满8位
    if (result.length <8) {
        NSInteger iNum = result.length;
        for (int i = 0; i<8-iNum; i++) {
            result = [NSString stringWithFormat:@"%d%@",0,result];
        }
    }
    return result;
}
//  二进制转十进制
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary
{
    long long ll = 0 ;
    long long  temp = 0 ;
    for (long i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    
    NSString * result = [NSString stringWithFormat:@"%lld",ll];
    
    return result;
}
+(NSString *) parseByteArray2HexString:(Byte[]) bytes

{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            i++;
        }
    }
    NSLog(@"bytes 的16进制数为:%@",hexStr);
    return hexStr;
}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**  是否超时 1:beforeTime是未来的时间点 0:过去 */
+ (BOOL )CalculateTimeIntervalBeforeTimeString:(NSString *)beforeTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *lastDate = [dateFormatter dateFromString:beforeTime];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval start = [lastDate timeIntervalSince1970]*1;
    NSTimeInterval end = [currentDate timeIntervalSince1970]*1;
    NSTimeInterval value = start  - end;
    
    if (value >0) {
        value = 1;
    }else{
        value = 0;
    }
    
    return value;
}

//QM计算时间差
+ (NSString *)qmToCalculateTimeIntervalBeforeTimeString:(NSString *)beforeTime {
    //上次时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *lastDate = [dateFormatter dateFromString:beforeTime];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval start = [lastDate timeIntervalSince1970]*1;
    NSTimeInterval end = [currentDate timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    return [NSString stringWithFormat:@"%f",value];
}
//调整图片方向
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


+ (NSTimeInterval)qm_dataString:(NSString *)dataString andFormatString:(NSString *)format {
    //    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    //    [formatter setLocale:[NSLocale currentLocale]];
    //    [formatter setDateFormat:@"HH:mm:ss"];
    //    NSDate *d=[formatter dateFromString:dataString];
    //    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSArray * secondArray = [dataString componentsSeparatedByString:@":"];
    NSInteger timeTotle = 0;
    for (NSInteger i = 0; i < secondArray.count; i ++) {
        switch (i) {
            case 0:
                if (secondArray.count > 2) {
                    timeTotle = timeTotle +[secondArray[i] integerValue] * 3600;
                }else{
                    timeTotle = timeTotle +[secondArray[i] integerValue] * 60;
                }
                break;
            case 1:
                if (secondArray.count >2) {
                    timeTotle = timeTotle +[secondArray[i] integerValue] * 60;
                }else{
                    timeTotle = timeTotle +[secondArray[i] integerValue];
                }
                break;
            case 2:
                break;
            default:
                break;
        }
    }
    return timeTotle;
}


@end
