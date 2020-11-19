//
//  FeedProviderType.h
//  rss-reader
//
//  Created by Uladzislau on 11/19/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FeedChannel;
typedef void(^FeedHandler)(FeedChannel *);

@protocol FeedProviderType <NSObject>

- (void)fetchFeedWithCompletion:(FeedHandler)completion;

@end

NS_ASSUME_NONNULL_END
