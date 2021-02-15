//
//  UVFeedManager.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 15.02.21.
//

#import "UVFeedManager.h"
#import "UVErrorDomain.h"

@interface UVFeedManager ()

@property (nonatomic, strong) UVFeedChannel *channel;
@property (nonatomic, weak) UVFeedItem *selected;

@end

@implementation UVFeedManager

- (UVFeedChannel *)channelFeed {
    return self.channel;
}

- (UVFeedItem *)selectedItem {
    return self.selected;
}

- (void)selectItem:(UVFeedItem *)item {
    self.selected = item;
}

- (void)provideRawFeed:(NSDictionary *)feed error:(NSError **)error {
    if (!feed || ![feed isKindOfClass:NSDictionary.class]) {
        *error = [self feedError];
        return;
    }
    UVFeedChannel *tmp = [UVFeedChannel objectWithDictionary:feed];
    if (!tmp) {
        *error = [self feedError];
        return;
    }
    self.channel = tmp;
}

// MARK: - Private

- (NSError *)feedError {
    return [NSError errorWithDomain:UVNullDataErrorDomain code:10000 userInfo:nil];
}

@end
