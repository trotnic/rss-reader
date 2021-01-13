//
//  UVNetworkType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 1.01.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVNetworkType <NSObject>

- (void)fetchDataFromURL:(NSURL *)url completion:(void(^)(NSData *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
