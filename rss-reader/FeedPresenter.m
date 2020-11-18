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
@property (nonatomic, retain) FeedXMLParser *parser;

@end

@implementation FeedPresenter

// MARK: -

- (instancetype)initWithParser:(FeedXMLParser *)parser
{
    self = [super init];
    if (self) {
        _data = [NSMutableArray new];
        _parser = [parser retain];
    }
    return self;
}

- (void)dealloc
{
    [_data release];
    [_parser release];
    [super dealloc];
}

- (void)assignView:(id<FeedViewType>)view {
    _view = view;
}

// MARK: FeedPresenterType -

- (void)updateFeed {
    [[NSURLSession.sharedSession dataTaskWithURL:[NSURL URLWithString:@"http://news.tut.by/rss/index.rss" ] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data) {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
                    [self.parser parseFeed:data completion:^(NSArray<FeedItem *> * result, NSError * parseError) {
                        // TODO: no no no no
                        [self.data removeAllObjects];
                        [self.data addObjectsFromArray:result];
                        [self.view setFeed:[NSArray arrayWithArray:self.data]];
                    }];
                });
            }
    }] resume];
}

@end
