//
//  FeedChannelViewModel.h
//  rss-reader
//
//  Created by Uladzislau on 11/19/20.
//

#import <Foundation/Foundation.h>
#import "FeedItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FeedChannelViewModel <NSObject>

- (NSString *)channelTitle;
- (NSArray<id<FeedItemViewModel>> *)channelItems;

@end

NS_ASSUME_NONNULL_END
