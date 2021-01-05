//
//  UVFeedItem.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "UVFeedItem.h"
#import "NSDate+StringConvertible.h"
#import "NSString+StringExtractor.h"

static NSString *const kDatePresentationFormat = @"dd.MM.yyyy HH:mm";
static NSString *const kDateRawFormat = @"EE, d LLLL yyyy HH:mm:ss Z";

@interface UVFeedItem ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSURL *url;
@property (nonatomic, copy, readwrite) NSString *summary;
@property (nonatomic, copy, readwrite) NSString *category;
@property (nonatomic, retain, readwrite) NSDate *pubDate;

@end

@implementation UVFeedItem

@synthesize expand;
@synthesize frame;

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary || !dictionary.count) {
        NSLog(@"Unwanted behavior:\n%s\nargument:\n%@", __PRETTY_FUNCTION__, dictionary);
        return nil;
    }
    
    UVFeedItem *object = [UVFeedItem new];
    
    object.title = dictionary[kRSSItemTitle];
    object.url = [NSURL URLWithString:dictionary[kRSSItemLink]];
    object.summary = dictionary[kRSSItemSummary];
    object.category = dictionary[kRSSItemCategory];
    object.pubDate = [NSDate dateFromString:dictionary[kRSSItemPubDate] withFormat:kDateRawFormat];
    
    return [object autorelease];
}

- (void)dealloc
{
    [_url release];
    [_title release];
    [_summary release];    
    [_pubDate release];
    [_category release];
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.url];
}

- (BOOL)isEqual:(id)other
{
    return [self.url isEqual:[other url]];
}

// MARK: - UVFeedItemViewModel

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
    return self.summary;
}

@end
