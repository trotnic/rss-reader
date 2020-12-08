//
//  UVNetworkManagerType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 7.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVNetworkManagerType <NSObject>

- (void)fetchURL:(NSURL *)url withCompletion:(void(^)(NSData *_Nullable, NSError *_Nullable))completion;

@end

NS_ASSUME_NONNULL_END
