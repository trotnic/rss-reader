//
//  UVChannelFeedPresenter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "UVChannelFeedPresenter.h"
#import "UVChannelFeedViewType.h"

#import "NSArray+Util.h"

#import "UVFeedXMLParser.h"
#import "UVRSSFeed.h"


// TODO: -

typedef NS_ENUM(NSUInteger, SortType) {
    SortDate,
    SortTitle
};

@interface UVChannelFeedPresenter ()

@property (nonatomic, strong) id<UVDataRecognizerType>  dataRecognizer;
@property (nonatomic, strong) id<UVSourceManagerType>   sourceManager;
@property (nonatomic, strong) id<UVNetworkType>         network;
@property (nonatomic, strong) id<UVCoordinatorType>     coordinator;
@property (nonatomic, strong) id<UVFeedManagerType>     feedManager;
@property (nonatomic, strong, readonly) NSMutableArray<UVRSSFeedItem *> *feedItems;

@property (nonatomic, strong) NSSortDescriptor *sortDescriptor;

@property (nonatomic, strong) NSMutableArray<UVRSSLink *> *selectedLinks;

@property (nonatomic, strong) NSOperationQueue *feedItemQueue;
@property (nonatomic, strong) NSUUID *uuid;

@end

@implementation UVChannelFeedPresenter

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                            source:(id<UVSourceManagerType>)source
                           network:(id<UVNetworkType>)network
                              feed:(id<UVFeedManagerType>)feed
                       coordinator:(id<UVCoordinatorType>)coordinator {
    self = [super init];
    if (self) {
        _dataRecognizer = recognizer;
        self.sourceManager = source;
        self.network = network;
        _coordinator = coordinator;
        _feedManager = feed;
    }
    return self;
}

- (void)dealloc
{
    [_network unregisterObserver:NSStringFromClass([self class])];
    [_sourceManager unregisterObserver:NSStringFromClass([self class])];
}

// MARK: - Lazy Properties

- (NSUUID *)uuid {
    if (!_uuid) {
        _uuid = NSUUID.UUID;
    }
    return _uuid;
}

- (NSOperationQueue *)feedItemQueue {
    if (!_feedItemQueue) {
        _feedItemQueue = [NSOperationQueue new];
        _feedItemQueue.qualityOfService = NSQualityOfServiceUserInitiated;
    }
    return _feedItemQueue;
}

- (NSMutableArray<UVRSSLink *> *)selectedLinks {
    if (!_selectedLinks) {
        _selectedLinks = [NSMutableArray new];
    }
    return _selectedLinks;
}

- (NSSortDescriptor *)sortDescriptor {
    if (!_sortDescriptor) {
        _sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"pubDate" ascending:NO];
    }
    return _sortDescriptor;
}

// MARK: -

- (void)setNetwork:(id<UVNetworkType>)network {
    if (network != _network) {
        [_network unregisterObserver:self.uuid.UUIDString];
        _network = network;
        __weak typeof(self)weakSelf = self;
        [_network registerObserver:self.uuid.UUIDString callback:^(BOOL isConnectionStable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isConnectionStable) {
                    [weakSelf updateFeed];
                } else {
                    [weakSelf.view setSettingsButtonActive:NO];
                    [weakSelf showError:RSSErrorTypeNoNetworkConnection];
                }
            });
        }];
    }
}

- (void)setSourceManager:(id<UVSourceManagerType>)sourceManager {
    if (sourceManager != _sourceManager) {
        [_sourceManager unregisterObserver:self.uuid.UUIDString];
        _sourceManager = sourceManager;
        __weak typeof(self)weakSelf = self;
        [_sourceManager registerObserver:self.uuid.UUIDString callback:^(BOOL shouldUpdate) {
            if (shouldUpdate)
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf updateFeed];
                });
        }];
    }
}

// MARK: - UVChannelFeedPresenterType

- (void)updateFeed {
    if (!self.network.isConnectionAvailable) {
        [self.view setSettingsButtonActive:NO];
        [self.view updatePresentation];
        [self showError:RSSErrorTypeNoNetworkConnection];
        return;
    }
    [self.view setSettingsButtonActive:YES];
    [self.view rotateActivityIndicator:YES];
    if (!self.sourceManager.links.count) {
        // TODO:
//        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
//            [self.feedManager deleteFeed];
//        });
        [self.view clearState];
        [self showError:RSSErrorNoRSSLinkSelected];
        return;
    }
    
    
    // LINKS: ❗️
    NSArray<UVRSSFeed *> *feeds = [self.feedManager.currentFeeds copy];
    [feeds forEach:^(UVRSSFeed *feed) {
        if (![self.sourceManager.selectedLinks containsObject:feed.link]) [self.feedManager deleteFeed:feed];
    }];
    
    __weak typeof(self)weakSelf = self;
    [self.sourceManager.selectedLinks forEach:^(UVRSSLink *link) {
        [weakSelf.feedItemQueue addOperationWithBlock:^{
            if (![weakSelf.feedManager containsLink:link]) {
                [weakSelf.network fetchDataFromURL:link.url completion:^(NSData *data, NSError *error) {
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf showError:RSSErrorTypeBadURL];
                        });
                        return;
                    }
                    [weakSelf.dataRecognizer discoverChannel:data parser:[UVFeedXMLParser new]
                                                  completion:^(NSArray<NSDictionary *> *feed, NSError *error) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf showError:RSSErrorTypeParsingError];
                            });
                            return;
                        }
                        NSError *feedError = nil;
                        if(![weakSelf.feedManager storeFeed:feed forLink:link error:&feedError]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf showError:RSSErrorTypeBadURL];
                            });
                            return;
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.view rotateActivityIndicator:NO];
                            [weakSelf.view updatePresentation];
                        });
                    }];
                }];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view rotateActivityIndicator:NO];
                [weakSelf.view updatePresentation];
            });
        }];
        
    }];
    
    // find diff from SM
    
    
