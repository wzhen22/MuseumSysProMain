//
//  SwTool.h
//  MuseumSysPro
//
//  Created by admin on 2019/1/7.
//  Copyright © 2019年 cbg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "sys/utsname.h"
#import "CommonCrypto/CommonDigest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SwTools : NSObject

/**
 *  时间戳字符串转时间字符串
 */
+(NSString *)timestampToDate:(double)timestamp DateFormat:(NSString *) format;

/**
 *  时间转字符串
 */
+(NSString *)dateToString:(NSDate *)theDate DateFormat:(NSString *)format;

/**
 *  时间减天数
 */
+(NSString *)dateDecDays:(NSInteger)day DateFormat:(NSString *)format;

/**
 *  //当前时间加天数
 *
 *  @param day    dayString
 *  @param format @"yyyy-MM-dd HH:mm:ss"]
 *
 *  @return 加过后的时间
 */
+(NSString *)dateAddDays:(NSInteger)day DateFormat:(NSString *)format;

/**
 *  //字符串转时间
 *
 *  @param string 时间String
 *  @param format 格式 @"yyyy-MM-dd HH:mm:ss"]
 *
 *  @return NSDtate
 */
+(NSDate *)stringToDate:(NSString *)string DateFormat:(NSString *)format;

//字符串转 时间戳
+(double )stringToTimestamp:(NSString *)string DateFormat:(NSString *)format;

/**
 *  时间间隔
 *
 *  @param theDate string型时间
 *  @param format  格式 @"yyyy-MM-dd HH:mm:ss"]
 *
 *  @return 间隔string
 */
+(NSString *)intervalSinceNow: (NSString *)theDate DateFormat:(NSString *)format;

/**
 *  //获取当前星期几，返回整形
 *
 *  @return nsinterger
 */
+(NSInteger)getWeek;

/**
 *  //获取当前星期几，返回字符串
 *
 *  @param week getWeek
 *
 *  @return string
 */
+(NSString *)getWeeks:(NSInteger)week;

/**
 *  //设置控件圆角边框
 *
 *  @param widget 设置对象
 *  @param radius radius
 *  @param tags   是否边框
 */
+(void)setWidgetRim:(id)widget cornerRadius:(float)radius rimLine:(BOOL)tags;

/**
 *  //对象截取
 *
 *  @param location 起始
 *  @param len      长度
 *
 *  @return NSRange
 */
+(NSRange)rangeMake:(NSInteger)location length:(NSInteger)len;

/**
 *  //UIColor 转换为 UIImage
 *
 *  @param color color
 *
 *  @return UIimage
 */
+(UIImage *)createImageWithColor:(UIColor *)color;

/**
 *  //获取文件后缀名
 *
 *  @param fileName 文件名
 *
 *  @return 后缀
 */
+(NSString *)theNameSuffix:(NSString *)fileName;

/**
 *  //加载
 *
 *  @param hud
 *  @param view
 *  @param frame
 *
 *  @return
 */
//+(MBProgressHUD *)initHUD:(MBProgressHUD *)hud andView:(UIView *)view andFrame:(CGRect)frame;

/**
 *  //获取本地视频缩略图
 *
 *  @param videoURL 文件地址
 *
 *  @return uiimage
 */
+(UIImage *)getImage:(NSString *)videoURL;

/**
 *  //创建本地文件夹Vedio
 */
+(void)createVideoDir;

/**
 *  //获取本地文件大小
 *
 *  @param filePath the path of file
 *
 *  @return 文件大小
 */
+(uint64_t)getFileSize:(NSString *)filePath;


/**
 *  获取本地视频大小
 */
+ (CGFloat)getLocalVedioTimeScaleWithURL:(NSURL *)fileURL;

/**
 *  //判断字符串是否为空
 *
 *  @param obj string
 *
 *  @return string
 */
+ (NSString *)stringWithObj:(NSString *)obj;

/**
 *  //判断一段字符串只包含数字
 *
 *  @param string string
 *
 *  @return
 */
+(NSInteger)NSStringToInt:(NSString *)string;

/**
 *  //MD5加密
 *
 *  @param string string
 *
 *  @return 加密后String
 */
+(NSString *)encodeMD5:(NSString *)string;

/**
 *  //ftp地址格式
 *
 *  @param string
 *
 *  @return
 */
+(NSURL *)smartURLForString:(NSString *)string;

/**
 *  //利用正则表达式验证邮箱的合法性
 *
 *  @param email
 *
 *  @return BOOL
 */
+(BOOL)validateEmail:(NSString *)email;

/**
 *  //判断设备型号
 *
 *  @return 设备号
 */
+(NSString *)getCurrentDeviceModel;

/**
 *  //UITableView隐藏多余的分割线
 *
 *  @param tableView tableview
 */
+(void)setExtraCellLineHidden:(UITableView *)tableView;

/**
 *  //UIImage缩小
 *
 *  @param img  img
 *  @param size min  size
 *
 *  @return uiimage
 */
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

/**
 *  邮箱验证 MODIFIED BY HELENSONG
 *
 *  @param email email
 *
 *  @return BOOL
 */
+(BOOL)isValidEmail:(NSString *)email;

/**
 *  电话验证
 *
 *  @param mobile number
 *
 *  @return BOOL
 */
+(BOOL)isValidMobile:(NSString *)mobile;
/**
 *  des 加密 解密
 *
 *  @param
 *
 *  @return NSString
 */
+ (NSString *)encryptDESWithText:(NSString *)sText theKey:(NSString *)aKey;
+ (NSString *)decryptDESWithText:(NSString *)sText theKey:(NSString *)aKey;
/**
 *  des 获取ip地址
 *
 *  @param
 *
 *  @return NSString
 */
+ (NSString *)deviceIPAdress;
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

//二进制转换十六进制的方法
+(NSString *) parseByte2HexString:(Byte *) bytes;
+(NSString *) parseByteArray2HexString:(Byte[]) bytes;
//  二进制转十进制
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary;
//  十进制转二进制
+ (NSString *)toBinarySystemWithDecimalSystem:(NSString *)decimal;
//ipv4地址转为数字地址的方法
+(NSString *)ipv4ToIntNum:(NSString *)ipString;
//ipv4Url转换为数字地址的url
+(NSString *)becomeNumUrl:(NSString *)ipUrlString;
//ipv4Url转换为域名地址的url
+(NSString *)becomeDomainUrl:(NSString *)ipUrlString;
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**  是否超时 */
+ (BOOL )CalculateTimeIntervalBeforeTimeString:(NSString *)beforeTime;

/*!
 * @QM     计算两时间差值
 */
+ (NSString *)qmToCalculateTimeIntervalBeforeTimeString:(NSString *)beforeTime;
/**
 *  调整图片方向
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

//时间转换成秒
+ (NSTimeInterval)qm_dataString:(NSString *)dataString andFormatString:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
