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
        if(self.NineClocksMinPrice == self.NineClocksMaxPrice) {
            _RSV_9 = 100;
        } else {
            _RSV_9 = (self.closingPrice - self.NineClocksMinPrice) * 100 / (self.NineClocksMaxPrice - self.NineClocksMinPrice);
        }
    }
    return _RSV_9;
}

- (CGFloat)KDJ_K {
    if (!_KDJ_K) {
        _KDJ_K = (self.RSV_9 + 2 * (self.PreviousKlineModel.KDJ_K ? self.PreviousKlineModel.KDJ_K : 50) )/3;
    }
    return _KDJ_K;
}

- (CGFloat)KDJ_D {
    if(!_KDJ_D) {
        _KDJ_D = (self.KDJ_K + 2 * (self.PreviousKlineModel.KDJ_D ? self.PreviousKlineModel.KDJ_D : 50))/3;
    }
    return _KDJ_D;
}

- (CGFloat)KDJ_J {
    if(!_KDJ_J) {
        _KDJ_J = 3*self.KDJ_K - 2*self.KDJ_D;
    }
    return _KDJ_J;
}

- (CGFloat)MA7 {
    if([Y_StockChartGlobalVariable isEMALine] == Y_StockChartTargetLineStatusMA)
    {
        if (!_MA7) {
            NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
            if (index >= 6) {
                if (index > 6) {
                    _MA7 = (self.SumOfLastClose - self.ParentGroupModel.models[index - 7].SumOfLastClose) / 7;
                } else {
                    _MA7 = self.SumOfLastClose / 7;
                }
            }
        }
    } else {
        return self.EMA7;
    }
    return _MA7;
}

- (CGFloat)Volume_MA7 {
    if([Y_StockChartGlobalVariable isEMALine] == Y_StockChartTargetLineStatusMA)
    {
        if (!_Volume_MA7) {
            NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
            if (index >= 6) {
                if (index > 6) {
                    _Volume_MA7 = (self.SumOfLastVolume - self.ParentGroupModel.models[index - 7].SumOfLastVolume) / 7;
                } else {
                    _Volume_MA7 = self.SumOfLastVolume / 7;
                }
            }
        }
    } else {
        return self.Volume_EMA7;
    }
    return _Volume_MA7;
}

- (CGFloat)Volume_EMA7 {
    if(!_Volume_EMA7) {
        _Volume_EMA7 = (self.volume + 3 * self.PreviousKlineModel.Volume_EMA7)/4;
    }
    return _Volume_EMA7;
}
//// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
- (CGFloat)EMA7 {
    if(!_EMA7) {
        _EMA7 = (self.closingPrice + 3 * self.PreviousKlineModel.EMA7)/4;
    }
    return _EMA7;
}

- (CGFloat)EMA30 {
    if(!_EMA30) {
        _EMA30 = (2 * self.closingPrice + 29 * self.PreviousKlineModel.EMA30)/31;
    }
    return _EMA30;
}

- (CGFloat)EMA12 {
    if(!_EMA12) {
        _EMA12 = (2 * self.closingPrice + 11 * self.PreviousKlineModel.EMA12)/13;
    }
    return _EMA12;
}

- (CGFloat)EMA26 {
    if (!_EMA26) {
        _EMA26 = (2 * self.closingPrice + 25 * self.PreviousKlineModel.EMA26)/27;
    }
    return _EMA26;
}

- (CGFloat)MA30 {
    if([Y_StockChartGlobalVariable isEMALine] == Y_StockChartTargetLineStatusMA) {
        if (!_MA30) {
            NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
            if (index >= 29) {
                if (index > 29) {
                    _MA30 = (self.SumOfLastClose - self.ParentGroupModel.models[index - 30].SumOfLastClose) / 30;
                } else {
                    _MA30 = self.SumOfLastClose / 30;
                }
            }
        }
    }
    else {
        return self.EMA30;
    }
    return _MA30;
}

