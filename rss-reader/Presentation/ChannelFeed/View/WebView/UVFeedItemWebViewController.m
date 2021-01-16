//
//  FeedItemWebViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12/3/20.
//

#import "UVFeedItemWebViewController.h"

#import <WebKit/WebKit.h>

#import "UIImage+AppIcons.h"
#import "UIBarButtonItem+PrettiInitializable.h"

@interface UVFeedItemWebViewController () <WKNavigationDelegate>

@property (nonatomic, retain) WKWebView *webView;

@property (nonatomic, retain) UIBarButtonItem *goBackButton;
@property (nonatomic, retain) UIBarButtonItem *goForwardButton;
@property (nonatomic, retain) UIBarButtonItem *reloadWebPageButton;
@property (nonatomic, retain) UIBarButtonItem *closeWebPageButton;
@property (nonatomic, retain) UIBarButtonItem *openInBrowserButton;

@end

@implementation UVFeedItemWebViewController

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
    [self setupLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

// MARK: -

- (void)setupLayout {
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

- (UIBarButtonItem *)webBarButtonItemWithImage:(UIImage *)image action:(SEL)selector {
    return [[[UIBarButtonItem alloc] initWithImage:image
                                             style:UIBarButtonItemStylePlain
                                            target:self.webView
                                            action:selector] autorelease];
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
        _goBackButton = [[self webBarButtonItemWithImage:UIImage.arrowLeftIcon
                                                  action:@selector(goBack)] retain];
    }
    return _goBackButton;
}

- (UIBarButtonItem *)goForwardButton {
    if(!_goForwardButton) {
        _goForwardButton = [[self webBarButtonItemWithImage:UIImage.arrowRightIcon
                                                     action:@selector(goForward)] retain];
    }
    return _goForwardButton;
}

- (UIBarButtonItem *)reloadWebPageButton {
    if(!_reloadWebPageButton) {
        _reloadWebPageButton = [[self webBarButtonItemWithImage:UIImage.refreshIcon
                                                         action:@selector(reload)] retain];
    }
    return _reloadWebPageButton;
}

- (UIBarButtonItem *)closeWebPageButton {
    if(!_closeWebPageButton) {
        _closeWebPageButton = [[UIBarButtonItem alloc] initWithImage:UIImage.xmarkIcon
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(closeWebPage)];
    }
    return _closeWebPageButton;
}

- (UIBarButtonItem *)openInBrowserButton {
    if(!_openInBrowserButton) {
        _openInBrowserButton = [[UIBarButtonItem alloc] initWithImage:UIImage.safariIcon
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(openInBrowser)];
    }
    return _openInBrowserButton;
}

// MARK: -

- (void)closeWebPage {
    [self.webView stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openInBrowser {
    [UIApplication.sharedApplication openURL:self.webView.URL
                                     options:@{}
                           completionHandler:^(BOOL success) {
        [self closeWebPage];
    }];
}

// MARK: - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
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
