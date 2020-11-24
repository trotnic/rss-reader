//
//  NetworkServiceType.h
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NetworkServiceType <NSObject>

- (void)fetchWithURL:(NSURL *)url completion:(void(^)(NSData *_Nullable, NSError *_Nullable))completion;
- (void)fetchWithRequest:(NSURLRequest *)request completion:(void(^)(NSData *_Nullable, NSError *_Nullable))completion;

@end

NS_ASSUME_NONNULL_END
