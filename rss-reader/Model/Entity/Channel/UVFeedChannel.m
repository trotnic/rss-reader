//
//  UVFeedChannel.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "UVFeedChannel.h"
#import "NSArray+Util.h"

@interface UVFeedChannel ()

@property (nonatomic, copy, readwrite) NSString *link;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *summary;
@property (nonatomic, retain, readwrite) NSArray<UVFeedItem *> *items;

@end

@implementation UVFeedChannel

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary || !dictionary.count) {
        NSLog(@"Unwanted behavior:\n%s\nargument:\n%@", __PRETTY_FUNCTION__, dictionary);
        return nil;
    }
    
    UVFeedChannel *object = [UVFeedChannel new];
        
    object.link = dictionary[kRSSChannelLink];
    object.title = dictionary[kRSSChannelTitle];
    object.summary = dictionary[kRSSChannelDescription];
    object.items = [dictionary[kRSSChannelItems]
                    map:^UVFeedItem *(NSDictionary *rawItem) {
        return [UVFeedItem objectWithDictionary:rawItem];        
    }];
    
    return object;
}

- (BOOL)isEqual:(id)other
{
    return [self.link isEqualToString:[other link]];
}

// MARK: - UVFeedChannelDisplayModel

- (NSString *)channelTitle {
    return [self.title copy];
}

- (NSArray<id<UVFeedItemDisplayModel>> *)channelItems {
    return self.items;
}

@end
