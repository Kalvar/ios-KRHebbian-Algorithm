## What is it ?

KRHebbian is a non-supervisor and self-learning algorithm (adjust the weights) in neural network of Machine Learning (自分学習アルゴリズム).

#### Podfile

```ruby
platform :ios, '7.0'
pod "KRHebbian", "~> 1.0.2"
```

## How To Get Started

``` objective-c
#import "KRHebbianAlgorithm.h"

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self runHebbian];
}

#pragma Hebbian Learning Rule
-(void)runHebbian
{
    //Initial Weights ( W1 )
    NSMutableArray *_weights1 = [NSMutableArray arrayWithObjects:@"0.5",@"0",@"-1", @"1", nil];
    NSMutableArray *_initialWeights = [NSMutableArray arrayWithObject:_weights1];
    
    //Inputs ( X1 )
    NSMutableArray *_x1 = [NSMutableArray arrayWithObjects:@"0",@"1.5",@"-2", @"1", nil];
    
    KRHebbianAlgorithm *_krHebbian = [[KRHebbianAlgorithm alloc] init];
    _krHebbian.theta   = 1.0f;
    _krHebbian.weights = _initialWeights;
    _krHebbian.params  = _x1;
    [_krHebbian training];
    
    NSLog(@"( Hebbian Retults ) Adjusts next Weights : %@", _krHebbian.deltaWeights);
}

//Transpose the Matrix
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
```

## Version

V1.0.2

## LICENSE

MIT.

