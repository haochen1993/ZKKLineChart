//
//  ACMacros.h
//


#ifndef ACMacros_h
#define ACMacros_h

#import "UIView+Addition.h"
#import "MCStockChartUtil.h"

#define KeyboardAnimationCurve  7 << 16

//** 沙盒路径 ***********************************************************************************
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define KLineTextColor_Gray HexRGB(0x606b76)

/* ****************************************************************************************************************** */
/** DEBUG LOG **/
#ifdef DEBUG

#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define DLog( s, ... )

#endif

#define KLineColor_Green  HexRGB(0x26e27e)
#define KLineColor_Red    HexRGB(0xcb292e)
#define GlobalColor_Blue  HexRGB(0x2187c9)
#define GlobalBGColor_Dark  HexRGB(0x292c34)

/** DEBUG RELEASE **/
#if DEBUG

#define MCRelease(x)            [x release]

#else

#define MCRelease(x)            [x release], x = nil

#endif



#define IS_IPAD              (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA            ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH         [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT        [[UIScreen mainScreen] bounds].size.height
#define SCREEN_MAX_LENGTH    (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH    (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


#define IS_IPHONE_4          (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5          (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6          (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P         (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define ScreenScale         [UIScreen mainScreen].scale
#define userDefaults        [NSUserDefaults standardUserDefaults]
#define KeyWindow           [[[UIApplication sharedApplication] delegate] window]
#define WindowZoomScale     (SCREEN_WIDTH/320.f)
#define UniversalZoomScale  (MIN(1.8, WindowZoomScale))  //适配iPad

FOUNDATION_EXPORT NSString *NSDocumentPath();
FOUNDATION_EXPORT NSString *NSResourcePath();
FOUNDATION_EXPORT UIImage *UIImageNamed(NSString *imageName);

FOUNDATION_EXPORT UIColor *HexColor(unsigned int hexValue);
FOUNDATION_EXPORT UIColor *HexAlphaColor(unsigned int hexValue, float alpha);
FOUNDATION_EXPORT UIColor *RGBCOLOR(CGFloat read, CGFloat green, CGFloat blue);
FOUNDATION_EXPORT UIColor *RGBACOLOR(CGFloat read, CGFloat green, CGFloat blue, CGFloat alpha);

FOUNDATION_EXPORT BOOL SystemVersionEqualTo(NSString *version);
FOUNDATION_EXPORT BOOL SystemVersionGreaterThan(NSString *version);
FOUNDATION_EXPORT BOOL SystemVersionGreaterThanOrEqualTo(NSString *version);
FOUNDATION_EXPORT BOOL SystemVersionLessThan(NSString *version);
FOUNDATION_EXPORT BOOL SystemVersionLessThanOrEqualTo(NSString *version);
FOUNDATION_EXPORT UIFont *MCFontWithSize (CGFloat basePointSize);

#define XcodeBundleVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


#define _loginUser          [AuthData loginUser]
#define _applicationContext [ApplicationContext sharedContext]

#ifdef DEBUG
#define USTakeTimeCountBegin       NSDate *takeTimeCountDate = [NSDate date];
#define USTakeTimeCountEnd(flag)   DLOG(@"%@耗时 %.4f 秒",flag,[[NSDate date] timeIntervalSinceDate:takeTimeCountDate]);
#else
#define USTakeTimeCountBegin       ((void)0);
#define USTakeTimeCountEnd(flag)   ((void)0);
#endif

/**
 * Fixes colors in Storyboard and XIB files that are using the wrong colorspace
 *
 * find . \( -name "*.xib" -or -name "*.storyboard" \) -print0 | xargs -0 sed -i '' -e 's/colorSpace="custom" customColorSpace="sRGB"/colorSpace="calibratedRGB"/g'
 */

//获取随机数
#define Random(from, to) (int)(from + (arc4random() % (to - from + 1))) //+1,result is [from to]; else is [from, to)!!!!!!!
#define ARC4RANDOM_MAX (0x100000000 * 20)

// 注释掉 暂用YYKit
//#import <pthread.h>
///**
// Whether in main queue/thread.
// */
//static inline bool dispatch_is_main_queue() {
//    return pthread_main_np() != 0;
//}
//
///**
// Submits a block for asynchronous execution on a main queue and returns immediately.
// */
//static inline void dispatch_async_on_main_queue(void (^block)()) {
//    if (pthread_main_np()) {
//        block();
//    } else {
//        dispatch_async(dispatch_get_main_queue(), block);
//    }
//}
//
///**
// Submits a block for execution on a main queue and waits until the block completes.
// */
//static inline void dispatch_sync_on_main_queue(void (^block)()) {
//    if (pthread_main_np()) {
//        block();
//    } else {
//        dispatch_sync(dispatch_get_main_queue(), block);
//    }
//}
//
static inline void dispatch_after_on_main_queue(int64_t delayInSeconds, void (^block)()) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

