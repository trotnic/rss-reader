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
        _network = [network retain];
        _coordinator = [coordinator retain];
    }
    return self;
}

- (void)dealloc
{
    [_dataRecognizer release];
    [_sourceManager release];
    [_network release];
    [_coordinator release];
    [super dealloc];
}

// MARK: - UVSourcesListPresenterType

- (NSArray<id<UVRSSLinkViewModel>> *)items {
    return self.sourceManager.links;
}

- (void)selectItemAtIndex:(NSInteger)index {
    // TODO: crash???
    if (!self.network.isConnectionAvailable) {
        [self.view presentError:[UVChannelSourceListPresenter provideErrorOfType:RSSErrorTypeNoNetworkConnection]];
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
