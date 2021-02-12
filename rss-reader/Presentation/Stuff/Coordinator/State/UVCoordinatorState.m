//
//  UVCoordinatorState.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11.02.2021.
//

#import "UVCoordinatorState.h"

@implementation UVCoordinatorState

- (instancetype)initWithIdentifier:(NSInteger)identifier {
    self = [super init];
    if (self) {
        _identifier = identifier;
    }
    return self;
}

@end