- (CGFloat)Volume_MA30 {
    if([Y_StockChartGlobalVariable isEMALine] == Y_StockChartTargetLineStatusMA) {
        if (!_Volume_MA30) {
            NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
            if (index >= 29) {
                if (index > 29) {
                    _Volume_MA30 = (self.SumOfLastVolume - self.ParentGroupModel.models[index - 30].SumOfLastVolume) / 30;
                } else {
                    _Volume_MA30 = self.SumOfLastVolume / 30;
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
        _Volume_EMA30 = (2 * self.volume + 29 * self.PreviousKlineModel.Volume_EMA30)/31;
    }
    return _Volume_EMA30;
}

- (CGFloat)MA12 {
    if (!_MA12) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 11) {
            if (index > 11) {
                _MA12 = (self.SumOfLastClose - self.ParentGroupModel.models[index - 12].SumOfLastClose) / 12;
            } else {
                _MA12 = self.SumOfLastClose / 12;
            }
        }
    }
    return _MA12;
}

- (CGFloat)MA26 {
    if (!_MA26) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 25) {
            if (index > 25) {
                _MA26 = (self.SumOfLastClose - self.ParentGroupModel.models[index - 26].SumOfLastClose) / 26;
            } else {
                _MA26 = self.SumOfLastClose / 26;
            }
        }
    }
    return _MA26;
}

- (CGFloat)SumOfLastClose {
    if(!_SumOfLastClose) {
        _SumOfLastClose = self.PreviousKlineModel.SumOfLastClose + self.closingPrice;
    }
    return _SumOfLastClose;
}

- (CGFloat)SumOfLastVolume {
    if(!_SumOfLastVolume) {
        _SumOfLastVolume = self.PreviousKlineModel.SumOfLastVolume + self.volume;
    }
    return _SumOfLastVolume;
}

- (CGFloat)NineClocksMinPrice {
    if (!_NineClocksMinPrice) {
//        if([self.ParentGroupModel.models indexOfObject:self] >= 8)
//        {
            [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedDescending];
//        } else {
//            _NineClocksMinPrice = @0;
//        }
    }
    return _NineClocksMinPrice;
}

- (CGFloat)NineClocksMaxPrice {
    if (!_NineClocksMaxPrice) {
        if([self.ParentGroupModel.models indexOfObject:self] >= 8)
        {
            [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedAscending];
        } else {
            _NineClocksMaxPrice = 0;
        }
    }
    return _NineClocksMaxPrice;
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
        _DEA = self.PreviousKlineModel.DEA * 0.8 + 0.2*self.DIF;
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

#pragma mark BOLL线

- (CGFloat)MA20 {
    
    if (!_MA20) {
        
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 19) {
            if (index > 19) {
                _MA20 = (self.SumOfLastClose - self.ParentGroupModel.models[index - 20].SumOfLastClose) / 20;
            } else {
                _MA20 = self.SumOfLastClose / 20;
            }
        }
    }
    return _MA20;
    
}

- (CGFloat)BOLL_MB {
    
    if(!_BOLL_MB) {
        
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 19) {
            
            if (index > 19) {
                _BOLL_MB = (self.SumOfLastClose - self.ParentGroupModel.models[index - 19].SumOfLastClose) / 19;
                
            } else {
                
                _BOLL_MB = self.SumOfLastClose / index;
                
            }
        }
        
        // NSLog(@"lazyMB:\n _BOLL_MB: %@", _BOLL_MB);
        
    }
    
    return _BOLL_MB;
}

- (CGFloat)BOLL_MD {
    
    if (!_BOLL_MD) {
        
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        
        if (index >= 20) {
            
            _BOLL_MD = sqrt((self.PreviousKlineModel.BOLL_SUBMD_SUM - self.ParentGroupModel.models[index - 20].BOLL_SUBMD_SUM)/ 20);
            
        }
        
    }
    
    // NSLog(@"lazy:\n_BOLL_MD:%@ -- BOLL_SUBMD:%@",_BOLL_MD,_BOLL_SUBMD);
    
    return _BOLL_MD;
}

