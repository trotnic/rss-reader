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

static CGFloat const POP_DELAY_ON_WEB_OPEN = 0.5;

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
        __block typeof(self)weakSelf = self;
        _closeWebPageButton = [[UIBarButtonItem alloc] initWithImage:UIImage.xmarkIcon
                                                               style:UIBarButtonItemStylePlain
                                                              action:^{
            [weakSelf.webView stopLoading];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _closeWebPageButton;
}

- (UIBarButtonItem *)openInBrowserButton {
    if(!_openInBrowserButton) {
        __block typeof(self)weakSelf = self;
        _openInBrowserButton = [[UIBarButtonItem alloc] initWithImage:UIImage.safariIcon
                                                                style:UIBarButtonItemStylePlain
                                                               action:^{
            [UIApplication.sharedApplication openURL:self.webView.URL
                                             options:@{}
                                   completionHandler:^(BOOL success) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(POP_DELAY_ON_WEB_OPEN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }];
        }];
    }
    return _openInBrowserButton;
}

// MARK: -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAppearance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

// MARK: - Private

- (void)setupAppearance {
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
    }
    [self layoutWebView];
    [self setupToolbar];
}

- (void)layoutWebView {
    [self.view addSubview:self.webView];
    [NSLayoutConstraint activateConstraints:@[
        [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.webView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.webView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
}

- (void)setupToolbar {
    UIBarButtonItem *spacer = [UIBarButtonItem spacer];
    self.toolbarItems = @[
        self.goBackButton,
        spacer,
        self.goForwardButton,
        spacer,
        self.reloadWebPageButton,
        spacer,
        self.closeWebPageButton,
        spacer,
        self.openInBrowserButton
    ];
}

- (UIBarButtonItem *)webBarButtonItemWithImage:(UIImage *)image action:(SEL)selector {
    return [[[UIBarButtonItem alloc] initWithImage:image
                                             style:UIBarButtonItemStylePlain
                                            target:self.webView
                                            action:selector] autorelease];
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
