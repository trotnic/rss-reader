//
//  UVRSSFeed.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "UVRSSFeed.h"
#import "NSArray+Util.h"

@interface UVRSSFeed ()

@property (nonatomic, copy, readwrite) NSString *link;
@property (nonatomic, copy, readwrite) NSString *summary;

@end

@implementation UVRSSFeed

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary || !dictionary.count) {
        NSLog(@"Unwanted behavior:\n%s\nargument:\n%@", __PRETTY_FUNCTION__, dictionary);
        return nil;
    }
    
    UVRSSFeed *object = [UVRSSFeed new];
    
    object.link = dictionary[kRSSChannelLink];
    object.summary = dictionary[kRSSChannelDescription];
    NSArray *items = [dictionary[kRSSChannelItems] map:^UVRSSFeedItem *(NSDictionary *rawItem) {
        return [UVRSSFeedItem objectWithDictionary:rawItem];
    }];
    object.feedItems = [NSMutableSet setWithArray:items];
    
    return [object autorelease];
}

- (NSDictionary *)dictionaryFromObject {
    return @{
        kRSSChannelLink : self.link,
        kRSSChannelDescription : self.summary,
        kRSSChannelItems : [self.feedItems.allObjects map:^NSDictionary *(UVRSSFeedItem *item) {
            return item.dictionaryFromObject;
        }]
    };
}

- (void)dealloc
{
    [_link release];
    [_feedItems release];
    [_summary release];
    [super dealloc];
}

- (BOOL)isEqual:(UVRSSFeed *)other
{
    return [self.link isEqualToString:other.link];
}

// MARK: - Interface

- (void)changeStateOf:(UVRSSFeedItem *)item state:(UVRSSItemOptionState)state {
    [[self.items find:^BOOL(UVRSSFeed *obj) {
        return [item isEqual:obj];
    }] setReadingState:state];
}

- (NSArray<id<UVFeedItemDisplayModel>> *)items {
    return self.feedItems.allObjects;
}

@end
