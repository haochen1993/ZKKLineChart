//
//  Y-KlineModel.m
//  BTC-Kline
//
//  Created by ZK on 16/4/28.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "MCKLineModel.h"
#import "MCKLineGroupModel.h"
#import "Y_StockChartGlobalVariable.h"
@implementation MCKLineModel

- (CGFloat)RSV_9 {
    if (!_RSV_9) {
        if(self.minPriceOfNineClock == self.maxPriceOfNineClock) {
            _RSV_9 = 100;
        }
        else {
            _RSV_9 = (self.closingPrice - self.minPriceOfNineClock) * 100 / (self.maxPriceOfNineClock - self.minPriceOfNineClock);
        }
    }
    return _RSV_9;
}

- (CGFloat)KDJ_K {
    if (!_KDJ_K) {
        _KDJ_K = (self.RSV_9 + 2 * (self.previousKlineModel.KDJ_K ?: 50) ) / 3;
    }
    return _KDJ_K;
}

- (CGFloat)KDJ_D {
    if(!_KDJ_D) {
        _KDJ_D = (self.KDJ_K + 2 * (self.previousKlineModel.KDJ_D ?: 50)) / 3;
    }
    return _KDJ_D;
}

- (CGFloat)KDJ_J {
    if(!_KDJ_J) {
        _KDJ_J = 3*self.KDJ_K - 2*self.KDJ_D;
    }
    return _KDJ_J;
}

- (CGFloat)Volume_MA7 {
    if([Y_StockChartGlobalVariable isEMALine] == Y_StockChartTargetLineStatusMA) {
        if (!_Volume_MA7) {
            NSInteger index = [self.parentGroupModel.models indexOfObject:self];
            if (index >= 6) {
                if (index > 6) {
                    _Volume_MA7 = (self.sumOfLastVolume - self.parentGroupModel.models[index - 7].sumOfLastVolume) / 7;
                }
                else {
                    _Volume_MA7 = self.sumOfLastVolume / 7;
                }
            }
        }
    }
    else {
        return self.Volume_EMA7;
    }
    return _Volume_MA7;
}

- (CGFloat)Volume_EMA7 {
    if(!_Volume_EMA7) {
        _Volume_EMA7 = (self.volume + 3 * self.previousKlineModel.Volume_EMA7)/4;
    }
    return _Volume_EMA7;
}

//// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
- (CGFloat)EMA7 {
    if(!_EMA7) {
        _EMA7 = (self.closingPrice + 3 * self.previousKlineModel.EMA7)/4;
    }
    return _EMA7;
}

- (CGFloat)EMA30 {
    if(!_EMA30) {
        _EMA30 = (2 * self.closingPrice + 29 * self.previousKlineModel.EMA30)/31;
    }
    return _EMA30;
}

- (CGFloat)EMA12 {
    if(!_EMA12) {
        _EMA12 = (2 * self.closingPrice + 11 * self.previousKlineModel.EMA12)/13;
    }
    return _EMA12;
}

- (CGFloat)EMA26 {
    if (!_EMA26) {
        _EMA26 = (2 * self.closingPrice + 25 * self.previousKlineModel.EMA26)/27;
    }
    return _EMA26;
}

- (CGFloat)Volume_MA30 {
    if([Y_StockChartGlobalVariable isEMALine] == Y_StockChartTargetLineStatusMA) {
        if (!_Volume_MA30) {
            NSInteger index = [self.parentGroupModel.models indexOfObject:self];
            if (index >= 29) {
                if (index > 29) {
                    _Volume_MA30 = (self.sumOfLastVolume - self.parentGroupModel.models[index - 30].sumOfLastVolume) / 30;
                }
                else {
                    _Volume_MA30 = self.sumOfLastVolume / 30;
                }
            }
        }
    } else {
        return self.Volume_EMA30;
    }
    return _Volume_MA30;
}

- (CGFloat)Volume_EMA30 {
    if(!_Volume_EMA30) {
        _Volume_EMA30 = (2 * self.volume + 29 * self.previousKlineModel.Volume_EMA30)/31;
    }
    return _Volume_EMA30;
}

