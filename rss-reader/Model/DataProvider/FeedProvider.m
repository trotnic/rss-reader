//
//  FeedProvider.m
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import "FeedProvider.h"

@interface FeedProvider ()

@property (nonatomic, retain) NSURLSession *session;
@property (nonatomic, retain) id<FeedParserType> parser;

@end

@implementation FeedProvider

// MARK: -

- (instancetype)initWithSession:(NSURLSession *)session
                         parser:(id<FeedParserType>)parser
{
    self = [super init];
    if (self) {        
        _parser = [parser retain];
        _session = [session retain];
    }
    return self;
}

- (void)dealloc
{
    [_parser release];
    [_session release];
    [super dealloc];
}

// MARK: - FeedProviderType

- (void)fetchData:(void(^)(FeedChannel *, NSError *))completion {
    __weak typeof(self)weakSelf = self;
    [self performNetworkRequestWith:^(NSData *data, NSError *error) {
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

// MARK: -

- (void)performNetworkRequestWith:(void(^)(NSData *, NSError *))completion {
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:@"https://news.tut.by/rss/index.rss"]
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        completion(data, nil);
    }];
    
    [dataTask resume];
}

@end
