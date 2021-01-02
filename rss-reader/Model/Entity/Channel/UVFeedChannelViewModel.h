//
//  UVFeedChannelViewModel.h
//  rss-reader
//
//  Created by Uladzislau on 11/19/20.
//

#import <Foundation/Foundation.h>
#import "UVFeedItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVFeedChannelViewModel <NSObject>

- (NSString *)channelTitle;
- (NSArray<id<UVFeedItemViewModel>> *)channelItems;

@end

NS_ASSUME_NONNULL_END