- (CGFloat)MA7 {
    if (!_MA7) {
        _MA7 = [self calcMAValueWithDays:7];
    }
    return _MA7;
}

- (CGFloat)MA12 {
    if (!_MA12) {
        _MA12 = [self calcMAValueWithDays:12];
    }
    return _MA12;
}

- (CGFloat)MA26 {
    if (!_MA26) {
        _MA26 = [self calcMAValueWithDays:26];
    }
    return _MA26;
}

- (CGFloat)MA30 {
    if (!_MA30) {
        _MA30 = [self calcMAValueWithDays:30];
    }
    return _MA30;
}

- (CGFloat)sumOfLastClose {
    if(!_sumOfLastClose) {
        _sumOfLastClose = self.previousKlineModel.sumOfLastClose + self.closingPrice;
    }
    return _sumOfLastClose;
}

- (CGFloat)sumOfLastVolume {
    if(!_sumOfLastVolume) {
        _sumOfLastVolume = self.previousKlineModel.sumOfLastVolume + self.volume;
    }
    return _sumOfLastVolume;
}

- (CGFloat)minPriceOfNineClock {
    if (!_minPriceOfNineClock) {
        _minPriceOfNineClock = [self calcMinPriceOfNineClock];
    }
    return _minPriceOfNineClock;
}

- (CGFloat)maxPriceOfNineClock {
    if (!_maxPriceOfNineClock) {
        _maxPriceOfNineClock = [self calcMaxPriceOfNineClock];
    }
    return _maxPriceOfNineClock;
}

////DIF=EMA（12）-EMA（26）         DIF的值即为红绿柱；
//
////今日的DEA值=前一日DEA*8/10+今日DIF*2/10.

- (CGFloat)DIF {
    if(!_DIF) {
        _DIF = self.EMA12 - self.EMA26;
    }
    return _DIF;
}

//已验证
-(CGFloat)DEA {
    if(!_DEA) {
        _DEA = self.previousKlineModel.DEA * 0.8 + 0.2*self.DIF;
    }
    return _DEA;
}

//已验证
- (CGFloat)MACD {
    if(!_MACD) {
        _MACD = 2*(self.DIF - self.DEA);
    }
    return _MACD;
}

- (CGFloat)closeDiff {
    if (!_closeDiff) {
        _closeDiff = self.closingPrice - self.previousKlineModel.closingPrice;
    }
    return _closeDiff;
}

- (CGFloat)RSI_6 {
    if (!_RSI_6) {
        _RSI_6 = [self calcRSIWithDays:6];
    }
    return _RSI_6;
}

- (CGFloat)RSI_12 {
    if (!_RSI_12) {
        _RSI_12 = [self calcRSIWithDays:12];
    }
    return _RSI_12;
}

-(CGFloat)RSI_24 {
    if (!_RSI_24) {
        _RSI_24 = [self calcRSIWithDays:24];
    }
    return _RSI_24;
}

#pragma mark BOLL线

- (CGFloat)MA20 {
    if (!_MA20) {
        NSInteger index = [self.parentGroupModel.models indexOfObject:self];
        if (index >= 19) {
            if (index > 19) {
                _MA20 = (self.sumOfLastClose - self.parentGroupModel.models[index - 20].sumOfLastClose) / 20;
            } else {
                _MA20 = self.sumOfLastClose / 20;
            }
        }
    }
    return _MA20;
}

- (CGFloat)BOLL_MB {
    if(!_BOLL_MB) {
        _BOLL_MB = [self calcMAValueWithDays:20];
    }
    return _BOLL_MB;
}

- (CGFloat)BOLL_MD {
    if (!_BOLL_MD) {
        NSInteger index = [self.parentGroupModel.models indexOfObject:self];
        if (index >= 20) {
//            _BOLL_MD = sqrt(pow((self.closingPrice - self.BOLL_MB), 2) / 20);
            _BOLL_MD = sqrt((self.previousKlineModel.BOLL_SUBMD_SUM - self.parentGroupModel.models[index - 20].BOLL_SUBMD_SUM)/ 20);
        }
    }
    // NSLog(@"lazy:\n_BOLL_MD:%@ -- BOLL_SUBMD:%@",_BOLL_MD,_BOLL_SUBMD);
    return _BOLL_MD;
}

