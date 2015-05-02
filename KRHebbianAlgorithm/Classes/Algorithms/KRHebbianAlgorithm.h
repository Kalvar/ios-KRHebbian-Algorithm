//
//  KRHebbianAlgorithm.h
//  KRHebbianAlgorithm
//
//  Created by Kalvar ( ilovekalvar@gmail.com ) on 13/6/13.
//  Copyright (c) 2013 - 2014年 Kuo-Ming Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KRHebbianAlgorithm : NSObject
{
    //學習速率 ( eta )
    CGFloat theta;
    //初始權重陣列 ( 2 維, 未轉矩 )
    NSArray *weights;
    //初始參數陣列 ( 1 維 )
    NSArray *params;
    //運算完成的新權重 ( 1 維 )
    NSMutableArray *deltaWeights;
}

@property (nonatomic, assign) CGFloat theta;
@property (nonatomic, strong) NSArray *weights;
@property (nonatomic, strong) NSArray *params;
@property (nonatomic, strong) NSMutableArray *deltaWeights;

+(instancetype)sharedAlgorithm;
-(NSMutableArray *)transposeMatrix:(NSArray *)_matrix;
-(void)transposeWeights;
-(NSMutableArray *)training;

@end
