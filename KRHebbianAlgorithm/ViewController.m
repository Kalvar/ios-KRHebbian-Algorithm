//
//  ViewController.m
//  KRHebbianAlgorithm
//  
//  Created by Kalvar ( ilovekalvar@gmail.com ) on 13/6/13.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import "ViewController.h"
#import "KRHebbianAlgorithm.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self runHebbian];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Hebbian Learning Rule
-(void)runHebbian
{
    //神經元 1 權重（ X 向 ）( W1 )
    NSMutableArray *_weights1 = [NSMutableArray arrayWithObjects:@"0.5",@"0",@"-1", @"1", nil];
    NSMutableArray *_initialWeights = [NSMutableArray arrayWithObject:_weights1];
    //輸入 X1 向量 ( Y 向 )
    NSMutableArray *_x1 = [NSMutableArray arrayWithObjects:@"0",@"1.5",@"-2", @"1", nil];
    //
    KRHebbianAlgorithm *_krHebbian = [[KRHebbianAlgorithm alloc] init];
    _krHebbian.theta   = 1.0f;
    _krHebbian.weights = _initialWeights;
    _krHebbian.params  = _x1;
    [_krHebbian transposeWeights];
    [_krHebbian runHebbian];
    
    NSLog(@"( Hebbian Retults ) Adjusts next Weights : %@", _krHebbian.deltaWeights);
}

//轉置矩陣
-(void)transposeMatrix
{
    NSMutableArray *row1 = [NSMutableArray arrayWithObjects:@"1",@"2",@"3", nil];
    NSMutableArray *row2 = [NSMutableArray arrayWithObjects:@"4",@"5",@"6", nil];
    NSMutableArray *row3 = [NSMutableArray arrayWithObjects:@"7",@"8",@"9", nil];
    NSMutableArray *rows = [NSMutableArray arrayWithObjects:row1,row2,row3, nil];
    
    KRHebbianAlgorithm *_krHebbian = [[KRHebbianAlgorithm alloc] init];
    //NSLog(@"trans : %@", [_krHebbian transposeMatrix:row1]);
    
    NSMutableArray *_transposedMatrix = [_krHebbian transposeMatrix:rows];
    NSLog(@"_transposedMatrix : %@", _transposedMatrix);
}


@end
