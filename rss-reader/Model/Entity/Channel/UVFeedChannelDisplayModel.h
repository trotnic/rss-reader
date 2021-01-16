//
//  UVFeedChannelDisplayModel.h
//  rss-reader
//
//  Created by Uladzislau on 11/19/20.
//

#import <Foundation/Foundation.h>
#import "UVFeedItemDisplayModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVFeedChannelDisplayModel <NSObject>

- (NSString *)channelTitle;
- (NSArray<id<UVFeedItemDisplayModel>> *)channelItems;

@end

NS_ASSUME_NONNULL_END
