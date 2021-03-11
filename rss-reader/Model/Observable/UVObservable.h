//
//  UVObservable.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 10.03.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^observableCallback)(BOOL);

@interface UVObservable : NSObject

- (void)registerObserver:(NSString *)observer callback:(observableCallback)callback;
- (void)unregisterObserver:(NSString *)observer;
- (void)notifyObservers:(void(^)(observableCallback))callback;
- (BOOL)isObservedBy:(NSString *)observer;

@end

NS_ASSUME_NONNULL_END
