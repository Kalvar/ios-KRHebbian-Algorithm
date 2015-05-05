//
//  KRHebbian.m
//  KRHebbian
//
//  Created by Kalvar ( ilovekalvar@gmail.com ) on 13/6/13.
//  Copyright (c) 2013 - 2014年 Kuo-Ming Lin. All rights reserved.
//

#import "KRHebbian.h"

@interface KRHebbian ()

//轉置後的權重矩陣
@property (nonatomic, strong) NSMutableArray *_transposedWeights;

@end

@interface KRHebbian (fixPrivate)

-(void)_initWithVars;

@end

@implementation KRHebbian (fixPrivate)

-(void)_initWithVars
{
    self.theta   = 0.0f;
    self.weights = nil;
    self.params  = nil;
    deltaWeights = [[NSMutableArray alloc] initWithCapacity:0];
    self._transposedWeights = [NSMutableArray arrayWithCapacity:0];
}

@end

@interface KRHebbian (fixMatrixes)

-(double)sumTransposedMatrix:(NSArray *)_transposedMatrix multiplyMatrix:(NSArray *)_multiplicandMatrix;
-(NSMutableArray *)weightMatrix:(NSArray *)_weightMatrix plusMatrix:(NSArray *)_plusMatrix theMark:(double)_mark;
-(NSInteger)sgn:(double)_sgnValue;

@end

@implementation KRHebbian (fixMatrixes)
/*
 * @ 累加( 轉置後的矩陣乘以另一個未轉置矩陣 ) ( 直 1 維 x 橫 1 維 )
 *
 *   - 赫賓是 1 維 x 1 維 ( 不需考慮 N 維 )
 *
 *   - 兩個矩陣必須滿足 A 矩陣的行數等於 B 矩陣的列數才可以相乘
 *
 *   - _multiplierMatrix   乘數 ( 轉置後的矩陣 )
 *
 *     @[ @[1], @[2], @[3] ]
 *
 *   - _multiplicandMatrix 被乘數
 *
 *     @[4, 5, 6]
 *
 */
-(double)sumTransposedMatrix:(NSArray *)_transposedMatrix multiplyMatrix:(NSArray *)_multiplicandMatrix
{
    NSUInteger _transposedCount = 1; //[_transposedMatrix count];
    if( [[_transposedMatrix objectAtIndex:0] isKindOfClass:[NSArray class]] )
    {
        _transposedCount = [[_transposedMatrix objectAtIndex:0] count];
    }
    NSUInteger _multiplicandCount = [_multiplicandMatrix count];
    double _sum = 0.0f;
    //轉置矩陣的長度
    for( int i=0; i<_transposedCount; i++ )
    {
        //被乘矩陣的長度
        for( int j=0; j<_multiplicandCount; j++ )
        {
            //NSLog(@"i = %i, j = %i", i, j);
            //避免 Exception for Crash
            if( j > _transposedCount )
            {
                break;
            }
            double _transposedValue   = [[[_transposedMatrix objectAtIndex:j] objectAtIndex:i] doubleValue];
            double _multiplicandValue = [[_multiplicandMatrix objectAtIndex:j] doubleValue];
            //NSLog(@"_transposedValue : %f", _transposedValue);
            //NSLog(@"_multiplicandValue : %f\n\n", _multiplicandValue);
            _sum += _transposedValue * _multiplicandValue;
        }
    }
    return _sum;
}

/*
 * @ 權重矩陣相加(矩陣一, 矩陣二, 標記)
 */
-(NSMutableArray *)weightMatrix:(NSArray *)_weightMatrix plusMatrix:(NSArray *)_plusMatrix theMark:(double)_mark
{
    NSMutableArray *_sums   = [NSMutableArray arrayWithCapacity:0];
    NSUInteger _weightCount = [_weightMatrix count];
    if( _weightCount < [_plusMatrix count] )
    {
        //代表 _weightMatrix 為多維陣列
        _weightCount = [[_weightMatrix objectAtIndex:0] count];
    }
    
    if( _mark > 0 )
    {
        for( int i=0; i<_weightCount; i++ )
        {
            double _weightValue = [[[_weightMatrix objectAtIndex:0] objectAtIndex:i] doubleValue];
            double _matrixValue = [[_plusMatrix objectAtIndex:i] doubleValue];
            [_sums addObject:[NSString stringWithFormat:@"%lf", ( _weightValue + _matrixValue )]];
        }
    }
    
    if( _mark < 0 )
    {
        for( int i=0; i<_weightCount; i++ )
        {
            double _weightValue = [[[_weightMatrix objectAtIndex:0] objectAtIndex:i] doubleValue];
            double _matrixValue = [[_plusMatrix objectAtIndex:i] doubleValue];
            [_sums addObject:[NSString stringWithFormat:@"%lf", ( _weightValue - _matrixValue )]];
        }
    }
    
    return _sums;
}

