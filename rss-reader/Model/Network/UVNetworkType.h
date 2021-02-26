//
//  UVNetworkType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 1.01.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UVNetworkNotificationCallback)(BOOL isConnectionStable);

@protocol UVNetworkType <NSObject>

- (void)fetchDataFromURL:(NSURL *)url completion:(void(^)(NSData *, NSError *))completion;
- (NSURL * _Nullable)validateURL:(NSURL *)url error:(out NSError ** _Nullable)error;
- (NSURL * _Nullable)validateAddress:(NSString *)address error:(out NSError ** _Nullable)error;
- (BOOL)isConnectionAvailable;

- (void)registerObserver:(NSString *)observer callback:(UVNetworkNotificationCallback)callback;
- (void)unregisterObserver:(NSString *)observer;
- (BOOL)isObservedBy:(NSString *)observer;

@end

NS_ASSUME_NONNULL_END
