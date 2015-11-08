//
//  ViewController.m
//  KRHebbian
//  
//  Created by Kalvar ( ilovekalvar@gmail.com ) on 13/6/13.
//  Copyright (c) 2013 - 2014年 Kuo-Ming Lin. All rights reserved.
//

#import "ViewController.h"
#import "KRHebbian.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    KRHebbian *_hebbian     = [KRHebbian sharedAlgorithm];
    _hebbian.activeFunction = KRHebbianActiveFunctionBySgn;  // Tanh() for [-1.0, 1.0], Sgn() for (-1, 1)
    _hebbian.learningRate   = 1.0f;
    _hebbian.maxIteration   = 1;
    [_hebbian addPatterns:@[@0.0f, @1.5f, @-2.0f, @1.0f]];   // X1
    [_hebbian addPatterns:@[@-1.5f, @-2.0f, @-0.5f, @1.0f]]; // X2
    [_hebbian initializeWeights:@[@0.5f, @0.0f, @-1.0f, @1.0f]];
    
    [_hebbian setTrainingIteraion:^(NSInteger iteration, NSArray *outputs, NSArray *weights) {
        NSLog(@"Training %li iteration = %@, outputs = %@", iteration, weights, outputs);
    }];
    
    [_hebbian trainingWithCompletion:^(BOOL success, NSArray *outputs, NSArray *weights, NSInteger totalIteration) {
        NSLog(@"Trained %li iteration = %@, outputs = %@", totalIteration, weights, outputs);
        // Start in verifying
        [_hebbian directOutputAtInputs:@[@-0.5f, @-1.0f, @-0.2f, @0.5f] completion:^(NSArray *outputs, NSArray *weights) {
            NSLog(@"Verified weights = %@, outputs = %@", weights, outputs);
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
