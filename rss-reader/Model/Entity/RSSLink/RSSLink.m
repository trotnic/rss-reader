//
//  RSSLink.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import "RSSLink.h"

NSString *const kRSSLinkTitle = @"title";
NSString *const kRSSLinkLink = @"link";
NSString *const kRSSLinkSelected = @"selected";

@interface RSSLink ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *link;

@end

@implementation RSSLink

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary || !dictionary.count) {
        NSLog(@"Unwanted behavior:\n%s\nargument:\n%@", __PRETTY_FUNCTION__, dictionary);
        return nil;
    }
    
    return [[[RSSLink alloc] initWithTitle:dictionary[kRSSLinkTitle]
                                      link:dictionary[kRSSLinkLink]
                                  selected:[dictionary[kRSSLinkSelected] boolValue]] autorelease];
}

- (instancetype)initWithTitle:(NSString *)title link:(NSString *)link selected:(BOOL)selected
{
    self = [super init];
    if (self) {
        _title = [title copy];
        _link = [link copy];
        _selected = selected;
    }
    return self;
}

- (void)dealloc
{
    [_title release];
    [_link release];
    [super dealloc];
}

- (NSDictionary *)dictionaryFromObject {
    return @{
        kRSSLinkTitle : self.title,
        kRSSLinkLink : self.link,
        kRSSLinkSelected : [NSNumber numberWithBool:self.isSelected]
    };
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@, %@", self.link, self.title, self.isSelected ? @"YES" : @"NO"];
}

// MARK: - RSSLinkViewModel

- (NSString *)linkTitle {
    return self.title.length != 0 ? self.title : self.link;
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
        self.link = [coder decodeObjectOfClass:NSString.class forKey:kRSSLinkLink];
        self.selected = [coder decodeBoolForKey:kRSSLinkSelected];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.title forKey:kRSSLinkTitle];
    [coder encodeObject:self.link forKey:kRSSLinkLink];
    [coder encodeBool:self.isSelected forKey:kRSSLinkSelected];
}

// MARK: - NSCopying

- (id)copyWithZone:(struct _NSZone *)zone {
    RSSLink *copy = [RSSLink new];
    copy.link = self.link;
    copy.selected = self.isSelected;
    copy.title = self.title;
    return copy;
}

@end