- (CGFloat)BOLL_UP {
    if (!_BOLL_UP) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 20) {
            _BOLL_UP = self.BOLL_MB + 2 * self.BOLL_MD;
        }
    }
    
    // NSLog(@"lazy:\n_BOLL_UP:%@ -- BOLL_MD:%@",_BOLL_UP,_BOLL_MD);
    
    return _BOLL_UP;
}

- (CGFloat)BOLL_DN {
    if (!_BOLL_DN) {
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 20) {
            _BOLL_DN = self.BOLL_MB - 2 * self.BOLL_MD;
        }
    }
    
    // NSLog(@"lazy:\n_BOLL_DN:%@ -- BOLL_MD:%@",_BOLL_DN,_BOLL_MD);
    
    return _BOLL_DN;
}

- (CGFloat)BOLL_SUBMD_SUM {
    
    if (!_BOLL_SUBMD_SUM) {
        
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        if (index >= 20) {
            
            _BOLL_SUBMD_SUM = self.PreviousKlineModel.BOLL_SUBMD_SUM + self.BOLL_SUBMD;
            
        }
    }
    
    // NSLog(@"lazy:\n_BOLL_SUBMD_SUM:%@ -- BOLL_SUBMD:%@",_BOLL_SUBMD_SUM,_BOLL_SUBMD);
    
    return _BOLL_SUBMD_SUM;
}

- (CGFloat)BOLL_SUBMD {
    
    if (!_BOLL_SUBMD) {
        
        NSInteger index = [self.ParentGroupModel.models indexOfObject:self];
        
        if (index >= 20) {
            
            _BOLL_SUBMD = (self.closingPrice - self.MA20) * ( self.closingPrice - self.MA20);
                        
        }
    }
    
    // NSLog(@"lazy_BOLL_SUBMD: \n MA20: %@ \n Close: %@ \n subNum: %f", _MA20, _Close, self.Close - self.MA20);
    
    return _BOLL_SUBMD;
}



//- (MCKLineModel *)PreviousKlineModel {
//    if (!_PreviousKlineModel) {
//        _PreviousKlineModel = [MCKLineModel new];
//        _PreviousKlineModel.DIF = 0;
//        _PreviousKlineModel.DEA = 0;
//        _PreviousKlineModel.MACD = 0;
//        _PreviousKlineModel.MA7 = 0;
//        _PreviousKlineModel.MA12 = 0;
//        _PreviousKlineModel.MA26 = 0;
//        _PreviousKlineModel.MA30 = 0;
//        _PreviousKlineModel.EMA7 = 0;
//        _PreviousKlineModel.EMA12 = 0;
//        _PreviousKlineModel.EMA26 = 0;
//        _PreviousKlineModel.EMA30 = 0;
//        _PreviousKlineModel.Volume_MA7 = 0;
//        _PreviousKlineModel.Volume_MA30 = 0;
//        _PreviousKlineModel.Volume_EMA7 = 0;
//        _PreviousKlineModel.Volume_EMA30 = 0;
//        _PreviousKlineModel.SumOfLastClose = 0;
//        _PreviousKlineModel.SumOfLastVolume = 0;
//        _PreviousKlineModel.KDJ_K = 50;
//        _PreviousKlineModel.KDJ_D = 50;
//
//        _PreviousKlineModel.MA20 = 0;
//        _PreviousKlineModel.BOLL_MD = 0;
//        _PreviousKlineModel.BOLL_MB = 0;
//        _PreviousKlineModel.BOLL_DN = 0;
//        _PreviousKlineModel.BOLL_UP = 0;
//        _PreviousKlineModel.BOLL_SUBMD_SUM = 0;
//        _PreviousKlineModel.BOLL_SUBMD = 0;
//        
//    }
//    return _PreviousKlineModel;
//}

