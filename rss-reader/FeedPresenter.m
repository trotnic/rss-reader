//
//  FeedPresenter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedPresenter.h"

@interface FeedPresenter ()

@property (nonatomic, retain) NSMutableArray<FeedItem *> *data;
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
        _data = [NSMutableArray new];
        _parser = [parser retain];
        _router = [router retain];
    }
    return self;
}

- (void)dealloc
{
    [_data release];
    [_parser release];
    [_router release];
    [super dealloc];
}

- (void)assignView:(id<FeedViewType>)view {
    _view = view;
}

// MARK: - FeedPresenterType

- (void)updateFeed {
    __block typeof(self)weakSelf = self;
    NSURLSessionDataTask *dataTask = [NSURLSession.sharedSession dataTaskWithURL:[NSURL URLWithString:@"https://news.tut.by/rss/index.rss"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            return;
        }
            
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
            [weakSelf.parser parseFeed:data completion:^(NSArray<FeedItem *> * result, NSError * parseError) {
                [self.data removeAllObjects];
                [self.data addObjectsFromArray:result];
                [self.view setFeed:[NSArray arrayWithArray:self.data]];
            }];
        });
            
    }];
    
    [dataTask resume];
}

- (void)selectRowAt:(NSInteger)row {
    [self.router openURL:[NSURL URLWithString:self.data[row].link]];
}

@end
