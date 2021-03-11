//
//  UVRSSFeed.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "UVRSSFeed.h"

#import "NSArray+Util.h"

@interface UVRSSFeed ()

@property (nonatomic, strong, readwrite) UVRSSLink *link;
//@property (nonatomic, strong, readwrite) NSURL *url;
//@property (nonatomic, copy, readwrite) NSString *summary;

@end

@implementation UVRSSFeed

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary || !dictionary.count) {
        NSLog(@"Unwanted behavior:\n%s\nargument:\n%@", __PRETTY_FUNCTION__, dictionary);
        return nil;
    }
    
    UVRSSFeed *object = [UVRSSFeed new];
    
    object.link = [UVRSSLink objectWithDictionary:dictionary[kRSSChannelLink]];
    
//    object.url = [NSURL URLWithString:dictionary[kRSSChannelLink]];
//    object.summary = dictionary[kRSSChannelDescription];
    NSArray *items = [dictionary[kRSSChannelItems] map:^UVRSSFeedItem *(NSDictionary *rawItem) {
        return [UVRSSFeedItem objectWithDictionary:rawItem];
    }];
    object.feedItems = [NSMutableSet setWithArray:items];
    
    return [object autorelease];
}

- (NSDictionary *)dictionaryFromObject {
    NSArray *items = [self.feedItems.allObjects map:^NSDictionary *(UVRSSFeedItem *item) {
        return item.dictionaryFromObject;
    }];
    return @{
        kRSSChannelLink : [self.link dictionaryFromObject],
//        kRSSChannelDescription : self.summary,
        kRSSChannelItems : items ? items : @[]
    };
}

- (void)dealloc
{
//    [_url release];
    [_feedItems release];
    [_link release];
//    [_summary release];
    [super dealloc];
}

- (BOOL)isEqual:(UVRSSFeed *)other
{
    return [self.link isEqual:other.link];
//    return [self.url isEqual:other.url];
}

// MARK: - Interface

- (void)changeStateOf:(UVRSSFeedItem *)item state:(UVRSSItemState)state {
    [[self.items find:^BOOL(UVRSSFeed *obj) {
        return [item isEqual:obj];
    }] setReadingState:state];
}

- (void)setLinkIfNil:(UVRSSLink *)link {
    if (!_link) _link = [link retain];
}

- (void)setRawFeedIfNil:(NSArray<NSDictionary *> *)rawFeed {
    if (!_feedItems) {
        _feedItems = [NSMutableSet new];
        // LINKS:
        [rawFeed forEach:^(NSDictionary *rawItem) {
            [self.feedItems addObject:[UVRSSFeedItem objectWithDictionary:rawItem]];
        }];
    }
}

- (NSArray<id<UVFeedItemDisplayModel>> *)items {
    return self.feedItems.allObjects;
}

- (BOOL)isEqualToLink:(UVRSSLink *)link {
    return [self.link isEqual:link];
}

@end
