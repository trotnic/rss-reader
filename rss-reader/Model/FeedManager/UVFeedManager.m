//
//  UVFeedManager.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 15.02.21.
//

#import "UVFeedManager.h"
#import "UVErrorDomain.h"

@interface UVFeedManager ()

@property (nonatomic, strong) UVRSSFeed *innerFeed;
@property (nonatomic, weak) UVRSSFeedItem *selected;
@property (nonatomic, strong) id<UVPListRepositoryType> repository;

@end

@implementation UVFeedManager

- (instancetype)initWithRepository:(id<UVPListRepositoryType>)repository {
    self = [super init];
    if (self) {
        _repository = repository;
    }
    return self;
}

// MARK: -

- (UVRSSFeed *)feed {
    if (!self.innerFeed) {
        NSError *error = nil;
        NSDictionary *raw = [[self.repository fetchData:&error] firstObject];
        if (error) return nil;
        self.innerFeed = [UVRSSFeed objectWithDictionary:raw];
    }
    return self.innerFeed;
}

- (UVRSSFeedItem *)selectedFeedItem {
    return self.selected;
}

- (void)selectFeedItem:(UVRSSFeedItem *)item {
    self.selected = item;
}

- (BOOL)storeFeed:(NSDictionary *)feed error:(NSError **)error {
    if (!feed || ![feed isKindOfClass:NSDictionary.class]) {
        if (error) *error = [self feedError];
        return NO;
    }
    if (![self.repository updateData:@[feed] error:error]) {
        return NO;
    }
    UVRSSFeed *tmp = [UVRSSFeed objectWithDictionary:feed];
    if (!tmp) {
        if (error) *error = [self feedError];
        return NO;
    }
    self.innerFeed = tmp;
    return YES;
}

- (void)deleteFeed {
    NSError *error = nil;
    [self.repository updateData:@[] error:&error];
    self.innerFeed = nil;
}

// MARK: - Private

- (NSError *)feedError {
    return [NSError errorWithDomain:UVNullDataErrorDomain code:10000 userInfo:nil];
}

@end
