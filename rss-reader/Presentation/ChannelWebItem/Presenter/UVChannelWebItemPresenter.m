//
//  UVChannelWebItemPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 15.02.21.
//

#import "UVChannelWebItemPresenter.h"

@interface UVChannelWebItemPresenter ()

@property (nonatomic, strong) id<UVCoordinatorType> coordinator;
@property (nonatomic, strong) id<UVFeedManagerType> feed;

@end

@implementation UVChannelWebItemPresenter

- (instancetype)initWithCoordinator:(id<UVCoordinatorType>)coordinator
                               feed:(id<UVFeedManagerType>)feed {
    self = [super init];
    if (self) {
        _coordinator = coordinator;
        _feed = feed;
    }
    return self;
}

// MARK: - UVChannelWebItemPresenterType

- (void)loadPage {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.feed.selectedItem.url];
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
    [self.coordinator closeCurrentScreen];
}

- (void)browserButtonClick {
    [self.coordinator openURL:self.feed.selectedItem.url];
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
