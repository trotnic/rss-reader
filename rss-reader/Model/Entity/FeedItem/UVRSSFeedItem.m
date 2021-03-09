//
//  UVRSSFeedItem.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "UVRSSFeedItem.h"
#import "NSDate+StringConvertible.h"
#import "NSString+Util.h"

static NSString *const kDatePresentationFormat  = @"dd.MM.yyyy HH:mm";
static NSString *const kDateRawFormat           = @"EE, d LLLL yyyy HH:mm:ss Z";

@interface UVRSSFeedItem ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSURL *url;
@property (nonatomic, copy, readwrite) NSString *summary;
@property (nonatomic, copy, readwrite) NSString *category;
@property (nonatomic, strong, readwrite) NSDate *pubDate;

@end

@implementation UVRSSFeedItem

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary || !dictionary.count) {
        NSLog(@"Unwanted behavior:\n%s\nargument:\n%@", __PRETTY_FUNCTION__, dictionary);
        return nil;
    }
    
    UVRSSFeedItem *object = [[UVRSSFeedItem alloc] init];
    // FEED: 
    object.title = dictionary[kRSSItemTitle];
    object.url = [NSURL URLWithString:dictionary[kRSSItemLink]];
    object.summary = dictionary[kRSSItemSummary];
    object.category = dictionary[kRSSItemCategory];
    object.pubDate = [NSDate dateFromString:dictionary[kRSSItemPubDate] withFormat:kDateRawFormat];
    object.expand = [dictionary[kRSSItemExpand] boolValue];
    UVRSSItemState state = [dictionary[kRSSItemState] intValue];
    object.readingState = !state ? UVRSSItemNotStarted : state;
    return object;
}

- (NSDictionary *)dictionaryFromObject {
    // FEED: ❗️
    NSDictionary *dict = @{
        kRSSItemTitle : [self.title copy],
        kRSSItemLink : [self.url.absoluteString copy],
        kRSSItemSummary : [self.summary copy],
        kRSSItemCategory : self.category == nil ? @"" : [self.category copy],
        kRSSItemPubDate : [self.pubDate stringWithFormat:kDateRawFormat],
        kRSSItemExpand : [NSNumber numberWithBool:self.isExpand == 0 ? 0 : 1],
        kRSSItemState : [NSNumber numberWithInt:self.readingState]
    };
    return dict;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ --- %u, %p", self.url, self.readingState, self];
}

- (BOOL)isEqual:(UVRSSFeedItem *)other
{
    return [self.url isEqual:other.url];
}

// MARK: - UVFeedItemDisplayModel

- (NSString *)articleDate {
    return [self.pubDate stringWithFormat:kDatePresentationFormat];
}

- (BOOL)isReading {
    return self.readingState == UVRSSItemReading;
}

@end
