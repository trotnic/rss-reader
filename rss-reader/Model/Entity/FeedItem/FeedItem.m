//
//  FeedItem.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "FeedItem.h"

NSString *const kRSSItem = @"item";
NSString *const kRSSItemTitle = @"title";
NSString *const kRSSItemLink = @"link";
NSString *const kRSSItemSummary = @"description";
NSString *const kRSSItemCategory = @"category";
NSString *const kRSSItemPubDate = @"pubDate";

@interface FeedItem ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *link;
@property (nonatomic, copy, readwrite) NSString *summary;
@property (nonatomic, copy, readwrite) NSString *category;
@property (nonatomic, retain, readwrite) NSDate *pubDate;
@property (nonatomic, retain, readwrite) NSArray<MediaContent *> *mediaContent;

@end

@implementation FeedItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        NSDateFormatter *dateFormat = [NSDateFormatter new];
        [dateFormat setDateFormat:@"EE, d LLLL yyyy HH:mm:ss Z"];
        
        _title = [dictionary[kRSSItemTitle] copy];
        _link = [dictionary[kRSSItemLink] copy];
        _summary = [dictionary[kRSSItemSummary] copy];
        _category = [dictionary[kRSSItemCategory] copy];
        _pubDate = [[dateFormat dateFromString:[dictionary valueForKey:kRSSItemPubDate]] retain];
        _mediaContent = [[NSArray arrayWithArray:[dictionary mutableArrayValueForKey:kRSSMediaContent]] retain];
        
        [dateFormat release];
    }
    return self;
}

- (void)dealloc
{
    [_title release];
    [_link release];
    [_summary release];
    [_category release];
    [_pubDate release];
    [_mediaContent release];
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.class];
}

// MARK: - FeedItemViewModel

- (NSString *)articleTitle {
    return self.title;
}

- (NSString *)articleCategory {
    return self.category;
}

- (NSString *)articleDate {
    NSDateFormatter *dateFormat = [[NSDateFormatter new] autorelease];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    return [dateFormat stringFromDate:self.pubDate];
}

@end
