//
//  FeedViewType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FeedItemViewModel;

@protocol FeedViewType <NSObject>

- (void)setFeed:(NSArray<id<FeedItemViewModel>> *)feed;

@end

NS_ASSUME_NONNULL_END
