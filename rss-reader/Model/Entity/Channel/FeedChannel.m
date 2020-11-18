//
//  FeedChannel.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedChannel.h"

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
        _title = [[dictionary valueForKey:@"title"] copy];
        _link = [[dictionary valueForKey:@"link"] copy];
        _summary = [[dictionary valueForKey:@"description"] copy];
        _items = [NSArray new];
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
