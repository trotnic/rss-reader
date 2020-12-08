//
//  RSSLink.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import "RSSSource.h"

@interface RSSSource ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;

@end

@implementation RSSSource

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary || !dictionary.count) {
        NSLog(@"Unwanted behavior:\n%s\nargument:\n%@", __PRETTY_FUNCTION__, dictionary);
        return nil;
    }
    
    return [[[RSSSource alloc] initWithTitle:dictionary[@"title"]
                                        link:dictionary[@"link"]] autorelease];
}

- (instancetype)initWithTitle:(NSString *)title link:(NSString *)link
{
    self = [super init];
    if (self) {
        _title = [title copy];
        _link = [link copy];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@", self.link, self.title];
}

@end
