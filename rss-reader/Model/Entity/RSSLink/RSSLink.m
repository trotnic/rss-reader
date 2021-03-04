//
//  RSSLink.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import "RSSLink.h"
#import "UVRSSLinkKeys.h"

@interface RSSLink ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, retain, readwrite) NSURL *url;

@end

@implementation RSSLink

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary || !dictionary.count || ![dictionary isKindOfClass:NSDictionary.class]) {
        NSLog(@"Unwanted behavior:\n%s\nargument:\n%@", __PRETTY_FUNCTION__, dictionary);
        return nil;
    }
    
    return [[[RSSLink alloc] initWithTitle:dictionary[kRSSLinkTitle]
                                       url:[NSURL URLWithString:dictionary[kRSSLinkURL]]
                                  selected:[dictionary[kRSSLinkSelected] boolValue]] autorelease];
}

- (instancetype)initWithTitle:(NSString *)title
                          url:(NSURL *)url {
    return [self initWithTitle:title url:url selected:NO];
}

- (instancetype)initWithTitle:(NSString *)title
                          url:(NSURL *)url
                     selected:(BOOL)selected
{
    self = [super init];
    if (self) {
        _title = [title copy];
        _url = [url retain];
        _selected = selected;
    }
    return self;
}

- (void)dealloc
{
    [_title release];
    [_url release];
    [super dealloc];
}

- (NSDictionary *)dictionaryFromObject {
    return @{
        kRSSLinkTitle : self.title,
        kRSSLinkURL : self.url.absoluteString,
        kRSSLinkSelected : [NSNumber numberWithBool:self.isSelected]
    };
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@, %@", self.url, self.title, self.isSelected ? @"YES" : @"NO"];
}

- (BOOL)isEqual:(id)other
{
    return [self.url isEqual:[other url]];
}

// MARK: -

- (void)configureURLRelativeToURL:(NSURL *)url {
    self.url = [NSURL URLWithString:self.url.absoluteString
                      relativeToURL:url].absoluteURL;
}

// MARK: - RSSLinkViewModel

- (NSString *)linkTitle {
    return self.title.length != 0 ? self.title : self.url.absoluteString;
}

// MARK: - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.title = [coder decodeObjectOfClass:NSString.class forKey:kRSSLinkTitle];
        self.url = [coder decodeObjectOfClass:NSURL.class forKey:kRSSLinkURL];
        self.selected = [coder decodeBoolForKey:kRSSLinkSelected];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.title forKey:kRSSLinkTitle];
    [coder encodeObject:self.url forKey:kRSSLinkURL];
    [coder encodeBool:self.isSelected forKey:kRSSLinkSelected];
}

// MARK: - NSCopying

- (id)copyWithZone:(struct _NSZone *)zone {
    RSSLink *copy = [RSSLink new];
    copy.url = self.url;
    copy.selected = self.isSelected;
    copy.title = self.title;
    return copy;
}

@end
