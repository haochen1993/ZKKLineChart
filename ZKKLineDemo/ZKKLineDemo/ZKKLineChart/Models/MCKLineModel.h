//
//  Y-KlineModel.h
//  BTC-Kline
//
//  Created by ZK on 16/4/28.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCKLineGroupModel;

typedef NS_ENUM(NSInteger, YCoinType) {
    CoinTypeBTC = 1,   //比特币
    CoinTypeETH,       //以太坊
    CoinTypeNone       //未定义类型
};

@interface MCKLineModel : NSObject

#pragma 外部初始化

@property (nonatomic, assign) YCoinType coinType; //!< 货币类型
@property (nonatomic, strong) MCKLineModel *previousKlineModel; //!< 前一个Model
@property (nonatomic, strong) MCKLineGroupModel *parentGroupModel; //!< 父ModelArray:用来给当前Model索引到Parent数组
@property (nonatomic, assign) CGFloat sumOfLastClose; //!< 该Model及其之前所有收盘价之和
@property (nonatomic, assign) CGFloat sumOfLastVolume; //!< 该Model及其之前所有成交量之和
@property (nonatomic, copy) NSString *date; //!< 日期
@property (nonatomic, copy) NSString *fullDate; //!< 含有年月日的时间
@property (nonatomic, assign) CGFloat openingPrice; //!< 开盘价
@property (nonatomic, assign) CGFloat closingPrice; //!< 收盘价
@property (nonatomic, assign) CGFloat highestPrice; //!< 最高价
@property (nonatomic, assign) CGFloat lowestPrice; //!< 最低价
@property (nonatomic, assign) CGFloat volume; //!< 成交量
@property (nonatomic, assign) BOOL isFirstTradeDate; //!< 是否是某个月的第一个交易日

#pragma 内部自动初始化

//移动平均数分为MA（简单移动平均数）和EMA（指数移动平均数），其计算公式如下：［C为收盘价，N为周期数］：
//MA（N）=（C1+C2+……CN）/N
@property (nonatomic, assign) CGFloat MA7;
@property (nonatomic, assign) CGFloat MA12;
@property (nonatomic, assign) CGFloat MA26;
@property (nonatomic, assign) CGFloat MA30;

@property (nonatomic, assign) CGFloat Volume_MA7;
@property (nonatomic, assign) CGFloat Volume_MA30;

@property (nonatomic, assign) CGFloat Volume_EMA7;
@property (nonatomic, assign) CGFloat Volume_EMA30;

#pragma BOLL线

@property (nonatomic, assign) CGFloat MA20;

// 标准差 二次方根【 下的 (n-1)天的 C-MA二次方 和】
@property (nonatomic, assign) CGFloat BOLL_MD;

// n-1 天的 MA
@property (nonatomic, assign) CGFloat BOLL_MB;

// MB + k * MD
@property (nonatomic, assign) CGFloat BOLL_UP;

// MB - k * MD
@property (nonatomic, assign) CGFloat BOLL_DN;

//  n 个 ( Cn - MA20)的平方和
@property (nonatomic, assign) CGFloat BOLL_SUBMD_SUM;

// 当前的 ( Cn - MA20)的平方
@property (nonatomic, assign) CGFloat BOLL_SUBMD;


#pragma 第一个EMA等于MA；即EMA(n) = MA(n)

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
@property (nonatomic, assign) CGFloat EMA7;

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
@property (nonatomic, assign) CGFloat EMA30;

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
@property (nonatomic, assign) CGFloat EMA12;

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
@property (nonatomic, assign) CGFloat EMA26;

//MACD主要是利用长短期的二条平滑平均线，计算两者之间的差离值，作为研判行情买卖之依据。MACD指标是基于均线的构造原理，对价格收盘价进行平滑处 理(求出算术平均值)后的一种趋向类指标。它主要由两部分组成，即正负差(DIF)、异同平均数(DEA)，其中，正负差是核心，DEA是辅助。DIF是 快速平滑移动平均线(EMA1)和慢速平滑移动平均线(EMA2)的差。

//在现有的技术分析软件中，MACD常用参数是快速平滑移动平均线为12，慢速平滑移动平均线参数为26。此外，MACD还有一个辅助指标——柱状线 (BAR)。在大多数技术分析软件中，柱状线是有颜色的，在低于0轴以下是绿色，高于0轴以上是红色，前者代表趋势较弱，后者代表趋势较强。

//MACD(12,26.9),下面以该参数为例说明计算方法。


//12日EMA的算式为
//EMA（12）=昨日EMA（12）*11/13+C*2/13＝(C－昨日的EMA)×0.1538＋昨日的EMA；   即为MACD指标中的快线-快速平滑移动平均线；
//26日EMA的算式为
//EMA（26）=昨日EMA（26）*25/27+C*2/27；   即为MACD指标中的慢线-慢速平滑移动平均线；

//DIF=EMA（12）-EMA（26）         DIF的值即为红绿柱；
@property (nonatomic, assign) CGFloat DIF;

//今日的DEA值（即MACD值）=前一日DEA*8/10+今日DIF*2/10.
@property (nonatomic, assign) CGFloat DEA;

//EMA（12）=昨日EMA（12）*11/13+C*2/13；   即为MACD指标中的快线；
//EMA（26）=昨日EMA（26）*25/27+C*2/27；   即为MACD指标中的慢线；
@property (nonatomic, assign) CGFloat MACD;

// 详见指标算法及释义.h
@property (nonatomic, assign) CGFloat RSV_9;
@property (nonatomic, assign) CGFloat KDJ_K;
@property (nonatomic, assign) CGFloat KDJ_D;
@property (nonatomic, assign) CGFloat KDJ_J;
@property (nonatomic, assign) CGFloat minPriceOfNineClock; //!< 9Clock内最低价
@property (nonatomic, assign) CGFloat maxPriceOfNineClock; //!< 9Clock内最高价

//初始化Model
- (void)initWithValues:(NSArray *)arr;

//初始化第一条数据
- (void)initFirstModel;

//初始化其他数据
- (void)initData ;

@end
