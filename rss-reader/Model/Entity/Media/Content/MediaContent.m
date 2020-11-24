//
//  MediaContent.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "MediaContent.h"

NSString *const kRSSMediaContent = @"media:content";
NSString *const kRSSMediaContentURL = @"url";
NSString *const kRSSMediaContentType = @"type";
NSString *const kRSSMediaContentFileSize = @"fileSize";

@interface MediaContent ()

@property (nonatomic, copy, readwrite) NSString *url;
@property (nonatomic, copy, readwrite) NSString *type;
@property (nonatomic, assign, readwrite) NSInteger fileSize;

@end

@implementation MediaContent

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary) {
        assert(NO);
        return nil;
    }
    
    MediaContent *object = [MediaContent new];
    
    object.url = dictionary[kRSSMediaContentURL];
    object.type = dictionary[kRSSMediaContentType];
    object.fileSize = [dictionary[kRSSMediaContentFileSize] intValue];
    
    return [object autorelease];
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
