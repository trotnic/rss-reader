//
//  FeedItem.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "FeedItem.h"

@interface FeedItem ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *link;
@property (nonatomic, copy, readwrite) NSString *imageLink;
@property (nonatomic, retain, readwrite) NSArray *mediaLinks;

@end

@implementation FeedItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _title = [[dictionary valueForKey:@"title"] copy];
        _link = [[dictionary valueForKey:@"link"] copy];
        _imageLink = [[dictionary valueForKey:@"decription"] copy];
        _mediaLinks = [[NSArray arrayWithArray:[dictionary mutableArrayValueForKey:@"mediaLinks"]] retain];
    }
    return self;
}

- (void)dealloc
{
    [_title release];
    [_link release];
    [_imageLink release];
    [_mediaLinks release];
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.class];
}

// MARK: FeedItemViewModel -

- (NSString *)articleTitle {
    return self.title;
}

@end
