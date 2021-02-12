//
//  PresentationBlockFactory.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 10.02.21.
//

#import "PresentationBlockFactory.h"

#import "UVChannelFeedPresenter.h"
#import "UVChannelFeedViewController.h"

#import "UVSourcesListPresenter.h"
#import "UVSourcesListViewController.h"

#import "UVChannelSearchPresenter.h"
#import "UVChannelSearchViewController.h"

@implementation PresentationBlockFactory

- (UIViewController *)presentationBlockOfType:(PresentationBlockType)type
                                      network:(id<UVNetworkType>)network
                                       source:(id<UVSourceManagerType>)source
                                       parser:(id<UVDataRecognizerType>)parser
                                  coordinator:(id<CoordinatorType>)coordinator {
    switch (type) {
        case PresentationBlockFeed: {
            UVChannelFeedPresenter *presenter = [[UVChannelFeedPresenter alloc] initWithRecognizer:parser
                                                                                     sourceManager:source
                                                                                           network:network
                                                                                       coordinator:coordinator];
            UVChannelFeedViewController *controller = [UVChannelFeedViewController new];
            controller.presenter = presenter;
            presenter.viewDelegate = controller;
            return [controller autorelease];
        }
            
        case PresentationBlockSources: {
            UVSourcesListPresenter *presenter = [[UVSourcesListPresenter alloc] initWithRecognizer:parser
                                                                                     sourceManager:source
                                                                                           network:network
                                                                                       coordinator:coordinator];
            UVSourcesListViewController *controller = [UVSourcesListViewController new];
            controller.presenter = presenter;
            presenter.viewDelegate = controller;
            return [controller autorelease];
        }
        case PresentationBlockSearch: {
            UVChannelSearchPresenter *presenter = [[UVChannelSearchPresenter alloc] initWithRecognizer:parser
                                                                                         sourceManager:source
                                                                                               network:network
                                                                                           coordinator:coordinator];
            UVChannelSearchViewController *controller = [UVChannelSearchViewController new];
            controller.presenter = presenter;
            presenter.viewDelegate = controller;
            
            return [controller autorelease];
        }
        default: return nil;
    }
}

@end
