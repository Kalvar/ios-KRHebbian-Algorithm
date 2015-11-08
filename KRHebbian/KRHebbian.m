//
//  KRHebbian.m
//  KRHebbian
//
//  Created by Kalvar ( ilovekalvar@gmail.com ) on 13/6/13.
//  Copyright (c) 2013 - 2014年 Kuo-Ming Lin. All rights reserved.
//

#import "KRHebbian.h"

#define DEFAULT_LEARNING_RATE     0.5f
#define DEFAULT_ITERATION         0
#define DEFAULT_MAX_ITERATION     1
#define DEFAULT_CONVERGENCE_VALUE 0.0f
#define DEFAULT_DELTA_SUMMATION   0.0f

@interface KRHebbian ()

@property (nonatomic, assign) NSInteger iteration;
@property (nonatomic, assign) float lastDeltaSummation; // 上一次的權重總變化量
@property (nonatomic, assign) float deltaSummation;     // 當前的權重總給化量

@end

@implementation KRHebbian (fixHebbian)

// Tanh() which scope is [-1.0, 1.0]
-(double)_fOfTanh:(float)_x
{
    return ( 2.0f / ( 1.0f + pow(M_E, (-2.0f * _x)) ) ) - 1.0f;
}

// SGN() which scope is (-1, 1) or (0, 1)
-(float)_fOfSgn:(double)_sgnValue
{
    return ( _sgnValue >= 0.0f ) ? 1.0f : -1.0f;
}

/*
 * @ Step 1. 求出 Net
 * @ Step 2. 求出 sgn()
 *
 * @ 回傳 sgn()
 *
 */
-(double)_fOfNetWithInputs:(NSArray *)_inputs
{
    double _sum      = 0.0f;
    NSInteger _index = 0;
    for( NSNumber *_xValue in _inputs )
    {
        _sum += [_xValue doubleValue] * [[self.weights objectAtIndex:_index] doubleValue];
        ++_index;
    }
    
    NSLog(@"_sum : %lf", _sum);
    
    double _activatedValue = 0.0f;
    switch (self.activeFunction)
    {
        case KRHebbianActiveFunctionByTanh:
            _activatedValue = [self _fOfTanh:_sum];
            break;
        default:
            _activatedValue = [self _fOfSgn:_sum];
            break;
    }
    return _activatedValue;
}

/*
 * @ Step 3. 求 New Weights
 */
-(void)_turningWeightsByInputs:(NSArray *)_inputs netOutput:(double)_netOutput
{
    NSArray *_weights           = self.weights;
    float _learningRate         = self.learningRate;
    NSMutableArray *_newWeights = [NSMutableArray new];
    NSInteger _index            = 0;
    for( NSNumber *_weightValue in _weights )
    {
        double _deltaWeight  = ( _learningRate * _netOutput * [[_inputs objectAtIndex:_index] doubleValue] );
        double _newWeight    = [_weightValue floatValue] + _deltaWeight;
        [_newWeights addObject:[NSNumber numberWithDouble:_newWeight]];
        ++_index;
        self.deltaSummation += fabs(_deltaWeight);
    }
    [self.weights removeAllObjects];
    [self.weights addObjectsFromArray:_newWeights];
}

// Start in calculate net outputs and tune the weights (if needed)
-(void)_doTrainAndDoesWannaTuneWeights:(BOOL)_goTuning
{
    for( NSArray *_inputs in self.patterns )
    {
        double _netOutput = [self _fOfNetWithInputs:_inputs];
        [self.outputs addObject:[NSNumber numberWithDouble:_netOutput]];
        if( _goTuning )
        {
            [self _turningWeightsByInputs:_inputs netOutput:_netOutput];
        }
    }
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
        _learningRate     = DEFAULT_LEARNING_RATE;
        _weights          = [NSMutableArray new];
        _patterns         = [NSMutableArray new];
        _outputs          = [NSMutableArray new];
        
        _iteration        = DEFAULT_ITERATION;
        _maxIteration     = DEFAULT_MAX_ITERATION;
        _convergenceValue = DEFAULT_CONVERGENCE_VALUE;
        
        _activeFunction   = KRHebbianActiveFunctionBySgn;
        _deltaSummation   = DEFAULT_DELTA_SUMMATION;
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
    [_outputs removeAllObjects];
    _lastDeltaSummation = _deltaSummation;
    _deltaSummation     = 0.0f;
    ++_iteration;
    [self _doTrainAndDoesWannaTuneWeights:YES];
    
    /*
     * @ 收斂方法 (擇一)
     *   - 1. 迭代數達到最大數 (文獻推薦 1 迭代)
     *   - 2. 前後迭代的權重變化量相減，小於等於收斂值或為 0 (Optimized method by me, but not usefully in normal cases)
     */
    if( _iteration >= _maxIteration || fabsf(_deltaSummation - _lastDeltaSummation) <= _convergenceValue )
    {
        if( nil != _trainingCompletion )
        {
            _trainingCompletion(YES, _outputs, _weights, _iteration);
        }
    }
    else
    {
        if( nil != _trainingIteraion )
        {
            _trainingIteraion(_iteration, _outputs, _weights);
        }
        [self training];
    }
}

-(void)trainingWithCompletion:(KRHebbianCompletion)_completion
{
    _trainingCompletion = _completion;
    [self training];
}

-(void)directOutputAtInputs:(NSArray *)_inputs completion:(KRHebbianDirectOutput)_completion
{
    [self reset];
    [self addPatterns:_inputs];
    [self _doTrainAndDoesWannaTuneWeights:NO];
    if( nil != _completion )
    {
        _completion(_outputs, _weights);
    }
}

-(void)reset
{
    _maxIteration = DEFAULT_MAX_ITERATION;
    _iteration    = DEFAULT_ITERATION;
    [_patterns removeAllObjects];
    [_outputs removeAllObjects];
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


