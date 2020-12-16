//
//  FeedProvider.m
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import "FeedProvider.h"
#import "FeedParserType.h"
#import "UVSourceManager.h"

NSString *const kFeedURL = @"https://news.tut.by/rss/index.rss";

@interface FeedProvider ()

@property (nonatomic, retain) id<UVSourceManagerType> sourceManager;
@property (nonatomic, retain) id<FeedParserType> parser;

@end

@implementation FeedProvider

// MARK: -

- (instancetype)initWithParser:(id<FeedParserType>)parser
{
    self = [super init];
    if (self) {        
        _parser = [parser retain];
    }
    return self;
}

- (void)dealloc
{
    [_parser release];
    [_sourceManager release];
    [super dealloc];
}

// MARK: - FeedProviderType

- (void)fetchDataFromURL:(NSURL *)url completion:(void(^)(FeedChannel *, RSSError))completion {
    [NSThread detachNewThreadWithBlock:^{
        @autoreleasepool {
            [self.parser parseContentsOfURL:url
                             withCompletion:^(FeedChannel *channel, NSError *error) {
                if(error) {
                    completion(nil, RSSErrorTypeBadNetwork);
                    return;
                }
                completion(channel, RSSErrorTypeNone);
            }];
        }
    }];
}

//- (void)fetchData:(void(^)(FeedChannel *, RSSError))completion {
//    [NSThread detachNewThreadWithBlock:^{
//        @autoreleasepool {
//            [self.parser parseContentsOfURL:[NSURL URLWithString:[self.sourceManager.selectedLink link]]
//                             withCompletion:^(FeedChannel *channel, NSError *error) {
//                if(error) {
//                    completion(nil, RSSErrorTypeBadNetwork);
//                    return;
//                }
//                completion(channel, RSSErrorTypeNone);
//            }];
//        }
//    }];
//}

// MARK: - Lazy

- (id<UVSourceManagerType>)sourceManager {
    if(!_sourceManager) {
        _sourceManager = [UVSourceManager.defaultManager retain];
    }
    return _sourceManager;
}

@end
