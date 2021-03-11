//
//  UVRSSFeed.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "UVRSSLink.h"
#import "UVFeedChannelDisplayModel.h"
#import "UVFeedChannelKeys.h"
#import "UVRSSFeedItem.h"
#import "UVPropertyListConvertible.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVRSSFeed : NSObject <UVFeedChannelDisplayModel, UVPropertyListConvertible>

// LINKS:
@property (nonatomic, strong, readonly) UVRSSLink *link;
//@property (nonatomic, copy, readonly) NSString *title;
//@property (nonatomic, strong, readonly) NSURL *url;
//@property (nonatomic, copy, readonly) NSString *summary;
// FEED: mutable?
@property (nonatomic, strong) NSMutableSet<UVRSSFeedItem *> *feedItems;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

- (void)changeStateOf:(UVRSSFeedItem *)item state:(UVRSSItemState)state;
- (void)setLinkIfNil:(UVRSSLink *)link;
- (void)setRawFeedIfNil:(NSArray<NSDictionary *> *)rawFeed;

- (BOOL)isEqualToLink:(UVRSSLink *)link;

@end

NS_ASSUME_NONNULL_END
