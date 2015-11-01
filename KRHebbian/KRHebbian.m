//
//  KRHebbian.m
//  KRHebbian
//
//  Created by Kalvar ( ilovekalvar@gmail.com ) on 13/6/13.
//  Copyright (c) 2013 - 2014年 Kuo-Ming Lin. All rights reserved.
//

#import "KRHebbian.h"

@interface KRHebbian ()

@property (nonatomic, assign) NSInteger iteration;

@end

@implementation KRHebbian (fixNets)
/*
 * @ 求 SGN()
 */
-(NSInteger)_sgn:(double)_sgnValue
{
    return ( _sgnValue >= 0.0f ) ? 1 : -1;
}

/*
 * @ Step 1. 求出 Net
 * @ Step 2. 求出 sgn()
 *
 * @ 回傳 sgn()
 *
 */
-(NSInteger)_fOfNetWithInputs:(NSArray *)_inputs
{
    double _sum      = 0.0f;
    NSInteger _index = 0;
    for( NSNumber *_xValue in _inputs )
    {
        _sum += [_xValue floatValue] * [[self.weights objectAtIndex:_index] floatValue];
        ++_index;
    }
    return [self _sgn:_sum];
}

/*
 * @ Step 3. 求 delta W (下一節點之權重值)
 */
-(void)_turningWeightsByInputs:(NSArray *)_inputs
{
    NSArray *_weights           = self.weights;
    float _learningRate         = self.learningRate;
    float _netOutput            = [self _fOfNetWithInputs:_inputs];
    NSMutableArray *_newWeights = [NSMutableArray new];
    NSInteger _index            = 0;
    for( NSNumber *_weightValue in _weights )
    {
        float _deltaWeight  = ( _learningRate * _netOutput * [[_inputs objectAtIndex:_index] floatValue] );
        float _newWeight    = [_weightValue floatValue] + _deltaWeight;
        [_newWeights addObject:[NSNumber numberWithFloat:_newWeight]];
        ++_index;
    }
    [self.weights removeAllObjects];
    [self.weights addObjectsFromArray:_newWeights];
}

@end

@implementation KRHebbian

+(instancetype)sharedAlgorithm
{
    static dispatch_once_t pred;
    static KRHebbian *_object = nil;
    dispatch_once(&pred, ^{
        _object = [[KRHebbian alloc] init];
    });
    return _object;
}

-(instancetype)init
{
    self = [super init];
    if( self )
    {
        _learningRate = 0.5f;
        _weights      = [NSMutableArray new];
        _patterns     = [NSMutableArray new];
        
        _iteration    = 0;
        _maxIteration = 1;
    }
    return self;
}

#pragma --mark Public Hebbian Algorithm
-(void)addPatterns:(NSArray *)_inputs
{
    [_patterns addObject:_inputs];
}

-(void)initializeWeights:(NSArray *)_initWeights
{
    if( [_weights count] > 0 )
    {
        [_weights removeAllObjects];
    }
    [_weights addObjectsFromArray:_initWeights];
}

-(void)training
{
    ++_iteration;
    for( NSArray *_inputs in _patterns )
    {
        [self _turningWeightsByInputs:_inputs];
    }
    
    if( _iteration >= _maxIteration )
    {
        if( nil != _trainingCompletion )
        {
            _trainingCompletion(YES, _weights, _iteration);
        }
    }
    else
    {
        if( nil != _trainingIteraion )
        {
            _trainingIteraion(_iteration, _weights);
        }
        [self training];
    }
}

-(void)trainingWithCompletion:(KRHebbianCompletion)_completion
{
    _trainingCompletion = _completion;
    [self training];
}

#pragma --mark Block Setters
-(void)setTrainingCompletion:(KRHebbianCompletion)_block
{
    _trainingCompletion = _block;
}

-(void)setTrainingIteraion:(KRHebbianIteration)_block
{
    _trainingIteraion = _block;
}

@end


