//
//  UVChannelWebItemViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 15.02.21.
//

#import "UVChannelWebItemViewController.h"

#import <WebKit/WebKit.h>

#import "UIImage+AppIcons.h"
#import "UIBarButtonItem+PrettiInitializable.h"

@interface UVChannelWebItemViewController ()

@property (nonatomic, strong) UIBarButtonItem *goBackButton;
@property (nonatomic, strong) UIBarButtonItem *goForwardButton;
@property (nonatomic, strong) UIBarButtonItem *reloadWebPageButton;
@property (nonatomic, strong) UIBarButtonItem *closeWebPageButton;
@property (nonatomic, strong) UIBarButtonItem *openInBrowserButton;

@end

@implementation UVChannelWebItemViewController

@synthesize webView = _webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    [self.presenter loadPage];
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

// MARK: - Lazy

- (WKWebView *)webView {
    if(!_webView) {
        _webView = [WKWebView new];
        _webView.navigationDelegate = self.presenter;
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _webView;
}

- (UIBarButtonItem *)goBackButton {
    if(!_goBackButton) {
        _goBackButton = [[UIBarButtonItem alloc] initWithImage:UIImage.arrowLeftIcon
                                                         style:UIBarButtonItemStylePlain
                                                        target:self.presenter
                                                        action:@selector(backButtonClick)];
    }
    return _goBackButton;
}

- (UIBarButtonItem *)goForwardButton {
    if(!_goForwardButton) {
        _goForwardButton = [[UIBarButtonItem alloc] initWithImage:UIImage.arrowRightIcon
                                                            style:UIBarButtonItemStylePlain
                                                           target:self.presenter
                                                           action:@selector(forwardButtonClick)];
    }
    return _goForwardButton;
}

- (UIBarButtonItem *)reloadWebPageButton {
    if(!_reloadWebPageButton) {
        _reloadWebPageButton = [[UIBarButtonItem alloc] initWithImage:UIImage.refreshIcon
                                                                style:UIBarButtonItemStylePlain
                                                               target:self.presenter
                                                               action:@selector(reloadButtonClick)];
    }
    return _reloadWebPageButton;
}

- (UIBarButtonItem *)closeWebPageButton {
    if(!_closeWebPageButton) {
        _closeWebPageButton = [[UIBarButtonItem alloc] initWithImage:UIImage.xmarkIcon
                                                               style:UIBarButtonItemStylePlain
                                                              target:self.presenter
                                                              action:@selector(closeButtonClick)];
    }
    return _closeWebPageButton;
}

- (UIBarButtonItem *)openInBrowserButton {
    if(!_openInBrowserButton) {
        _openInBrowserButton = [[UIBarButtonItem alloc] initWithImage:UIImage.safariIcon
                                                                style:UIBarButtonItemStylePlain
                                                               target:self.presenter
                                                               action:@selector(browserButtonClick)];
    }
    return _openInBrowserButton;
}

//// MARK: -
//
//- (void)closeWebPage {
//    [self.webView stopLoading];
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)openInBrowser {
//    [UIApplication.sharedApplication openURL:self.webView.URL
//                                     options:@{}
//                           completionHandler:^(BOOL success) {
//        [self closeWebPage];
//    }];
//}

//// MARK: - FeedItemWebViewType
//
//- (void)openURL:(NSURL *)url {
//    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
//}

@end