// 去除方法调用警告
#define USPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0);


/** NIL RELEASE **/
#define NILRelease(x)           [x release], x = nil

//去掉leak warning
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)


/* ****************************************************************************************************************** */
#pragma mark - Frame (宏 x, y, width, height)

// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]

// App Frame Height&Width
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

// Screen adaptation to iphone6 as the standard
#define Screen_Adaptor_Scale    Main_Screen_Width/375.0f

#define Adaptor_Value(v)        (v)*Screen_Adaptor_Scale

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)


#define RECT_CHANGE_x(v,x)          CGRectMake(x, Y(v), WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_y(v,y)          CGRectMake(X(v), y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_point(v,x,y)    CGRectMake(x, y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_width(v,w)      CGRectMake(X(v), Y(v), w, HEIGHT(v))
#define RECT_CHANGE_height(v,h)     CGRectMake(X(v), Y(v), WIDTH(v), h)
#define RECT_CHANGE_size(v,w,h)     CGRectMake(X(v), Y(v), w, h)

// 系统控件默认高度
#define kStatusBarHeight        (20.f)

#define kTopBarHeight           (44.f)
#define kBottomBarHeight        (49.f)

#define kCellDefaultHeight      (44.f)

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)


/* ****************************************************************************************************************** */
#pragma mark - Funtion Method (宏 方法)

// PNG JPG 图片路径
#define PNGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME, EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

// 加载图片
#define PNGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define IMAGE(NAME, EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]

// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)    [UIFont boldSystemFontOfSize:FONTSIZE]

#define SYSTEMFONT(FONTSIZE)        [UIFont systemFontOfSize:FONTSIZE]

#define FONT(NAME, FONTSIZE)        [UIFont fontWithName:(NAME) size:(FONTSIZE)]

// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//number转String
#define IntTranslateStr(int_str) [NSString stringWithFormat:@"%d",int_str];
#define FloatTranslateStr(float_str) [NSString stringWithFormat:@"%.2d",float_str];

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES];\
                                [View.layer setBorderWidth:(Width)];\
                                [View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES]

// 当前版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])

// 当前语言
#define CURRENTLANGUAGE         ([[NSLocale preferredLanguages] objectAtIndex:0])

// 3.5英寸
#define is3Inch_Laters          [UIScreen mainScreen].bounds.size.height == 480
// 4英寸
#define is4Inch                 [UIScreen mainScreen].bounds.size.height == 568
// 4.7inch
#define is4Inch_Laters          [UIScreen mainScreen].bounds.size.height == 667
// 5.5inch
#define is5Inch_Laters          [UIScreen mainScreen].bounds.size.height == 736

// 是否Retina屏
#define isRetina                ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                                CGSizeEqualToSize(CGSizeMake(640, 960), \
                                                  [[UIScreen mainScreen] currentMode].size) : \
                                NO)

// 是否iPhone5
#define isiPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                                CGSizeEqualToSize(CGSizeMake(640, 1136), \
                                                  [[UIScreen mainScreen] currentMode].size) : \
                                NO)
// 是否iPhone5
#define isiPhone4               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                                CGSizeEqualToSize(CGSizeMake(640, 960), \
                                [[UIScreen mainScreen] currentMode].size) : \
                                NO)

// 是否IOS8
#define isIOS8                  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
// 是否IOS7
#define isIOS7                  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
// 是否IOS6
#define isIOS6                  ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0)

// 是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// UIView - viewWithTag
#define VIEWWITHTAG(_OBJECT, _TAG)\
                                \
                                [_OBJECT viewWithTag : _TAG]

// 本地化字符串
/** NSLocalizedString宏做的其实就是在当前bundle中查找资源文件名“Localizable.strings”(参数:键＋注释) */
#define LocalString(x, ...)     NSLocalizedString(x, nil)
/** NSLocalizedStringFromTable宏做的其实就是在当前bundle中查找资源文件名“xxx.strings”(参数:键＋文件名＋注释) */
#define AppLocalString(x, ...)  NSLocalizedStringFromTable(x, @"someName", nil)

// RGB颜色转换（16进制->10进制）
#define HexRGB(rgbValue)        HexRGBA(rgbValue, 1.0)

#define HexRGBA(rgbValue, a)\
                            \
                            [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                             blue:((float)(rgbValue & 0xFF))/255.0 \
                                            alpha:(a)]
// 主题色
#define Theme_Color     HexRGB(0x815021)

