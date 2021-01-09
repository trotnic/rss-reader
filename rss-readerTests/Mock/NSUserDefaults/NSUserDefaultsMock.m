//
//  NSUserDefaultsMock.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 9.01.21.
//

#import "NSUserDefaultsMock.h"

@implementation NSUserDefaultsMock

- (instancetype)init
{
    return [self initWithSuiteName:NSStringFromClass(NSUserDefaultsMock.class)];
}

- (instancetype)initWithSuiteName:(NSString *)suitename {
    [[NSUserDefaults new] removeSuiteNamed:suitename];
    self = [super initWithSuiteName:suitename];
    return self;
}
@end
