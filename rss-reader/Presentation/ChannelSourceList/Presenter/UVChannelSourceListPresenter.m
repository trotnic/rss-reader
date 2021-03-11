//
//  UVChannelSourceListPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import "UVChannelSourceListPresenter.h"
#import "NSArray+Util.h"

@interface UVChannelSourceListPresenter ()

@property (nonatomic, retain, readwrite) id<UVDataRecognizerType>   dataRecognizer;
@property (nonatomic, retain, readwrite) id<UVSourceManagerType>    sourceManager;
@property (nonatomic, retain, readwrite) id<UVNetworkType>          network;
@property (nonatomic, retain, readwrite) id<UVCoordinatorType>      coordinator;

@property (nonatomic, retain) NSUUID *uuid;

@end

@implementation UVChannelSourceListPresenter

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                            source:(id<UVSourceManagerType>)source
                           network:(id<UVNetworkType>)network
                       coordinator:(id<UVCoordinatorType>)coordinator {
    self = [super init];
    if (self) {
        _dataRecognizer = [recognizer retain];
        _sourceManager = [source retain];
        _coordinator = [coordinator retain];
        self.network = network;
    }
    return self;
}

- (void)dealloc
{
    [_network unregisterObserver:self.uuid.UUIDString];
    [_dataRecognizer release];
    [_sourceManager release];
    [_network release];
    [_coordinator release];
    [_uuid release];
    [super dealloc];
}

// MARK: - Lazy Properties

- (NSUUID *)uuid {
    if (!_uuid) {
        _uuid = [NSUUID.UUID retain];
    }
    return _uuid;
}

- (void)setNetwork:(id<UVNetworkType>)network {
    if (network != _network) {
        [network retain];
        [_network unregisterObserver:self.uuid.UUIDString];
        [_network release];
        _network = network;
        __block typeof(self)weakSelf = self;
        [network registerObserver:self.uuid.UUIDString callback:^(BOOL isConnectionStable) {
            if (!isConnectionStable) [weakSelf.view presentError:[UVBasePresenter provideErrorOfType:RSSErrorTypeNoNetworkConnection]];
        }];
    }
}

// MARK: - UVSourcesListPresenterType

- (void)selectItemAtIndex:(NSInteger)index {
    if (!self.network.isConnectionAvailable) {
        NSError *error = [UVBasePresenter provideErrorOfType:RSSErrorTypeNoNetworkConnection];
        [self.view presentError:error];
        return;
    }
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        [self.sourceManager selectLink:self.sourceManager.links[index]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view updatePresentation];
        });
        [self saveState];
    });
}

- (void)deleteItemAtIndex:(NSInteger)index {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        [self.sourceManager deleteLink:self.sourceManager.links[index]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view updatePresentation];
        });
        [self saveState];
    });
}

- (void)searchButtonClicked {
    [self.coordinator showScreen:PresentationBlockSearch];
}

- (NSInteger)numberOfItems {
    return self.sourceManager.links.count;
}

- (id<UVRSSLinkViewModel>)itemAt:(NSInteger)index {
    return self.sourceManager.links[index];
}

// MARK: - Private

- (void)saveState {
    NSError *error = nil;
    [self.sourceManager saveState:&error];
    if(error) {
        [self.sourceManager saveState:&error];
        NSLog(@"%@", error);
    }
}

@end