- (CGFloat)BOLL_UP {
    if (!_BOLL_UP) {
        NSInteger index = [self.parentGroupModel.models indexOfObject:self];
        if (index >= 20) {
            _BOLL_UP = self.BOLL_MB + 2 * self.BOLL_MD;
        }
    }
    // NSLog(@"lazy:\n_BOLL_UP:%@ -- BOLL_MD:%@",_BOLL_UP,_BOLL_MD);
    return _BOLL_UP;
}

- (CGFloat)BOLL_DN {
    if (!_BOLL_DN) {
        NSInteger index = [self.parentGroupModel.models indexOfObject:self];
        if (index >= 20) {
            _BOLL_DN = self.BOLL_MB - 2 * self.BOLL_MD;
        }
    }
//     NSLog(@"lazy:\n_BOLL_DN:%f -- BOLL_MD:%f",_BOLL_DN,_BOLL_MD);
    return _BOLL_DN;
}

- (CGFloat)BOLL_SUBMD_SUM {
    
    if (!_BOLL_SUBMD_SUM) {
        NSInteger index = [self.parentGroupModel.models indexOfObject:self];
        if (index >= 20) {
            _BOLL_SUBMD_SUM = self.previousKlineModel.BOLL_SUBMD_SUM + self.BOLL_SUBMD;
        }
    }
    // NSLog(@"lazy:\n_BOLL_SUBMD_SUM:%@ -- BOLL_SUBMD:%@",_BOLL_SUBMD_SUM,_BOLL_SUBMD);
    return _BOLL_SUBMD_SUM;
}

- (CGFloat)BOLL_SUBMD {
    if (!_BOLL_SUBMD) {
        NSInteger index = [self.parentGroupModel.models indexOfObject:self];
        if (index >= 20) {
            _BOLL_SUBMD = (self.closingPrice - self.MA20) * ( self.closingPrice - self.MA20);
        }
    }
    return _BOLL_SUBMD;
}

- (MCKLineGroupModel *)parentGroupModel {
    if(!_parentGroupModel) {
        _parentGroupModel = [MCKLineGroupModel new];
    }
    return _parentGroupModel;
}

- (void)initWithValues:(NSArray *)arr {
    NSAssert(arr.count == 6, @"数组长度不足");
    if (self)  {
        NSTimeInterval timestamp = ([arr[0] integerValue]) / 1000;
        _date = [self generateFormatTimeViaStamp:timestamp isFull:false];
        _fullDate = [self generateFormatTimeViaStamp:timestamp isFull:true];
        _openingPrice = [arr[1] floatValue];
        _highestPrice = [arr[2] floatValue];
        _lowestPrice = [arr[3] floatValue];
        _closingPrice = [arr[4] floatValue];
        _volume = [arr[5] floatValue];
        self.sumOfLastClose = _closingPrice + self.previousKlineModel.sumOfLastClose;
        self.sumOfLastVolume = _volume + self.previousKlineModel.sumOfLastVolume;
    }
}

