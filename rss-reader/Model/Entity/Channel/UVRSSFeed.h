//
//  UVRSSFeed.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "UVFeedChannelDisplayModel.h"
#import "UVFeedChannelKeys.h"
#import "UVRSSFeedItem.h"
#import "UVPropertyListConvertible.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVRSSFeed : NSObject <UVFeedChannelDisplayModel, UVPropertyListConvertible>

@property (nonatomic, copy, readonly) NSString *link;
@property (nonatomic, copy, readonly) NSString *summary;
// FEED: mutable?
@property (nonatomic, strong) NSMutableSet<UVRSSFeedItem *> *feedItems;

- (void)changeStateOf:(UVRSSFeedItem *)item state:(UVRSSItemState)state;

@end

NS_ASSUME_NONNULL_END
