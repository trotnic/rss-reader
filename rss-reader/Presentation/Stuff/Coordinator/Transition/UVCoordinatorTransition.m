//
//  UVCoordinatorTransition.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11.02.2021.
//

#import "UVCoordinatorTransition.h"

@interface UVCoordinatorTransition ()

@end

@implementation UVCoordinatorTransition

- (instancetype)initWithInitial:(UVCoordinatorState *)iState
                       terminal:(UVCoordinatorState *)tState
                     identifier:(NSInteger)identifier {
    self = [super init];
    if (self) {
        _initial = iState;
        _terminal = tState;
        _identifier = identifier;
    }
    return self;
}

@end
