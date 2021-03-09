//
//  UVChannelWebItemPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 15.02.21.
//

#import "UVChannelWebItemPresenter.h"

@interface UVChannelWebItemPresenter ()

@property (nonatomic, strong) id<UVCoordinatorType> coordinator;
@property (nonatomic, strong) id<UVFeedManagerType> feedManager;

@end

@implementation UVChannelWebItemPresenter

- (instancetype)initWithCoordinator:(id<UVCoordinatorType>)coordinator
                               feed:(id<UVFeedManagerType>)feed {
    self = [super init];
    if (self) {
        _coordinator = coordinator;
        _feedManager = feed;
    }
    return self;
}

// MARK: - UVChannelWebItemPresenterType

- (void)loadPage {
    // TODO: probably move a moment of creation into the UVNetwork class
    NSURLRequest *request = [NSURLRequest requestWithURL:self.feedManager.selectedFeedItem.url];
    [self.view.webView loadRequest:request];
}

- (void)backButtonClick {
    [self.view.webView goBack];
}

- (void)forwardButtonClick {
    [self.view.webView goForward];
}

- (void)reloadButtonClick {
    [self.view.webView reload];
}

- (void)closeButtonClick {
    [self.view.webView stopLoading];
    [self.coordinator showScreen:PresentationBlockFeed];
}

- (void)browserButtonClick {
    [self.coordinator openURL:self.feedManager.selectedFeedItem.url];
}

- (void)doneButtonClick {
    // FEED:
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        UVRSSFeedItem *selectedItem = self.feedManager.selectedFeedItem;
        [self.feedManager setState:UVRSSItemDone ofFeedItem:selectedItem];
    });
    [self.coordinator showScreen:PresentationBlockFeed];
}

// MARK: - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated:
            [self.view.webView loadRequest:navigationAction.request];
            break;
        default:
            break;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
