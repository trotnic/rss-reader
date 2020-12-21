//
//  RSSLink.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import "RSSLink.h"

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
    
    return [[[RSSLink alloc] initWithTitle:dictionary[@"title"]
                                        link:dictionary[@"link"]] autorelease];
}

- (instancetype)initWithTitle:(NSString *)title link:(NSString *)link
{
    self = [super init];
    if (self) {
        _title = [title copy];
        _link = [link copy];
        _selected = NO;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@, %@", self.link, self.title, self.isSelected ? @"YES" : @"NO"];
}

// MARK: - RSSLinkViewModel

- (NSString *)linkTitle {
    return self.title;
}

// MARK: - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.link = [coder decodeObjectOfClass:NSString.class forKey:@"link"];
        self.title = [coder decodeObjectOfClass:NSString.class forKey:@"title"];
        self.selected = [coder decodeBoolForKey:@"isSelected"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.link forKey:@"link"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeBool:self.isSelected forKey:@"isSelected"];
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
