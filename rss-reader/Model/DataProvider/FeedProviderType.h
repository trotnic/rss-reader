//
//  FeedProviderType.h
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FeedChannel;

@protocol FeedProviderType <NSObject>

- (void)fetchData:(void(^)(FeedChannel *_Nullable, NSError *_Nullable))completion;

@end

NS_ASSUME_NONNULL_END
