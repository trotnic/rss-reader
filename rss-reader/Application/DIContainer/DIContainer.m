//
//  DIContainer.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11/26/20.
//

#import "DIContainer.h"

@interface DIContainer ()

@property (nonatomic, retain) NSMutableDictionary<NSString *, FactoryBlock> *services;

@end

@implementation DIContainer

- (void)dealloc
{
    [_services release];
    [super dealloc];
}

- (void)registerServiceOfType:(NSString *)type
               withCompletion:(FactoryBlock)completion {
    self.services[type] = [[completion copy] autorelease];
}

- (id)resolveServiceOfType:(NSString *)type {
    return [self.services[type](self) autorelease];
}

// MARK: - Lazy

- (NSMutableDictionary<NSString *,FactoryBlock> *)services {
    if(!_services) {
        _services = [NSMutableDictionary new];
    }
    return _services;
}

@end
