//
//  MediaContent.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "MediaContent.h"

NSString *const kRSSMediaContent = @"media:content";
NSString *const kRSSMediaContentURL = @"url";
NSString *const kRSSMediaContentFileSize = @"fileSize";
NSString *const kRSSMediaContentType = @"type";

@interface MediaContent ()

@property (nonatomic, copy, readwrite) NSString *url;
@property (nonatomic, assign, readwrite) NSInteger fileSize;
@property (nonatomic, copy, readwrite) NSString *type;

@end

@implementation MediaContent

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _url = [[dictionary valueForKey:@"url"] copy];
        _type = [[dictionary valueForKey:@"type"] copy];
        _fileSize = [[dictionary valueForKey:@"fileSize"] intValue];
    }
    return self;
}

- (void)dealloc
{
    [_url release];
    [_type release];
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@, %ld, %@", self.class, self.url, self.fileSize, self.type];
}

@end
