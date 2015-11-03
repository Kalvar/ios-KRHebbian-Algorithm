## About

KRHebbian implemented Hebbian algorithm that is a non-supervisor of self-organization algorithm of Machine Learning (自分学習アルゴリズム).

#### Podfile

```ruby
platform :ios, '7.0'
pod "KRHebbian", "~> 1.2.1"
```

## How To Get Started

#### Import
``` objective-c
#import "KRHebbian.h"
```

#### Sample
``` objective-c
KRHebbian *_hebbian   	= [KRHebbian sharedAlgorithm];
_hebbian.activeFunction = KRHebbianActiveFunctionBySgn;  // Tanh() for [-1.0, 1.0], Sgn() for (-1, 1)
_hebbian.learningRate 	= 0.8f;
_hebbian.maxIteration 	= 1;
[_hebbian addPatterns:@[@0.0f, @1.5f, @-2.0f, @1.0f]];   // X1
[_hebbian addPatterns:@[@-1.5f, @-2.0f, @-0.5f, @1.0f]]; // X2
[_hebbian initializeWeights:@[@0.5f, @0.0f, @-1.0f, @1.0f]];
[_hebbian setTrainingIteraion:^(NSInteger iteration, NSArray *weights) {
    NSLog(@"%li iteration = %@", iteration, weights);
}];
[_hebbian trainingWithCompletion:^(BOOL success, NSArray *weights, NSInteger totalIteration) {
    NSLog(@"%li iteration = %@", totalIteration, weights);
}];
```

## Version

V1.2.1

## LICENSE

MIT.

