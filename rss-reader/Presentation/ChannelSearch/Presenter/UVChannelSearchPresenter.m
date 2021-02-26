//
//  UVChannelSearchPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11.02.21.
//

#import "UVChannelSearchPresenter.h"
#import "NSArray+Util.h"

@interface UVChannelSearchPresenter ()

@property (nonatomic, retain, readwrite) id<UVDataRecognizerType>   dataRecognizer;
@property (nonatomic, retain, readwrite) id<UVSourceManagerType>    sourceManager;
@property (nonatomic, retain, readwrite) id<UVNetworkType>          network;
@property (nonatomic, retain, readwrite) id<UVCoordinatorType>      coordinator;

@end

@implementation UVChannelSearchPresenter

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                            source:(id<UVSourceManagerType>)source
                           network:(id<UVNetworkType>)network
                       coordinator:(id<UVCoordinatorType>)coordinator {
    self = [super init];
    if (self) {
        _dataRecognizer = recognizer;
        _sourceManager = source;
        self.network = network;
        _coordinator = coordinator;
    }
    return self;
}

- (void)dealloc
{
    [_network unregisterObserver:NSStringFromClass([self class])];
}

// MARK: -

- (void)setNetwork:(id<UVNetworkType>)network {
    if (network != _network) {
        [_network unregisterObserver:NSStringFromClass([self class])];
        _network = network;
        __block typeof(self)weakSelf = self;
        [network registerObserver:NSStringFromClass([self class]) callback:^(BOOL isConnectionStable) {
            if (!isConnectionStable) [weakSelf presentError:RSSErrorTypeNoNetworkConnection];
        }];
    }
}

// MARK: - UVChannelSearchPresenterType

- (void)searchWithToken:(NSString *)token {
    if (!self.network.isConnectionAvailable) {
        [self presentError:RSSErrorTypeNoNetworkConnection];
        return;
    }
    NSError *error = nil;
    NSURL *url = [self.network validateAddress:token error:&error];
    
    if (error || !url) {
        [self presentError:RSSErrorTypeBadURL];
        return;
    }
    
    __block typeof(self)weakSelf = self;
    [self.network fetchDataFromURL:url
                        completion:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf presentError:RSSErrorTypeBadURL];
            });
            return;
        }
        [weakSelf discoverLinks:data url:url];
    }];
}

// MARK: - Private

- (void)discoverLinks:(NSData *)data url:(NSURL *)url {
    if (!data || !url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentError:RSSErrorTypeParsingError];
        });
        return;
    }
    
    __block typeof(self)weakSelf = self;
    [self.dataRecognizer discoverContentType:data
                                  completion:^(UVRawContentType type, NSError *error) {
        if (type == UVRawContentHTML) {
            [weakSelf.dataRecognizer discoverLinksFromHTML:data
                                                completion:^(NSArray<NSDictionary *> *links, NSError *error) {
                [weakSelf insertRawLinks:links baseURL:url error:error];
            }];
        } else if (type == UVRawContentXML) {
            [weakSelf.dataRecognizer discoverLinksFromXML:data
                                                      url:url
                                               completion:^(NSArray<NSDictionary *> *links, NSError *error) {
                [weakSelf insertRawLinks:links baseURL:url error:error];
            }];
        } else if (type == UVRawContentUndefined || error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentError:RSSErrorNoRSSLinkSelected];
            });
        }
    }];
}

- (void)insertRawLinks:(NSArray<NSDictionary *> *)links
               baseURL:(NSURL *)url error:(NSError *)error {
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentError:RSSErrorNoRSSLinkSelected];
        });
        return;
    }
    [links forEach:^(NSDictionary *rawLink) {
        [self.sourceManager insertLink:rawLink relativeToURL:url];
    }];
    
    NSError *saveError = nil;
    [self.sourceManager saveState:&saveError];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.coordinator showScreen:PresentationBlockFeed];
    });
    
}

- (void)saveState {
    NSError *error = nil;
    [self.sourceManager saveState:&error];
    if(error) {
        [self.sourceManager saveState:&error];
        NSLog(@"%@", error);
    }
}

- (void)presentError:(RSSError)errorType {
    [self.view presentError:[UVChannelSearchPresenter provideErrorOfType:errorType]];
}

@end