- (MCKLineGroupModel *)ParentGroupModel {
    if(!_ParentGroupModel) {
        _ParentGroupModel = [MCKLineGroupModel new];
    }
    return _ParentGroupModel;
}

//对Model数组进行排序，初始化每个Model的最新9Clock的最低价和最高价
- (void)rangeLastNinePriceByArray:(NSArray<MCKLineModel *> *)models condition:(NSComparisonResult)cond {
    switch (cond) {
            //最高价
        case NSOrderedAscending: {
//            第一个循环结束后，ClockFirstValue为最小值
            for (NSInteger j = 7; j >= 1; j--) {
                CGFloat emMaxValue = 0;
                
                NSInteger em = j;
                
                while ( em >= 0 ) {
                    if([@(emMaxValue) compare:@(models[em].highestPrice)] == cond) {
                        emMaxValue = models[em].highestPrice;
                    }
                    em--;
                }
                NSLog(@"%f",emMaxValue);
                models[j].NineClocksMaxPrice = emMaxValue;
            }
            //第一个循环结束后，ClockFirstValue为最小值
            for (NSInteger i = 0, j = 8; j < models.count; i++,j++) {
                CGFloat emMaxValue = 0;
                
                NSInteger em = j;
                
                while ( em >= i ) {
                    if([@(emMaxValue) compare:@(models[em].highestPrice)] == cond) {
                        emMaxValue = models[em].highestPrice;
                    }
                    em--;
                }
                NSLog(@"%f",emMaxValue);

                models[j].NineClocksMaxPrice = emMaxValue;
            }
        }
            break;
        case NSOrderedDescending: {
            //第一个循环结束后，ClockFirstValue为最小值
            
            for (NSInteger j = 7; j >= 1; j--) {
                CGFloat emMinValue = 10000000000;
                
                NSInteger em = j;
                
                while ( em >= 0 ) {
                    if([@(emMinValue) compare:@(models[em].lowestPrice)] == cond)
                    {
                        emMinValue = models[em].lowestPrice;
                    }
                    em--;
                }
                models[j].NineClocksMinPrice = emMinValue;
            }
            
            for (NSInteger i = 0, j = 8; j < models.count; i++,j++) {
                CGFloat emMinValue = 10000000000;
                
                NSInteger em = j;
                
                while ( em >= i ) {
                    if([@(10000000000) compare:@(models[em].lowestPrice)] == cond) {
                        emMinValue = models[em].lowestPrice;
                    }
                    em--;
                }
                models[j].NineClocksMinPrice = emMinValue;
            }
        }
            break;
        default:
            break;
    }
}

- (void)initWithValues:(NSArray *)arr {
    NSAssert(arr.count == 6, @"数组长度不足");

    if (self)  {
        _date = [NSString stringWithFormat:@"%zd", arr[0]];
        _openingPrice = [arr[1] floatValue];
        _highestPrice = [arr[2] floatValue];
        _lowestPrice = [arr[3] floatValue];
        _closingPrice = [arr[4] floatValue];
        _volume = [arr[5] floatValue];
        self.SumOfLastClose = _closingPrice + self.PreviousKlineModel.SumOfLastClose;
        self.SumOfLastVolume = _volume + self.PreviousKlineModel.SumOfLastVolume;
//        NSLog(@"%@======%@======%@------%@",_Close,self.MA7,self.MA30,_SumOfLastClose);
 
    }
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
    _NineClocksMinPrice = _lowestPrice;
    _NineClocksMaxPrice = _highestPrice;
    [self DIF];
    [self DEA];
    [self MACD];
    [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedAscending];
    [self rangeLastNinePriceByArray:self.ParentGroupModel.models condition:NSOrderedDescending];
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
    [self NineClocksMaxPrice];
    [self NineClocksMinPrice];
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

@end
