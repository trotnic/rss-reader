//
//  UVObservable.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 10.03.21.
//

#import "UVObservable.h"

@interface UVObservable ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, observableCallback> *observers;
@property (nonatomic, strong) dispatch_semaphore_t sync_semaphore;

@end

@implementation UVObservable

// MARK: - Lazy Properties

- (NSMutableDictionary<NSString *,observableCallback> *)observers {
    if (!_observers) {
        _observers = [NSMutableDictionary new];
    }
    return _observers;
}

- (dispatch_semaphore_t)sync_semaphore {
    if (!_sync_semaphore) {
        _sync_semaphore = dispatch_semaphore_create(1);
    }
    return _sync_semaphore;
}

// MARK: - Interface

- (void)registerObserver:(NSString *)observer callback:(observableCallback)callback {
    dispatch_semaphore_wait(self.sync_semaphore, DISPATCH_TIME_NOW);
    self.observers[observer] = callback;
    dispatch_semaphore_signal(self.sync_semaphore);
}

- (void)unregisterObserver:(NSString *)observer {
    dispatch_semaphore_wait(self.sync_semaphore, DISPATCH_TIME_NOW);
    [self.observers removeObjectForKey:observer];
    dispatch_semaphore_signal(self.sync_semaphore);
}

- (void)notifyObservers:(void (^)(observableCallback))callback {
    for (observableCallback observer in self.observers.allValues)
        if (callback) callback(observer);
}

- (BOOL)isObservedBy:(NSString *)observer {
    return [self.observers.allKeys containsObject:observer];
}

@end
