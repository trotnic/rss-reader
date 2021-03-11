//
//  UVFeedManager.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 15.02.21.
//

#import "UVFeedManager.h"
#import "UVErrorDomain.h"

#import "NSArray+Util.h"

@interface UVFeedManager ()

@property (nonatomic, strong) NSMutableArray<UVRSSFeed *> *innerFeeds;
@property (nonatomic, strong) UVRSSFeed *innerFeed;
@property (nonatomic, strong) UVRSSFeedItem *selectedItem;

@property (nonatomic, strong) id<UVSessionType> session;
@property (nonatomic, strong) id<UVPListRepositoryType> repository;

@property (nonatomic, copy, readonly) NSString *feedFileName;

@end

@implementation UVFeedManager

@synthesize selectedItem = _selectedItem;

- (instancetype)initWithSession:(id<UVSessionType>)session
                     repository:(id<UVPListRepositoryType>)repository {
    self = [super init];
    if (self) {
        _session = session;
        _repository = repository;
    }
    return self;
}

// MARK: - Properties

- (NSMutableArray<UVRSSFeed *> *)innerFeeds {
    if (!_innerFeeds) {
        _innerFeeds = [NSMutableArray new];
    }
    return _innerFeeds;
}

- (UVRSSFeedItem *)selectedItem {
    if (!_selectedItem) {
        _selectedItem = [UVRSSFeedItem objectWithDictionary:self.session.lastFeedItem];
    }
    return _selectedItem;
}

- (void)setSelectedItem:(UVRSSFeedItem *)selectedItem {
    if (![_selectedItem isEqual:selectedItem]) {
        _selectedItem = selectedItem;
        self.session.lastFeedItem = selectedItem.dictionaryFromObject;
    }
}

// MARK: - UVFeedManagerType

- (NSArray<UVRSSFeedItem *> *)feedItemsWithState:(UVRSSItemState)state {
    // LINKS:
    NSMutableArray *items = [NSMutableArray new];
    [self.innerFeeds forEach:^(UVRSSFeed *feed) {
        NSArray *filteredByState = [feed.feedItems.allObjects filter:^BOOL(UVRSSFeedItem *item) {
            return (item.readingState & state) != 0;
        }];
        [items addObjectsFromArray:filteredByState];
        //        [items addObjectsFromArray:];
    }];
    return items;
    //    return [self.feed.items filter:^BOOL(UVRSSFeedItem *item) {
    //        return (item.readingState & state) != 0;
    //    }];
}

- (NSArray<UVRSSFeed *> *)currentFeeds {
    return [self.innerFeeds copy];
}

- (BOOL)containsLink:(UVRSSLink *)link {
    for (UVRSSFeed *feed in self.innerFeeds)
        if ([feed.link isEqual:link]) return YES;
    return NO;
}

- (UVRSSFeed *)feed {
    if (!self.innerFeed) {
        NSError *error = nil;
        NSDictionary *raw = [self.repository fetchData:self.feedFileName error:&error].firstObject;
        if (error) return nil;
        self.innerFeed = [UVRSSFeed objectWithDictionary:raw];
    }
    return self.innerFeed;
}

- (UVRSSFeedItem *)selectedFeedItem {
    return self.selectedItem;
}

- (void)setState:(UVRSSItemState)state ofFeedItem:(UVRSSFeedItem *)item {
    // FEED:
    item.readingState = state;
}

- (void)selectFeedItem:(UVRSSFeedItem *)item {
    self.selectedItem = item;
}

- (BOOL)storeFeed:(NSArray<NSDictionary *> *)rawFeed
          forLink:(UVRSSLink *)link
            error:(NSError *__autoreleasing  _Nullable *)error {
    if (!rawFeed || ![rawFeed isKindOfClass:NSArray.class]) {
        if (error) *error = [self feedError];
        return NO;
    }
    
    // LINKS:
    UVRSSFeed *feed = [UVRSSFeed new];
    [feed setRawFeedIfNil:rawFeed];
    [feed setLinkIfNil:link];
    /**
     maybe check for existence
     */
    [self.innerFeeds addObject:feed];
    
    return [self.repository updateData:[self.innerFeeds map:^id (UVRSSFeed *feed) {
        return feed.dictionaryFromObject;
    }] file:self.feedFileName error:error];
}

// LINKS:
/**
 under question
 */
//- (BOOL)storeFeed:(NSDictionary *)rawFeed error:(NSError **)error {
//    if (!rawFeed || ![rawFeed isKindOfClass:NSDictionary.class]) {
//        if (error) *error = [self feedError];
//        return NO;
//    }
//
//    UVRSSFeed *feed = [UVRSSFeed objectWithDictionary:rawFeed];
//    if (!feed) {
//        if (error) *error = [self feedError];
//        return NO;
//    }
//    // FEED:
//    /**
//     check if a feed exists
//     */
//    NSString *fileName = self.feedFileName;
//    if (![self.repository isFileExists:fileName] || !self.innerFeed.feedItems.count || ![feed isEqual:self.innerFeed]) {
//        // FEED:
//        /**
//         updating a serialized structure
//         */
//        self.innerFeed = feed;
//    } else {
//        NSArray *tmp = [feed.items filter:^BOOL(UVRSSFeedItem *item) {
//            return ![self.innerFeed.items containsObject:item];
//        }];
//        if (tmp.count > 0) [self.innerFeed.feedItems addObjectsFromArray:tmp];
//    }
//    return [self.repository updateData:@[self.innerFeed.dictionaryFromObject] file:fileName error:error];
//}

//- (void)deleteFeedItem:(UVRSSFeedItem *)item {
//    // FEED:
//    NSError *error = nil;
//    [self.innerFeed.feedItems removeObject:item];
//    NSDictionary *rawFeedToSave = self.innerFeed.dictionaryFromObject;
//    [self.repository updateData:@[rawFeedToSave] file:self.feedFileName error:&error];
//}

- (void)deleteFeed:(UVRSSFeed *)feed {
    [self.innerFeeds removeObject:feed];
    NSError *error = nil;
    [self.repository updateData:[self.innerFeeds map:^id _Nonnull(UVRSSFeed *feed) {
        return feed.dictionaryFromObject;
    }] file:self.feedFileName error:&error];
    self.innerFeed = nil;
}

// MARK: - Private

- (NSError *)feedError {
    return [NSError errorWithDomain:UVNullDataErrorDomain code:10000 userInfo:nil];
}

- (NSString *)feedFileName {
    return [self.session nameOfFile:UVFeedFile];
}

@end
