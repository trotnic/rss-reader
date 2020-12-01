//
//  FeedItem.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "FeedItem.h"
#import "NSDate+StringConvertible.h"
#import "NSString+StringExtractor.h"

NSString *const kRSSItem = @"item";
NSString *const kRSSItemTitle = @"title";
NSString *const kRSSItemLink = @"link";
NSString *const kRSSItemSummary = @"description";
NSString *const kRSSItemCategory = @"category";
NSString *const kRSSItemPubDate = @"pubDate";

NSString *const kDatePresentationFormat = @"dd.MM.yyyy HH:mm";
NSString *const kDateRawFormat = @"EE, d LLLL yyyy HH:mm:ss Z";

@interface FeedItem ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *link;
@property (nonatomic, copy, readwrite) NSString *summary;
@property (nonatomic, copy, readwrite) NSString *category;
@property (nonatomic, retain, readwrite) NSDate *pubDate;
@property (nonatomic, retain, readwrite) NSArray<MediaContent *> *mediaContent;

@end

@implementation FeedItem

@synthesize expand;

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary || !dictionary.count) {
        NSLog(@"Unwanted behavior:\n%s\nargument:\n%@", __PRETTY_FUNCTION__, dictionary);
        return nil;
    }
    
    FeedItem *object = [FeedItem new];
    
    object.title = dictionary[kRSSItemTitle];
    object.link = dictionary[kRSSItemLink];
    object.summary = dictionary[kRSSItemSummary];
    object.category = dictionary[kRSSItemCategory];
    object.pubDate = [NSDate dateFromString:dictionary[kRSSItemPubDate] withFormat:kDateRawFormat];
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
    return NSStringFromClass(self.class);
}

// MARK: - FeedItemViewModel

- (NSString *)articleTitle {
    return [[self.title copy] autorelease];
}

- (NSString *)articleCategory {
    return [[self.category copy] autorelease];
}

- (NSString *)articleDate {
    return [self.pubDate stringWithFormat:kDatePresentationFormat];
}

- (NSString *)articleDescription {
    return [self.summary stringBetweenStart:@" />" andFinish:@"<br"];
}

@end
