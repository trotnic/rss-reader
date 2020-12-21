//
//  UVSite.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import "RSSSource.h"

@interface RSSSource ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, retain, readwrite) NSURL *url;
@property (nonatomic, retain, readwrite) NSArray<RSSLink *> *rssLinks;

@end

@implementation RSSSource

- (instancetype)initWithTitle:(NSString *)title
                          url:(NSURL *)url
                        links:(NSArray<RSSLink *> *)links
{
    self = [super init];
    if (self) {
        _title = [title copy];
        _url = [url retain];
        _rssLinks = [links retain];
    }
    return self;
}

- (void)dealloc
{
    [_title release];
    [_url release];
    [_rssLinks release];
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n%@\n%@\n%@", self.title, self.url, self.rssLinks];
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
        self.title = [coder decodeObjectOfClass:NSString.class forKey:@"title"];
        self.url = [coder decodeObjectOfClass:NSURL.class forKey:@"url"];
        self.rssLinks = [coder decodeObjectOfClasses:[NSSet setWithArray:@[NSArray.class, RSSLink.class]] forKey:@"rssLinks"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{    
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.url forKey:@"url"];
    [coder encodeObject:self.rssLinks forKey:@"rssLinks"];
}

// MARK: - NSCopying

- (id)copyWithZone:(struct _NSZone *)zone {
    RSSSource *copy = [RSSSource new];
    copy.title = self.title;
    copy.url = self.url;
    copy.rssLinks = [[NSArray alloc] initWithArray:self.rssLinks copyItems:YES];
    return copy;
}

@end
