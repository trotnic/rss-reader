//
//  FeedProvider.m
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import "FeedProvider.h"

@interface FeedProvider ()

@property (nonatomic, retain) id<NetworkServiceType> service;
@property (nonatomic, retain) id<FeedParserType> parser;

@end

@implementation FeedProvider

// MARK: -

- (instancetype)initWithNetwork:(id<NetworkServiceType>)service
                         parser:(id<FeedParserType>)parser
{
    self = [super init];
    if (self) {        
        _parser = [parser retain];
        _service = [service retain];
    }
    return self;
}

- (void)dealloc
{
    [_parser release];
    [_service release];
    [super dealloc];
}

// MARK: - FeedProviderType

- (void)fetchData:(void(^)(FeedChannel *, NSError *))completion {
    __block typeof(self)weakSelf = self;
    [self.service fetchWithURL:[NSURL URLWithString:@"https://news.tut.by/rss/index.rss"]
                    completion:^(NSData *data, NSError *error) {
        if(error) {
            completion(nil, error);
            return;
        }
        [weakSelf.parser parseFeed:data completion:^(FeedChannel *channel, NSError *parseError) {
            if(parseError) {
                completion(nil, parseError);
                return;
            }
            completion(channel, nil);
        }];
    }];
}

@end