//    NSMutableArray<UVRSSFeed *> *diff = [NSMutableArray new];
//    [self.feedManager.currentFeeds forEach:^(UVRSSFeed *feed) {
//        if (![self.sourceManager.selectedLinks containsObject:feed.link]) [diff addObject:feed];
//    }];
    
    
//    [self.sourceManager.selectedLinks forEach:^(UVRSSLink *link) {
//        // check
//
//
//        [weakSelf.feedItemQueue addOperationWithBlock:^{
//            [weakSelf.network fetchDataFromURL:link.url completion:^(NSData *data, NSError *error) {
//                if (error) {
//                    [weakSelf showError:RSSErrorTypeBadURL];
//                    return;
//                }
//                [weakSelf.dataRecognizer discoverChannel:data parser:[UVFeedXMLParser new]
//                                              completion:^(NSArray<NSDictionary *> *feed, NSError *error) {
//                    if (error) {
//                        [weakSelf showError:RSSErrorTypeParsingError];
//                        return;
//                    }
//                    NSError *feedError = nil;
//                    if(![weakSelf.feedManager storeFeed:feed forLink:link error:&feedError]) {
//                        [weakSelf showError:RSSErrorTypeBadURL];
//                        return;
//                    }
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [weakSelf.view rotateActivityIndicator:NO];
//                        [weakSelf.view updatePresentation];
//                    });
//                }];
//            }];
//        }];
//        [weakSelf.feedManager.currentFeeds forEach:^(UVRSSFeed *feed) {
//
//        }];
//        [weakSelf.feedItemQueue addOperationWithBlock:^{
//            [weakSelf.network fetchDataFromURL:link.url
//                                    completion:^(NSData *data, NSError *error) {
//                if (error || !data) {
//                    [weakSelf showError:RSSErrorNoRSSLinksDiscovered];
//                    return;
//                }
//                [weakSelf.dataRecognizer discoverChannel:data parser:[UVFeedXMLParser new] completion:^(NSDictionary *rawChannel, NSError *error) {
//                    if (error) {
//                        [weakSelf showError:RSSErrorTypeParsingError];
//                        return;
//                    }
//
//                }];
//            }];
//        }];
//    }];
//
//    NSURL *url = self.sourceManager.selectedLink.url;
//    if (!url) {
//        [self.view clearState];
//        [self showError:RSSErrorTypeBadURL];
//        return;
//    }
//
////    __block typeof(self)weakSelf = self;
//    [self.network fetchDataFromURL:url
//                        completion:^(NSData *data, NSError *error) {
//        if(error) {
//            [weakSelf showError:RSSErrorNoRSSLinksDiscovered];
//            return;
//        }
//        [weakSelf discoverChannel:data];
//    }];
}

- (void)openArticleAt:(NSInteger)row {
    if (!self.network.isConnectionAvailable) {
        [self.view setSettingsButtonActive:NO];
        [self showError:RSSErrorTypeNoNetworkConnection];
        return;
    }
    UVRSSFeedItem *item = self.feedItems[row];
    [self.feedManager setState:UVRSSItemReading ofFeedItem:item];
    [self.feedManager selectFeedItem:item];
    [self.coordinator showScreen:PresentationBlockWeb];
}

- (void)settingsButtonClicked {
    [self.coordinator showScreen:PresentationBlockSources];
}

- (void)trashButtonClicked {
    [self.coordinator showScreen:PresentationBlockDone];
}

- (id<UVFeedItemDisplayModel>)itemAt:(NSInteger)index {
    return self.feedItems[index];
}

- (NSInteger)numberOfItems {
    return self.feedItems.count;
}

- (void)markItemDoneAtIndex:(NSInteger)index {
    [self.feedManager setState:UVRSSItemDone ofFeedItem:self.feedItems[index]];
}

- (void)markItemReadAtIndex:(NSInteger)index {
    [self.feedManager setState:UVRSSItemReading ofFeedItem:self.feedItems[index]];
}

- (void)deleteItemAtIndex:(NSInteger)index {
    [self.feedManager setState:UVRSSItemDeleted ofFeedItem:self.feedItems[index]];
}


// TODO: -
- (void)sortByTitle {
    self.sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [self updateFeed];
}

- (void)sortByDate {
    self.sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"pubDate" ascending:NO];
    [self updateFeed];
}

// MARK: - Private

- (NSArray<UVRSSFeedItem *> *)feedItems {
    // TODO: -
    return [[self.feedManager feedItemsWithState:(UVRSSItemNotStarted | UVRSSItemReading)] sortedArrayUsingDescriptors:@[self.sortDescriptor]];
}

- (void)discoverFeed:(NSData *)data link:(UVRSSLink *)link {
    if(!data) {
        [self showError:RSSErrorTypeParsingError];
        return;
    }
    __weak typeof(self)weakSelf = self;
    [self.dataRecognizer discoverChannel:data parser:[UVFeedXMLParser new]
                              completion:^(NSArray<NSDictionary *> *feed, NSError *error) {
        if(error) {
            [weakSelf showError:RSSErrorNoRSSLinksDiscovered];
            return;
        }
        
        NSError *feedError = nil;
        if (![weakSelf.feedManager storeFeed:feed forLink:link error:&feedError]) {
            [weakSelf showError:RSSErrorTypeBadURL];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view rotateActivityIndicator:NO];
            [weakSelf.view updatePresentation];
        });
    }];
}

- (void)showError:(RSSError)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view presentError:[UVChannelFeedPresenter provideErrorOfType:error]];
    });
}

@end
