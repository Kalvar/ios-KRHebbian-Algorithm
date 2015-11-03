//
//  KRHebbian.h
//  KRHebbian
//
//  Created by Kalvar ( ilovekalvar@gmail.com ) on 13/6/13.
//  Copyright (c) 2013 - 2014年 Kuo-Ming Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum KRHebbianActiveFunctions
{
    KRHebbianActiveFunctionBySgn  = 0,
    KRHebbianActiveFunctionByTanh
}KRHebbianActiveFunctions;

typedef void(^KRHebbianCompletion)(BOOL success, NSArray *weights, NSInteger totalIteration);
typedef void(^KRHebbianIteration)(NSInteger iteration, NSArray *weights);

@interface KRHebbian : NSObject

@property (nonatomic, strong) NSMutableArray *patterns;
@property (nonatomic, strong) NSMutableArray *weights;
@property (nonatomic, assign) float learningRate;
@property (nonatomic, assign) NSInteger maxIteration;
@property (nonatomic, assign) float convergenceValue;

@property (nonatomic, assign) KRHebbianActiveFunctions activeFunction;

@property (nonatomic, copy) KRHebbianCompletion trainingCompletion;
@property (nonatomic, copy) KRHebbianIteration trainingIteraion;

+(instancetype)sharedAlgorithm;
-(instancetype)init;

-(void)addPatterns:(NSArray *)_inputs;
-(void)initializeWeights:(NSArray *)_initWeights;
-(void)training;
-(void)trainingWithCompletion:(KRHebbianCompletion)_completion;

-(void)setTrainingCompletion:(KRHebbianCompletion)_block;
-(void)setTrainingIteraion:(KRHebbianIteration)_block;

@end