// 字符串比较
#define EqualString(aString, toString)  [(aString == nil ? @"" : aString) isEqualToString:(toString == nil ? @"" : toString)]

// nil替换为空字符串
#define SAFE_STRING(aString)                       SAFE_STRING_PLACEHODER(aString, @"")
#define SAFE_STRING_PLACEHODER(aString, pString)   [MCStockChartUtil safeString:aString placeHolder:pString]

#if TARGET_OS_IPHONE
/** iPhone Device */
#endif

#if TARGET_IPHONE_SIMULATOR
/** iPhone Simulator */
#endif

// ARC
#if __has_feature(objc_arc)
/** Compiling with ARC */
#else
/** Compiling without ARC */
#endif


/* ****************************************************************************************************************** */
#pragma mark - Log Method (宏 LOG)

// 日志 / 断点
// =============================================================================================================================
// DEBUG模式
#define ITTDEBUG

// LOG等级
#define ITTLOGLEVEL_INFO        10
#define ITTLOGLEVEL_WARNING     3
#define ITTLOGLEVEL_ERROR       1

// =============================================================================================================================
// LOG最高等级
#ifndef ITTMAXLOGLEVEL

#ifdef DEBUG
#define ITTMAXLOGLEVEL ITTLOGLEVEL_INFO
#else
#define ITTMAXLOGLEVEL ITTLOGLEVEL_ERROR
#endif

#endif

// =============================================================================================================================
// LOG PRINT
// The general purpose logger. This ignores logging levels.
#ifdef ITTDEBUG
#define ITTDPRINT(xx, ...)      NSLog(@"< %s:(%d) > : " xx , __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ITTDPRINT(xx, ...)      ((void)0)
#endif

// Prints the current method's name.
#define ITTDPRINTMETHODNAME()   ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
#if ITTLOGLEVEL_ERROR <= ITTMAXLOGLEVEL
#define ITTDERROR(xx, ...)      ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDERROR(xx, ...)      ((void)0)
#endif

#if ITTLOGLEVEL_WARNING <= ITTMAXLOGLEVEL
#define ITTDWARNING(xx, ...)    ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDWARNING(xx, ...)    ((void)0)
#endif

#if ITTLOGLEVEL_INFO <= ITTMAXLOGLEVEL
#define ITTDINFO(xx, ...)       ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDINFO(xx, ...)       ((void)0)
#endif

// 条件LOG
#ifdef ITTDEBUG
#define ITTDCONDITIONLOG(condition, xx, ...)\
                                \
                                {\
                                    if ((condition))\
                                    {\
                                        ITTDPRINT(xx, ##__VA_ARGS__);\
                                    }\
                                }
#else
#define ITTDCONDITIONLOG(condition, xx, ...)\
                                \
                                ((void)0)
#endif

// 断点Assert
#define ITTAssert(condition, ...)\
                                \
                                do {\
                                    if (!(condition))\
                                    {\
                                        [[NSAssertionHandler currentHandler]\
                                        handleFailureInFunction:[NSString stringWithFormat:@"< %s >", __PRETTY_FUNCTION__]\
                                                           file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent]\
                                                     lineNumber:__LINE__\
                                                    description:__VA_ARGS__];\
                                    }\
                                } while(0)


/* ****************************************************************************************************************** */
#pragma mark - Constants (宏 常量)


/** 时间间隔 */
#define kHUDDuration            (1.f)

/** 一天的秒数 */
#define SecondsOfDay            (24.f * 60.f * 60.f)
/** 秒数 */
#define Seconds(Days)           (24.f * 60.f * 60.f * (Days))

/** 一天的毫秒数 */
#define MillisecondsOfDay       (24.f * 60.f * 60.f * 1000.f)
/** 毫秒数 */
#define Milliseconds(Days)      (24.f * 60.f * 60.f * 1000.f * (Days))


//** textAlignment ***********************************************************************************

#if !defined __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
# define LINE_BREAK_WORD_WRAP UILineBreakModeWordWrap
# define TextAlignmentLeft UITextAlignmentLeft
# define TextAlignmentCenter UITextAlignmentCenter
# define TextAlignmentRight UITextAlignmentRight

#else
# define LINE_BREAK_WORD_WRAP NSLineBreakByWordWrapping
# define TextAlignmentLeft NSTextAlignmentLeft
# define TextAlignmentCenter NSTextAlignmentCenter
# define TextAlignmentRight NSTextAlignmentRight

#endif

#pragma mark - Constants (宏 字符串)

#define AttributeTCF(text, textColor, font) AttributeTCFL(text, textColor, font, 0.0f)

#define AttributeTCFL(text, textColor, font, lineSpacing) [MCStockChartUtil attributeText:text textColor:textColor font:font lineSpacing:lineSpacing]

#endif
