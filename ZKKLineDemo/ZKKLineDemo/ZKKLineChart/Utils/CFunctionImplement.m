//
//  CFunctionImplement
//  HappyIn
//
//  Created by marujun on 16/3/2.
//  Copyright © 2016年 MaRuJun. All rights reserved.
//

#import "MacroToolHeader.h"

#pragma mark - MacroToolHeader.h 相关C函数实现

/** 获取Document文件夹的路径 */
NSString *NSDocumentPath() { return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]; }

/** 获取自定义文件的bundle路径 */
NSString *NSResourcePath() { return [[NSBundle mainBundle] resourcePath]; }

/**
 [UIImage imageNamed:@""] 会把读取到的image存在某个缓存里面，第二次读取相同图片的话更快，不会因为Memory Warning而释放；
 [UIImage imageWithContentsOfFile:@""] 则是一个比较直接的读取，不会被存进某缓存，第二次读取相同图片也就是重新读取一遍，所以节约了内存～
 */
UIImage *ImageNamed(NSString *imageName) {
    if (SystemVersionLessThan(@"8.0")) {
        return [UIImage imageNamed:imageName];
    }
    return [UIImage imageWithContentsOfFile:[NSResourcePath() stringByAppendingPathComponent:imageName]];
}

UIColor *RGBCOLOR(CGFloat read, CGFloat green, CGFloat blue) {
    return [UIColor colorWithRed:(read)/255.0f green:(green)/255.0f blue:(blue)/255.0f alpha:1];
}

UIColor *RGBACOLOR(CGFloat read, CGFloat green, CGFloat blue, CGFloat alpha) {
    return [UIColor colorWithRed:(read)/255.0f green:(green)/255.0f blue:(blue)/255.0f alpha:alpha];
}

/**
 通过16进制色值获取UIColor对象
 @param hexValue 16进制颜色值，如：0x000000
 */
UIColor *HexColor(unsigned int hexValue) {
    return HexAlphaColor(hexValue, 1);
}
UIColor *HexAlphaColor(unsigned int hexValue, float alpha) {
    return [UIColor colorWithRed:((float)(((hexValue) & 0xFF0000) >> 16))/255.0 green:((float)(((hexValue) & 0xFF00) >> 8))/255.0 blue:((float)((hexValue) & 0xFF))/255.0 alpha:alpha];
}

/** 比较系统版本号相关函数 */
BOOL SystemVersionEqualTo(NSString *version) { return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedSame; }
BOOL SystemVersionGreaterThan(NSString *version) { return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedDescending; }
BOOL SystemVersionGreaterThanOrEqualTo(NSString *version) { return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedAscending; }
BOOL SystemVersionLessThan(NSString *version) { return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending; }
BOOL SystemVersionLessThanOrEqualTo(NSString *version) { return [[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedDescending; }

CGFloat MCFitFontSize (CGFloat basePointSize) {
    return ((IS_IPHONE_4||IS_IPHONE_5)?basePointSize:(IS_IPHONE_6?(basePointSize+.5):(basePointSize+1.5)));
}

// 自适应系统字体
UIFont *MCFontWithSize (CGFloat basePointSize) {
    return [UIFont systemFontOfSize:MCFitFontSize(basePointSize)];
}

CGFloat system_version_f () {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

CGFloat AutoFitCellRowHeight (CGFloat baseRowHeight, NSInteger textLineNumber) {
    return ((IS_IPHONE_4||IS_IPHONE_5)?baseRowHeight:(IS_IPHONE_6?(baseRowHeight+3*textLineNumber):(baseRowHeight+5*textLineNumber)));
}
