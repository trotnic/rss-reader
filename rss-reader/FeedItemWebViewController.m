//
//  FeedItemWebViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12/3/20.
//

#import "FeedItemWebViewController.h"
#import <WebKit/WebKit.h>
#import "UIBarButtonItem+PrettiInitializable.h"

@interface FeedItemWebViewController () <WKNavigationDelegate>

@property (nonatomic, retain) WKWebView *webView;

@property (nonatomic, retain) UIBarButtonItem *goBackButton;
@property (nonatomic, retain) UIBarButtonItem *goForwardButton;
@property (nonatomic, retain) UIBarButtonItem *reloadWebPageButton;
@property (nonatomic, retain) UIBarButtonItem *closeWebPageButton;
@property (nonatomic, retain) UIBarButtonItem *openInBrowserButton;

@end

@implementation FeedItemWebViewController

- (void)dealloc
{
    [_webView release];
    [_goBackButton release];
    [_goForwardButton release];
    [_reloadWebPageButton release];
    [_closeWebPageButton release];
    [_openInBrowserButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.webView];
    [NSLayoutConstraint activateConstraints:@[
        [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.webView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.webView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    self.toolbarItems = @[
        self.goBackButton,
        [UIBarButtonItem fillerItem],
        self.goForwardButton,
        [UIBarButtonItem fillerItem],
        self.reloadWebPageButton,
        [UIBarButtonItem fillerItem],
        self.closeWebPageButton,
        [UIBarButtonItem fillerItem],
        self.openInBrowserButton
    ];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

// MARK: - Lazy

- (WKWebView *)webView {
    if(!_webView) {
        _webView = [WKWebView new];
        _webView.navigationDelegate = self;
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _webView;
}

- (UIBarButtonItem *)goBackButton {
    if(!_goBackButton) {
        _goBackButton = [[UIBarButtonItem plainItemWithImage:[UIImage imageNamed:@"arrow-narrow-left"]
                                                      target:self.webView
                                                      action:@selector(goBack)] retain];
    }
    return _goBackButton;
}

- (UIBarButtonItem *)goForwardButton {
    if(!_goForwardButton) {
        _goForwardButton = [[UIBarButtonItem plainItemWithImage:[UIImage imageNamed:@"arrow-narrow-right"]
                                                         target:self.webView
                                                         action:@selector(goForward)] retain];
    }
    return _goForwardButton;
}

- (UIBarButtonItem *)reloadWebPageButton {
    if(!_reloadWebPageButton) {
        _reloadWebPageButton = [[UIBarButtonItem plainItemWithImage:[UIImage imageNamed:@"refresh"]
                                                         target:self.webView
                                                         action:@selector(reload)] retain];
    }
    return _reloadWebPageButton;
}

- (UIBarButtonItem *)closeWebPageButton {
    if(!_closeWebPageButton) {
        _closeWebPageButton = [[UIBarButtonItem plainItemWithImage:[UIImage imageNamed:@"xmark"]
                                                            target:self
                                                            action:@selector(closeWebPage)] retain];
    }
    return _closeWebPageButton;
}

- (UIBarButtonItem *)openInBrowserButton {
    if(!_openInBrowserButton) {
        _openInBrowserButton = [[UIBarButtonItem plainItemWithImage:[UIImage imageNamed:@"safari"]
                                                             target:self
                                                             action:@selector(openInBrowser)] retain];
    }
    return _openInBrowserButton;
}

// MARK: -

- (void)closeWebPage {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openInBrowser {
    [UIApplication.sharedApplication openURL:self.webView.URL options:@{} completionHandler:^(BOOL success) {
        [self closeWebPage];
    }];
}

// MARK: - WKNavigationDelegate

- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated:
            [self.webView loadRequest:navigationAction.request];
            break;
        default:
            break;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

// MARK: - FeedItemWebViewType

- (void)openURL:(NSURL *)url {
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
