//
//  FeedProviderType.h
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import <Foundation/Foundation.h>
#import "RSSError.h"

NS_ASSUME_NONNULL_BEGIN

@class FeedChannel;

@protocol FeedProviderType <NSObject>

- (void)fetchDataFromURL:(NSURL *)url completion:(void(^)(FeedChannel *, RSSError))completion;

@end

NS_ASSUME_NONNULL_END
