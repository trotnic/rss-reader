//
//  UVPresentationBlockFactory.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 10.02.21.
//

#import "UVPresentationBlockFactory.h"

#import "UVChannelFeedPresenter.h"
#import "UVChannelFeedViewController.h"

#import "UVChannelSourceListPresenter.h"
#import "UVChannelSourceListViewController.h"

#import "UVChannelSearchPresenter.h"
#import "UVChannelSearchViewController.h"

#import "UVChannelWebItemPresenter.h"
#import "UVChannelWebItemViewController.h"

@interface UVPresentationBlockFactory ()

@property (nonatomic, strong) id<UVNetworkType>         network;
@property (nonatomic, strong) id<UVSourceManagerType>   source;
@property (nonatomic, strong) id<UVDataRecognizerType>  recognizer;
@property (nonatomic, strong) id<UVFeedManagerType>     feed;

@end

@implementation UVPresentationBlockFactory

- (instancetype)initWithNetwork:(id<UVNetworkType>)network
                         source:(id<UVSourceManagerType>)source
                     recognizer:(id<UVDataRecognizerType>)recognizer
                           feed:(id<UVFeedManagerType>)feed {
    self = [super init];
    if (self) {
        _network = network;
        _source = source;
        _recognizer = recognizer;
        _feed = feed;
    }
    return self;
}

- (UIViewController *)presentationBlockOfType:(PresentationBlockType)type
                                  coordinator:(id<UVCoordinatorType>)coordinator {
    switch (type) {
        case PresentationBlockFeed: {
            UVChannelFeedPresenter *presenter = [[UVChannelFeedPresenter alloc] initWithRecognizer:self.recognizer
                                                                                            source:self.source
                                                                                           network:self.network
                                                                                              feed:self.feed
                                                                                       coordinator:coordinator];
            UVChannelFeedViewController *controller = [UVChannelFeedViewController new];
            controller.presenter = presenter;
            presenter.viewDelegate = controller;
            return [controller autorelease];
        }
            
        case PresentationBlockSources: {
            UVChannelSourceListPresenter *presenter = [[UVChannelSourceListPresenter alloc] initWithRecognizer:self.recognizer
                                                                                                        source:self.source
                                                                                                       network:self.network
                                                                                                   coordinator:coordinator];
            UVChannelSourceListViewController *controller = [UVChannelSourceListViewController new];
            controller.presenter = presenter;
            presenter.viewDelegate = controller;
            return [controller autorelease];
        }
        case PresentationBlockSearch: {
            UVChannelSearchPresenter *presenter = [[UVChannelSearchPresenter alloc] initWithRecognizer:self.recognizer
                                                                                                source:self.source
                                                                                               network:self.network
                                                                                           coordinator:coordinator];
            UVChannelSearchViewController *controller = [UVChannelSearchViewController new];
            controller.presenter = presenter;
            presenter.viewDelegate = controller;
            return [controller autorelease];
        }
        case PresentationBlockWeb: {
            UVChannelWebItemPresenter *presenter = [[UVChannelWebItemPresenter alloc] initWithCoordinator:coordinator feed:self.feed];
            UVChannelWebItemViewController *controller = [UVChannelWebItemViewController new];
            
            controller.presenter = presenter;
            presenter.view = controller;
            return [controller autorelease];
        }
        default: return nil;
    }
}

@end
