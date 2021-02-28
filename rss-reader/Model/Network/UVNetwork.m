//
//  UVNetwork.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 1.01.21.
//

#import "Reachability.h"
#import "UVErrorDomain.h"
#import "UVNetwork.h"

#import "NSArray+Util.h"

void *kObserversContext = &kObserversContext;

static NSString *const SECURE_SCHEME        = @"https";
static NSString *const STUB_RELATIVE_PATH   = @"";

@interface UVNetwork ()

@property (nonatomic, strong) id<ReachabilityType> reachability;
@property (nonatomic, strong) NSMutableDictionary<NSString *, UVNetworkNotificationCallback> *observers;
@property (nonatomic, strong) dispatch_semaphore_t synchronizationSemaphore;

@end

@implementation UVNetwork

- (void)dealloc
{
    [self.reachability stopNotifier];
}

// MARK: - Lazy Properties

- (id<ReachabilityType>)reachability {
    if (!_reachability) {
        _reachability = Reachability.reachabilityForInternetConnection;
        if ([_reachability startNotifier]) {
            [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(respondReachability:)
                                                       name:kReachabilityChangedNotification object:nil];
        }
    }
    return _reachability;
}

- (dispatch_semaphore_t)synchronizationSemaphore {
    if (!_synchronizationSemaphore) {
        _synchronizationSemaphore = dispatch_semaphore_create(1);
    }
    return _synchronizationSemaphore;
}

- (NSMutableDictionary<NSString *, UVNetworkNotificationCallback> *)observers {
    if (!_observers) {
        _observers = [NSMutableDictionary new];
    }
    return _observers;
}

// MARK: - Interface

- (void)fetchDataFromURL:(NSURL *)url
              completion:(void (^)(NSData *, NSError *))completion {
    [NSThread detachNewThreadWithBlock:^{
        @autoreleasepool {
            NSError *error = nil;
            NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
            if (completion) completion(data, error);
        }
    }];
}

- (NSURL *)validateAddress:(NSString *)address error:(out NSError **)error {
    if (!address || !address.length) {
        [self provideErrorForReference:error];
        return nil;
    }
    NSURL *newURL = [NSURL URLWithString:STUB_RELATIVE_PATH
                           relativeToURL:[NSURL URLWithString:address]].absoluteURL;
    
    if (!newURL.host) {
        [self provideErrorForReference:error];
        return nil;
    }
    
    return [self enhanceSchemeOfURL:newURL error:error];
}

- (NSURL *)validateURL:(NSURL *)url error:(out NSError **)error {
    if(!url || !url.absoluteString.length) {
        [self provideErrorForReference:error];
        return nil;
    }
    NSURL *newURL = [NSURL URLWithString:STUB_RELATIVE_PATH
                           relativeToURL:url].absoluteURL;
    return [self enhanceSchemeOfURL:newURL error:error];
}

- (BOOL)isConnectionAvailable {
    return self.reachability.currentReachabilityStatus == ReachableViaWWAN ||
    self.reachability.currentReachabilityStatus == ReachableViaWiFi;
}

// MARK: - Posting

- (void)registerObserver:(NSString *)observer
                callback:(UVNetworkNotificationCallback)callback {
    dispatch_semaphore_wait(self.synchronizationSemaphore, DISPATCH_TIME_NOW);
    self.observers[observer] = callback;
    dispatch_semaphore_signal(self.synchronizationSemaphore);
}

- (void)unregisterObserver:(NSString *)observer {
    dispatch_semaphore_wait(self.synchronizationSemaphore, DISPATCH_TIME_NOW);
    [self.observers removeObjectForKey:observer];
    dispatch_semaphore_signal(self.synchronizationSemaphore);
}

- (BOOL)isObservedBy:(NSString *)observer {
    return [self.observers.allKeys containsObject:observer];
}

- (void)respondReachability:(NSNotification *)notification {
    [self.observers.allValues forEach:^(UVNetworkNotificationCallback callback) {
        if (callback) callback([notification.object[kReachabilityIsConnectionStable] boolValue]);
    }];
}

// MARK: - Private

- (NSError *)urlError {
    return [NSError errorWithDomain:UVNetworkErrorDomain code:100000 userInfo:nil];
}

- (BOOL)provideErrorForReference:(out NSError **)error {
    if (error) *error = [self urlError];
    return YES;
}

- (NSURL *)enhanceSchemeOfURL:(NSURL *)url error:(out NSError **)error {
    if (!url) {
        [self provideErrorForReference:error];
        return nil;
    }
    if (!url.scheme) {
        NSURLComponents *comps = [NSURLComponents componentsWithURL:url
                                            resolvingAgainstBaseURL:YES];
        comps.scheme = SECURE_SCHEME;
        url = comps.URL;
    }
    return url;
}

@end
