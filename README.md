## What is it ?

KRHebbian ( Hebbian ) is one of learning rules of adjusting weight in neural-network. If you wanna adjust weight in the algorithms of neurl-network ( Ex : BPN ), that you can use this method to adjust the weight everytime.

## How To Get Started

``` objective-c
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
    //
    KRHebbianAlgorithm *_krHebbian = [[KRHebbianAlgorithm alloc] init];
    _krHebbian.theta   = 1.0f;
    _krHebbian.weights = _initialWeights;
    _krHebbian.params  = _x1;
    [_krHebbian transposeWeights];
    [_krHebbian runHebbian];
    
    NSLog(@"( Hebbian Retults ) Finds next Weights : %@", _krHebbian.deltaWeights);
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

V1.0

## LICENSE

MIT.

