//
//  UVSite.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import "RSSSource.h"
#import "NSArray+Util.h"
#import "UVRSSSourceKeys.h"

@interface RSSSource ()

@property (nonatomic, retain, readwrite) NSURL *url;
@property (nonatomic, retain, readwrite) NSArray<RSSLink *> *rssLinks;

@end

@implementation RSSSource

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary || !dictionary.count) {
        NSLog(@"Unwanted behavior:\n%s\nargument:\n%@", __PRETTY_FUNCTION__, dictionary);
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:dictionary[kRSSSourceURL]];
    
    NSArray<RSSLink *> *links = [dictionary[kRSSSourceLinks] map:^RSSLink *(NSDictionary *rawLink) {
        RSSLink *link = [RSSLink objectWithDictionary:rawLink];
        [link configureURLRelativeToURL:url];
        return link;
    }];
    
    return [[[RSSSource alloc] initWithURL:url
                                     links:links
                                  selected:[dictionary[kRSSSourceSelected] boolValue]] autorelease];
}

- (instancetype)initWithURL:(NSURL *)url
                      links:(NSArray<RSSLink *> *)links
                   selected:(BOOL)selected
{
    self = [super init];
    if (self) {
        _url = [url retain];
        _rssLinks = [links retain];
        _selected = selected;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url
                      links:(NSArray<RSSLink *> *)links
{
    return [self initWithURL:url links:links selected:NO];
}

- (void)dealloc
{
    [_url release];
    [_rssLinks release];
    [super dealloc];
}

- (NSDictionary *)dictionaryFromObject {
    return @{
        kRSSSourceURL : self.url.absoluteString,
        kRSSSourceLinks : [self.rssLinks map:^id _Nonnull(RSSLink *link) { return link.dictionaryFromObject; }],
        kRSSSourceSelected : [NSNumber numberWithBool:self.isSelected]
    };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n%@\n%@", self.url, self.rssLinks];
}

- (BOOL)isEqual:(id)other
{
    return [[self url] isEqual:[other url]];
}

// MARK: -

- (BOOL)isSelected {
    for (RSSLink *link in self.rssLinks) {
        if (link.isSelected) {
            return YES;
        }
    }
    return NO;
}

- (NSArray<RSSLink *> *)selectedLinks {
    return [self.rssLinks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected == YES"]];
}

- (void)switchAllLinksSelected:(BOOL)selected {
    for (int i = 0; i < self.rssLinks.count; i++) {
        self.rssLinks[i].selected = selected;
    }
}

// MARK: - RSSSourceViewModel

- (NSString *)sourceAddress {
    return self.url.absoluteString;
}

- (NSArray<id<UVRSSLinkViewModel>> *)sourceRSSLinks {
    return self.rssLinks;
}

// MARK: - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.url = [coder decodeObjectOfClass:NSURL.class forKey:kRSSSourceURL];
        self.rssLinks = [coder decodeObjectOfClasses:[NSSet setWithArray:@[NSArray.class, RSSLink.class]]
                                              forKey:kRSSSourceLinks];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.url forKey:kRSSSourceURL];
    [coder encodeObject:self.rssLinks forKey:kRSSSourceLinks];
}

// MARK: - NSCopying

- (id)copyWithZone:(struct _NSZone *)zone {
    RSSSource *copy = [RSSSource new];
    copy.url = self.url;
    copy.rssLinks = [[[NSArray alloc] initWithArray:self.rssLinks
                                          copyItems:YES] autorelease];
    return copy;
}

@end
