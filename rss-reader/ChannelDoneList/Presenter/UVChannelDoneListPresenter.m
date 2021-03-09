//
//  UVChannelDoneListPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 3.03.21.
//

#import "UVChannelDoneListPresenter.h"

@interface UVChannelDoneListPresenter ()

@property (nonatomic, strong) id<UVDataRecognizerType> recognizer;
@property (nonatomic, strong) id<UVSourceManagerType> source;
@property (nonatomic, strong) id<UVNetworkType> network;
@property (nonatomic, strong) id<UVFeedManagerType> feed;
@property (nonatomic, strong) id<UVCoordinatorType> coordinator;
@property (nonatomic, strong, readonly) NSArray<UVRSSFeedItem *> *feedItems;

@end

@implementation UVChannelDoneListPresenter

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                            source:(id<UVSourceManagerType>)source
                           network:(id<UVNetworkType>)network
                              feed:(id<UVFeedManagerType>)feed
                       coordinator:(id<UVCoordinatorType>)coordinator {
    self = [super init];
    if (self) {
        _recognizer = recognizer;
        _source = source;
        _network = network;
        _feed = feed;
        _coordinator = coordinator;
    }
    return self;
}

// MARK: - Lazy Properties

- (NSArray<UVRSSFeedItem *> *)feedItems {
    return [self.feed feedItemsWithState:UVRSSItemDone];
}

// MARK: - UVChannelDoneListPresenterType

- (NSInteger)numberOfRows {
    return self.feedItems.count;
}

- (id<UVFeedItemDisplayModel>)itemAt:(NSInteger)index {
    return self.feedItems[index];
}

- (void)didSelectItemAt:(NSInteger)index {
    [self.feed selectFeedItem:self.feedItems[index]];
    [self.coordinator showScreen:PresentationBlockWeb];
}

@end
