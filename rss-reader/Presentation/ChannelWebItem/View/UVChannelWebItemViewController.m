//
//  UVChannelWebItemViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 15.02.21.
//

#import "UVChannelWebItemViewController.h"

#import <WebKit/WebKit.h>

#import "LocalConstants.h"

#import "UIImage+AppIcons.h"
#import "UIBarButtonItem+PrettiInitializable.h"

@interface UVChannelWebItemViewController ()

@property (nonatomic, strong) UIBarButtonItem *goBackButton;
@property (nonatomic, strong) UIBarButtonItem *goForwardButton;
@property (nonatomic, strong) UIBarButtonItem *reloadWebPageButton;
@property (nonatomic, strong) UIBarButtonItem *closeWebPageButton;
@property (nonatomic, strong) UIBarButtonItem *openInBrowserButton;

@property (nonatomic, strong) UIBarButtonItem *doneButton;

@end

@implementation UVChannelWebItemViewController

@synthesize webView = _webView;

// MARK: - Lazy Properties

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
        _goBackButton = [self presenterItemWithImage:UIImage.arrowLeftIcon
                                            selector:@selector(backButtonClick)];
    }
    return _goBackButton;
}

- (UIBarButtonItem *)goForwardButton {
    if(!_goForwardButton) {
        _goForwardButton = [self presenterItemWithImage:UIImage.arrowRightIcon
                                               selector:@selector(forwardButtonClick)];
    }
    return _goForwardButton;
}

- (UIBarButtonItem *)reloadWebPageButton {
    if(!_reloadWebPageButton) {
        _reloadWebPageButton = [self presenterItemWithImage:UIImage.refreshIcon
                                                   selector:@selector(reloadButtonClick)];
    }
    return _reloadWebPageButton;
}

- (UIBarButtonItem *)closeWebPageButton {
    if(!_closeWebPageButton) {
        _closeWebPageButton = [self presenterItemWithImage:UIImage.xmarkIcon
                                                  selector:@selector(closeButtonClick)];
    }
    return _closeWebPageButton;
}

- (UIBarButtonItem *)openInBrowserButton {
    if(!_openInBrowserButton) {
        _openInBrowserButton = [self presenterItemWithImage:UIImage.safariIcon
                                                   selector:@selector(browserButtonClick)];
    }
    return _openInBrowserButton;
}

- (UIBarButtonItem *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(DONE, "")
                                                       style:UIBarButtonItemStylePlain
                                                      target:self.presenter
                                                      action:@selector(doneButtonClick)];
    }
    return _doneButton;
}

// MARK: -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAppearance];
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

// MARK: - Private

- (void)setupAppearance {
    if (@available(iOS 13, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
    }
    [self layoutWebView];
    [self setupToolbar];
    self.navigationItem.rightBarButtonItem = self.doneButton;
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
    UIBarButtonItem *spacer = [UIBarButtonItem spacerItem];
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

- (UIBarButtonItem *)presenterItemWithImage:(UIImage *)image selector:(SEL)selector {
    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self.presenter action:selector];
}

@end
