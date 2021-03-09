//
//  UVStack.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 07.03.2021.
//

#import "UVStack.h"

@interface UVStack ()

@property (nonatomic, strong) NSMutableArray *stack;

@end

@implementation UVStack

// MARK: - Lazy Properties

- (NSMutableArray *)stack {
    if (!_stack) {
        _stack = [NSMutableArray new];
    }
    return _stack;
}

// MARK: - Interface

- (void)push:(id)obj {
    [self.stack addObject:obj];
}

- (id)peek {
    return self.stack.lastObject;
}

- (id)pop {
    id last = self.stack.lastObject;
    [self.stack removeLastObject];
    return last;
}

@end
