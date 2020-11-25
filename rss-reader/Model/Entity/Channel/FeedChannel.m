//
//  FeedChannel.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedChannel.h"

NSString *const kRSSChannel = @"channel";
NSString *const kRSSChannelLink = @"link";
NSString *const kRSSChannelTitle = @"title";
NSString *const kRSSChannelDescription = @"description";
NSString *const kRSSChannelItems = @"RSSChannelItems";

@interface FeedChannel ()

@property (nonatomic, copy, readwrite) NSString *link;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *summary;
@property (nonatomic, retain, readwrite) NSArray<FeedItem *> *items;

@end

@implementation FeedChannel

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary || dictionary.count == 0) {
        NSLog(@"Unwanted behavior:\n%s\nargument:\n%@", __PRETTY_FUNCTION__, dictionary);
        return nil;
    }
    
    FeedChannel *object = [FeedChannel new];
        
    object.link = dictionary[kRSSChannelLink];
    object.title = dictionary[kRSSChannelTitle];
    object.summary = dictionary[kRSSChannelDescription];
    object.items = [NSArray arrayWithArray:[dictionary mutableArrayValueForKey:kRSSChannelItems]];
    
    return [object autorelease];
}

- (void)dealloc
{
    [_link release];
    [_title release];
    [_items release];
    [_summary release];
    [super dealloc];
}

// MARK: - FeedChannelViewModel

- (NSString *)channelTitle {
    return self.title;
}

- (NSArray<id<FeedItemViewModel>> *)channelItems {
    return self.items;
}

@end
