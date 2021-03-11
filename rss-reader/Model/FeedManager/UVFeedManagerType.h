//
//  UVFeedManagerType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 15.02.21.
//

#import <Foundation/Foundation.h>
#import "UVRSSFeed.h"
#import "UVRSSItemState.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVFeedManagerType <NSObject>

@property (nonatomic, strong, readonly) NSArray<UVRSSFeed *> *currentFeeds;

- (NSArray<UVRSSFeedItem *> *)feedItemsWithState:(UVRSSItemState)state;
- (BOOL)containsLink:(UVRSSLink *)link;
// LINKS: ❗️
/**
 add a feed to an array?
 */
// ------------------------------------------------
- (BOOL)storeFeed:(NSDictionary *)feed error:(NSError **)error;
- (BOOL)storeFeed:(NSArray<NSDictionary *> *)feed forLink:(UVRSSLink *)link error:(NSError **)error;
// ------------------------------------------------
- (void)deleteFeed:(UVRSSFeed *)feed;
- (void)setState:(UVRSSItemState)state ofFeedItem:(UVRSSFeedItem *)item;
- (void)selectFeedItem:(UVRSSFeedItem *)item;
- (void)deleteFeedItem:(UVRSSFeedItem *)item;
- (UVRSSFeedItem *)selectedFeedItem;

@end

NS_ASSUME_NONNULL_END
