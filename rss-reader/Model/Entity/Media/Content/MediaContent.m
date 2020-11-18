//
//  MediaContent.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "MediaContent.h"

@interface MediaContent ()

@property (nonatomic, copy, readwrite) NSString *url;
@property (nonatomic, copy, readwrite) NSString *type;
@property (nonatomic, assign, readwrite) NSUInteger fileSize;

@end

@implementation MediaContent

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _url = [[dictionary valueForKey:@"url"] copy];
        _type = [[dictionary valueForKey:@"type"] copy];
        _fileSize = [[dictionary valueForKey:@"fileSize"] unsignedIntValue];
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
    return [NSString stringWithFormat:@"%lu", self.fileSize];
}

@end
