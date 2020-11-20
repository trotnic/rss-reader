//
//  FeedPresenter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedPresenter.h"
#import "FeedChannel.h"
#import "RouterType.h"

@interface FeedPresenter ()

@property (nonatomic, retain) FeedChannel *channel;
@property (nonatomic, assign) id<FeedViewType> view;
@property (nonatomic, retain) id<FeedParser> parser;
@property (nonatomic, retain) id<RouterType> router;

@end

@implementation FeedPresenter

// MARK: -

- (instancetype)initWithParser:(id<FeedParser>)parser router:(id<RouterType>)router
{
    self = [super init];
    if (self) {
        _parser = [parser retain];
        _router = [router retain];
    }
    return self;
}

- (void)dealloc
{
    [_channel release];
    [_parser release];
    [_router release];
    [super dealloc];
}

- (void)assignView:(id<FeedViewType>)view {
    _view = view;
}

// MARK: - FeedPresenterType

- (void)updateFeed {
    NSURLSessionDataTask *dataTask = [NSURLSession.sharedSession dataTaskWithURL:[NSURL URLWithString:@"https://news.tut.by/rss/index.rss"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [self.router showError:error];
            return;
        }
           
        [self.parser parseFeed:data completion:^(FeedChannel *channel, NSError * parseError) {
            if(parseError) {
                [self.router showError:parseError];
                return;
            }
            [channel retain];
            [_channel release];
            _channel = channel;
            [self.view setChannel:channel];
        }];
    }];
    
    [dataTask resume];
}

- (void)selectRowAt:(NSInteger)row {
    [self.router openURL:[NSURL URLWithString:self.channel.items[row].link]];
}

@end
