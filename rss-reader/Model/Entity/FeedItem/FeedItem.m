//
//  FeedItem.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "FeedItem.h"
#import "NSDate+StringConvertible.h"

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

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary) {
        assert(NO);
        return nil;
    }
    
    FeedItem *object = [FeedItem new];
    
    
    object.title = dictionary[kRSSItemTitle];
    object.link = dictionary[kRSSItemLink];
    object.summary = dictionary[kRSSItemSummary];
    object.category = dictionary[kRSSItemCategory];
    object.pubDate = [NSDate dateFromString:dictionary[kRSSItemPubDate] withFormat:@"EE, d LLLL yyyy HH:mm:ss Z"];
    object.mediaContent = [NSArray arrayWithArray:[dictionary mutableArrayValueForKey:kRSSMediaContent]];
    
    return [object autorelease];
}

- (void)dealloc
{
    [_link release];
    [_title release];
    [_summary release];    
    [_pubDate release];
    [_category release];
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
    return [self.pubDate stringWithFormat:@"dd.MM.yyyy HH:mm"];
}

@end
