//
//  UVSite.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import "RSSSource.h"
#import "NSArray+Util.h"

NSString *const kTitle = @"title";
NSString *const kUrl = @"url";
NSString *const kLinks = @"links";
NSString *const kSelected = @"selected";

@interface RSSSource ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, retain, readwrite) NSURL *url;
@property (nonatomic, retain, readwrite) NSArray<RSSLink *> *rssLinks;

@end

@implementation RSSSource

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary || !dictionary.count) {
        NSLog(@"Unwanted behavior:\n%s\nargument:\n%@", __PRETTY_FUNCTION__, dictionary);
        return nil;
    }
    
    NSArray *links = [dictionary[kLinks] map:^id (NSDictionary *link) { return [RSSLink objectWithDictionary:link]; }];
    return [[[RSSSource alloc] initWithTitle:dictionary[kTitle]
                                         url:[NSURL URLWithString:dictionary[kUrl]]
                                       links:links
                                    selected:[dictionary[kSelected] boolValue]] autorelease];
}

- (instancetype)initWithTitle:(NSString *)title
                          url:(NSURL *)url
                        links:(NSArray<RSSLink *> *)links
                     selected:(BOOL)selected
{
    self = [super init];
    if (self) {
        _title = [title copy];
        _url = [url retain];
        _rssLinks = [links retain];
        _selected = selected;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                          url:(NSURL *)url
                        links:(NSArray<RSSLink *> *)links
{
    return [self initWithTitle:title url:url links:links selected:NO];
}

- (void)dealloc
{
    [_title release];
    [_url release];
    [_rssLinks release];
    [super dealloc];
}

- (NSDictionary *)dictionaryFromObject {
    NSMutableArray *links = [NSMutableArray array];
    for (RSSLink *link in self.rssLinks) {
        [links addObject:link.dictionaryFromObject];
    }
    return @{
        kTitle : self.title,
        kUrl : self.url.absoluteString,
        kLinks : links,
        kSelected : [NSNumber numberWithBool:self.isSelected]
    };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n%@\n%@\n%@", self.title, self.url, self.rssLinks];
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
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

- (NSString *)sourceTitle {
    return self.title;
}

- (NSString *)sourceAddress {
    return self.url.absoluteString;
}

- (NSArray<id<RSSLinkViewModel>> *)sourceRSSLinks {
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
        self.title = [coder decodeObjectOfClass:NSString.class forKey:kTitle];
        self.url = [coder decodeObjectOfClass:NSURL.class forKey:kUrl];
        self.rssLinks = [coder decodeObjectOfClasses:[NSSet setWithArray:@[NSArray.class, RSSLink.class]]
                                              forKey:kLinks];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{    
    [coder encodeObject:self.title forKey:kTitle];
    [coder encodeObject:self.url forKey:kUrl];
    [coder encodeObject:self.rssLinks forKey:kLinks];
}

// MARK: - NSCopying

- (id)copyWithZone:(struct _NSZone *)zone {
    RSSSource *copy = [RSSSource new];
    copy.title = self.title;
    copy.url = self.url;
    copy.rssLinks = [[[NSArray alloc] initWithArray:self.rssLinks
                                          copyItems:YES] autorelease];
    return copy;
}

@end