- (NSString *)generateFormatTimeViaStamp:(NSTimeInterval)stamp isFull:(BOOL)full {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSDateFormatter *format = [NSDateFormatter new];
    if (full) {
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    else {
        [format setDateFormat:@"HH:mm"];
    }
    NSString *dateStr = [format stringFromDate:date];
    return dateStr;
}

- (void)initFirstModel {
//    _SumOfLastClose = _Close;
//    _SumOfLastVolume = @(_Volume);
    _KDJ_K = 55.27;
    _KDJ_D = 55.27;
    _KDJ_J = 55.27;
//    _MA7 = _Close;
//    _MA12 = _Close;
//    _MA26 = _Close;
//    _MA30 = _Close;
    _EMA7 = _closingPrice;
    _EMA12 = _closingPrice;
    _EMA26 = _closingPrice;
    _EMA30 = _closingPrice;
    _minPriceOfNineClock = _lowestPrice;
    _maxPriceOfNineClock = _highestPrice;
    [self DIF];
    [self DEA];
    [self MACD];
    [self RSV_9];
    [self KDJ_K];
    [self KDJ_D];
    [self KDJ_J];
    
    [self MA20];
    [self BOLL_MD];
    [self BOLL_MB];
    [self BOLL_UP];
    [self BOLL_DN];
    [self BOLL_SUBMD];
    [self BOLL_SUBMD_SUM];
    
}

- (void)initData {
    [self MA7];
    [self MA12];
    [self MA26];
    [self MA30];
    [self EMA7];
    [self EMA12];
    [self EMA26];
    [self EMA30];
    
    [self DIF];
    [self DEA];
    [self MACD];
    [self maxPriceOfNineClock];
    [self minPriceOfNineClock];
    [self RSV_9];
    [self KDJ_K];
    [self KDJ_D];
    [self KDJ_J];
    
    [self MA20];
    [self BOLL_MD];
    [self BOLL_MB];
    [self BOLL_UP];
    [self BOLL_DN];
    [self BOLL_SUBMD];
    [self BOLL_SUBMD_SUM];
    
    [self closeDiff];
    [self RSI_6];
    [self RSI_12];
    [self RSI_24];
}

#pragma mark - Calc

- (CGFloat)calcMinPriceOfNineClock {
    NSArray <MCKLineModel *> *models = self.parentGroupModel.models;
    NSInteger index = [self.parentGroupModel.models indexOfObject:self];
    CGFloat minValue = models[index].lowestPrice;
    NSInteger startIndex = index < 9 ? 0 : (index - ( 9 - 1));
    for (NSInteger i = startIndex; i < index; i ++) {
        if (models[i].lowestPrice < minValue) {
            minValue = models[i].lowestPrice;
        }
    }
    return minValue;
}

- (CGFloat)calcMaxPriceOfNineClock {
    NSArray <MCKLineModel *> *models = self.parentGroupModel.models;
    NSInteger index = [self.parentGroupModel.models indexOfObject:self];
    CGFloat maxValue = models[index].highestPrice;
    NSInteger startIndex = index < 9 ? 0 : (index - ( 9 - 1));
    for (NSInteger i = startIndex; i < index; i ++) {
        if (models[i].highestPrice > maxValue) {
            maxValue = models[i].highestPrice;
        }
    }
    return maxValue;
}

/**
 计算RSI
 RSI（14）= A ÷（A＋B）× 100
 */
- (CGFloat)calcRSIWithDays:(NSInteger)daysCount {
    CGFloat RSI = 0;
    
    NSInteger selfIndex = [self.parentGroupModel.models indexOfObject:self];
    if (selfIndex < daysCount) {
        return RSI;
    }
    else {
        CGFloat positiveSum = 0;
        CGFloat negativeSum = 0;
        for (NSInteger i = selfIndex; i >= selfIndex - daysCount; i --) {
            MCKLineModel *model = self.parentGroupModel.models[i];
            if (model.closeDiff >= 0) {
                positiveSum += model.closeDiff;
            }
            else {
                negativeSum += fabs(model.closeDiff);
            }
        }
        RSI = positiveSum / (positiveSum + negativeSum) * 100;
    }
    return RSI;
}

- (CGFloat)calcMAValueWithDays:(NSInteger)daysCount {
    CGFloat MAValue = 0;
    NSInteger index = [self.parentGroupModel.models indexOfObject:self];
    if (index == daysCount-1) {
        MAValue = self.sumOfLastClose / daysCount;
    }
    else if (index > daysCount-1) {
        MAValue = (self.sumOfLastClose - self.parentGroupModel.models[index - daysCount].sumOfLastClose) / daysCount;
    }
    else {
        MAValue = 0;
    }
    return MAValue;
}

@end
