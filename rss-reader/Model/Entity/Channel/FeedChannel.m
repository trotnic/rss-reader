//
//  FeedChannel.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedChannel.h"

NSString *const kRSSChannelTitle = @"title";
NSString *const kRSSChannelLink = @"link";
NSString *const kRSSChannelDescription = @"description";
NSString *const kRSSChannelItems = @"RSSChannelItems";

@interface FeedChannel ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *link;
@property (nonatomic, copy, readwrite) NSString *summary;
@property (nonatomic, retain, readwrite) NSArray<FeedItem *> *items;

@end

@implementation FeedChannel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _title = [[dictionary valueForKey:kRSSChannelTitle] copy];
        _link = [[dictionary valueForKey:kRSSChannelLink] copy];
        _summary = [[dictionary valueForKey:kRSSChannelDescription] copy];
        _items = [[NSArray arrayWithArray:[dictionary mutableArrayValueForKey:kRSSChannelItems]] retain];
    }
    return self;
}

- (void)dealloc
{
    [_title release];
    [_link release];
    [_summary release];
    [_items release];
    [super dealloc];
}

@end
