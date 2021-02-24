//
//  UVFeedManagerType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 15.02.21.
//

#import <Foundation/Foundation.h>
#import "UVRSSFeed.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVFeedManagerType <NSObject>

- (UVRSSFeed *)feed;
- (UVRSSFeedItem *)selectedFeedItem;
- (BOOL)storeFeed:(NSDictionary *)feed error:(NSError **)error;
- (void)deleteFeed;
- (void)selectFeedItem:(UVRSSFeedItem *)item;

@end

NS_ASSUME_NONNULL_END
