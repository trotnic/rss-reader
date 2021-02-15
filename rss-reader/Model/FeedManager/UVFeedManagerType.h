//
//  UVFeedManagerType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 15.02.21.
//

#import <Foundation/Foundation.h>
#import "UVFeedChannel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVFeedManagerType <NSObject>

- (UVFeedChannel *)channelFeed;
- (void)provideRawFeed:(NSDictionary *)feed error:(NSError **)error;
- (UVFeedItem *)selectedItem;
- (void)selectItem:(UVFeedItem *)item;

@end

NS_ASSUME_NONNULL_END