/*
 * @ 求 SGN()
 */
-(NSInteger)sgn:(double)_sgnValue
{
    return ( _sgnValue >= 0 ) ? 1 : -1;
}

@end

@interface KRHebbian (fixNets)

-(NSInteger)_findFOfNet;
-(NSMutableArray *)_findNextDeltaWeightsWithFOfNet:(NSInteger)_fOfNet;

@end

@implementation KRHebbian (fixNets)
/*
 * @ Step 1. 求出 Net
 * @ Step 2. 求出 sgn()
 *
 * @ 回傳 sgn()
 *
 */
-(NSInteger)_findFOfNet
{
    //W1 & X1
    double _net = [self sumTransposedMatrix:self._transposedWeights multiplyMatrix:self.params];
    //回傳 sgn() 判定值
    return [self sgn:_net];
}

/*
 * @ Step 3. 求 delta W (下一節點之權重值)
 */
-(NSMutableArray *)_findNextDeltaWeightsWithFOfNet:(NSInteger)_fOfNet
{
    double _mark = self.theta * _fOfNet;
    //這裡要用初始的權重矩陣
    return [self weightMatrix:self.weights
                   plusMatrix:self.params
                      theMark:_mark];
}

@end

@implementation KRHebbian

@synthesize theta        = _theta;
@synthesize weights      = _weights;
@synthesize params       = _params;
@synthesize deltaWeights = _deltaWeights;

+(instancetype)sharedAlgorithm
{
    static dispatch_once_t pred;
    static KRHebbian *_object = nil;
    dispatch_once(&pred, ^{
        _object = [[KRHebbian alloc] init];
    });
    return _object;
}

-(id)init
{
    self = [super init];
    if( self )
    {
        [self _initWithVars];
    }
    return self;
}

#pragma --mark Public Matrix Methods
/*
 * @ 轉置矩陣
 *   - 1. 傳入 1 維陣列
 *   - 2. 傳入 2 維陣列
 *   - 3. 傳入 N 維陣列
 */
-(NSMutableArray *)transposeMatrix:(NSArray *)_matrix
{
    /*
     * @ 多維陣列要用多個 Array 互包來完成
     */
    if( !_matrix ) return nil;
    NSMutableArray *_transposedMatrix = [[NSMutableArray alloc] initWithCapacity:0];
    NSInteger _xCount = [_matrix count];
    NSInteger _yCount = 0;
    //如果第 1 個值為陣列
    if( [[_matrix objectAtIndex:0] isKindOfClass:[NSArray class]] )
    {
        //即為 N 維陣列
        _xCount = [[_matrix objectAtIndex:0] count];
        _yCount = [_matrix count];
    }
    
    // 1 維陣列
    if( _yCount == 0 )
    {
        for( int x=0; x<_xCount; x++ )
        {
            [_transposedMatrix addObject:[NSArray arrayWithObject:[_matrix objectAtIndex:x]]];
        }
    }
    else
    {
        for( int x=0; x<_xCount; x++ )
        {
            //轉置，所以 x 總長度為 _yCount
            NSMutableArray *_newRows = [NSMutableArray arrayWithCapacity:_yCount];
            for( int y=0; y<_yCount; y++ )
            {
                //NSLog(@"x = %i, y = %i", x, y);
                if( [[_matrix objectAtIndex:y] isKindOfClass:[NSArray class]] )
                {
                    [_newRows addObject:[[_matrix objectAtIndex:y] objectAtIndex:x]];
                }
                else
                {
                    [_newRows addObject:[_matrix objectAtIndex:y]];
                }
            }
            [_transposedMatrix addObject:_newRows];
        }
    }
    return _transposedMatrix;
}

#pragma --mark Public Hebbian Algorithm
/*
 * @ 先轉置原始權重矩陣
 */
-(void)transposeWeights
{
    self._transposedWeights = [self transposeMatrix:self.weights];
}

/*
 * @ 再執行 Hebbian 
 *   - 求出 f(net) 並轉換成 sgn
 */
-(NSMutableArray *)training
{
    [self transposeWeights];
    self.deltaWeights = [self _findNextDeltaWeightsWithFOfNet:[self _findFOfNet]];
    return _deltaWeights;
}

@end


