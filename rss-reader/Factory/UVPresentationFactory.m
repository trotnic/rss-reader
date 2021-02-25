//
//  UVPresentationFactory.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 25.02.21.
//

#import "UVPresentationFactory.h"

#import "UVChannelFeedViewController.h"
#import "UVChannelFeedPresenter.h"

#import "UVSourcesListViewController.h"
#import "UVSourcesListPresenter.h"

@interface UVPresentationFactory ()

@property (nonatomic, retain) id<UVNetworkType> network;
@property (nonatomic, retain) id<UVSourceManagerType> source;
@property (nonatomic, retain) id<UVDataRecognizerType> recognizer;

@end

@implementation UVPresentationFactory

+ (instancetype)factoryWithNetwork:(id<UVNetworkType>)network source:(id<UVSourceManagerType>)source recognizer:(id<UVDataRecognizerType>)recognizer {
    return [[[UVPresentationFactory alloc] initWithNetwork:network source:source recognizer:recognizer] autorelease];
}

- (instancetype)initWithNetwork:(id<UVNetworkType>)network
                         source:(id<UVSourceManagerType>)source
                     recognizer:(id<UVDataRecognizerType>)recognizer
{
    self = [super init];
    if (self) {
        _network = [network retain];
        _source = [source retain];
        _recognizer = [recognizer retain];
    }
    return self;
}

- (void)dealloc
{
    [_network release];
    [_source release];
    [_recognizer release];
    [super dealloc];
}

// MARK: -

- (UIViewController *)presentationBlockOfType:(UVPresentationBlockType)type coordinator:(id<UVAppCoordinatorType>)coordinator {
    switch (type) {
        case UVPresentationBlockFeed: {
            UVChannelFeedViewController *controller = [UVChannelFeedViewController new];
            UVChannelFeedPresenter *presenter = [[UVChannelFeedPresenter alloc] initWithRecognizer:self.recognizer
                                                                                     sourceManager:self.source
                                                                                           network:self.network
                                                                                       coordinator:coordinator];
            controller.presenter = [presenter autorelease];
            presenter.viewDelegate = controller;
            return [controller autorelease];
        }
            
        case UVPresentationBlockSources: {
            UVSourcesListViewController *controller = [UVSourcesListViewController new];
            UVSourcesListPresenter *presenter = [[UVSourcesListPresenter alloc] initWithRecognizer:self.recognizer
                                                                                     sourceManager:self.source
                                                                                           network:self.network
                                                                                       coordinator:coordinator];
            controller.presenter = [presenter autorelease];
            presenter.viewDelegate = controller;
            return [controller autorelease];
        }
    }
}

@end
