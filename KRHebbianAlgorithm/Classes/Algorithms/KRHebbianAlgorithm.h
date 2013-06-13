//
//  KRHebbianAlgorithm.h
//  KRHebbianAlgorithm
//
//  Created by Kalvar ( ilovekalvar@gmail.com ) on 13/6/13.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KRHebbianAlgorithm : NSObject
{
    //學習速率 ( eta )
    CGFloat theta;
    //初始權重陣列 ( 未轉矩 )
    NSArray *weights;
    //初始參數陣列
    NSArray *params;
    //運算完成的新權重
    NSMutableArray *deltaWeights;
}

@property (nonatomic, assign) CGFloat theta;
@property (nonatomic, strong) NSArray *weights;
@property (nonatomic, strong) NSArray *params;
@property (nonatomic, strong) NSMutableArray *deltaWeights;

-(NSMutableArray *)transposeMatrix:(NSArray *)_matrix;
-(double)sumTransposedMatrix:(NSArray *)_transposedMatrix multiplyMatrix:(NSArray *)_multiplicandMatrix;
-(NSMutableArray *)weightMatrix:(NSArray *)_weightMatrix plusMatrix:(NSArray *)_plusMatrix theMark:(double)_mark;
-(NSInteger)sgn:(double)_sgnValue;
-(void)transposeWeights;
-(NSMutableArray *)runHebbian;


@end
