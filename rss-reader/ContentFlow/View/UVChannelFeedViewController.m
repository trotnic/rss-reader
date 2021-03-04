//
//  FeedViewController.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "UVChannelFeedViewController.h"
#import "UVFeedTableViewCell.h"
#import "UVChannelFeedPresenterType.h"
#import "UVFeedItemWebViewController.h"

#import "UIImage+AppIcons.h"
#import "UIViewController+Util.h"

static CGFloat const FADE_ANIMATION_DURATION    = 0.1;
static NSInteger const REFRESH_ENDING_DELAY     = 1;

@interface UVChannelFeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, retain) UIBarButtonItem *settingsButton;
@property (nonatomic, retain) UIViewController<UVFeedItemWebViewType> *webView;

@property (nonatomic, copy) void(^rightButtonClickAction)(void);

@end

@implementation UVChannelFeedViewController

- (void)dealloc
{
    [_webView release];
    [_presenter release];
    [_tableView release];
    [_settingsButton release];
    [_refreshControl release];
    [_activityIndicator release];
    [_rightButtonClickAction release];
    [super dealloc];
}

// MARK: - Lazy Properties

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.refreshControl = self.refreshControl;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [[UIView new] autorelease];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [_tableView registerClass:UVFeedTableViewCell.class forCellReuseIdentifier:UVFeedTableViewCell.cellIdentifier];
    }
    return _tableView;
}

- (UIBarButtonItem *)settingsButton {
    if(!_settingsButton) {
        _settingsButton = [[UIBarButtonItem alloc] initWithImage:UIImage.gearIcon
                                                           style:UIBarButtonItemStylePlain
                                                          target:self.presenter
                                                          action:@selector(didTapSettingsButton)];
    }
    return _settingsButton;
}

- (UIActivityIndicatorView *)activityIndicator {
    if(!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.center = self.view.center;
    }
    return _activityIndicator;
}

- (UIRefreshControl *)refreshControl {
    if(!_refreshControl) {
        _refreshControl = [UIRefreshControl new];
        [_refreshControl addTarget:self.presenter
                            action:@selector(updateFeed)
                  forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (id<UVFeedItemWebViewType>)webView {
    if(!_webView) {
        _webView = [UVFeedItemWebViewController new];
    }
    return _webView;
}

// MARK: -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAppearance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.presenter updateFeed];
}

- (void)setupAppearance {
    [self layoutActivityIndicator];
    [self layoutTableView];
    self.navigationItem.rightBarButtonItem = self.settingsButton;
}

- (void)layoutActivityIndicator {
    [self.view addSubview:self.activityIndicator];
}

- (void)layoutTableView {
    [self.view addSubview:self.tableView];
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

// MARK: -

- (void)setupOnRighButtonClickAction:(void(^)(void))completion {
    self.rightButtonClickAction = completion;
}

// MARK: - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UVFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UVFeedTableViewCell.cellIdentifier forIndexPath:indexPath];
    [cell setupWithModel:[self.presenter feedItemAt:indexPath.row] reloadCompletion:^(void (^callback)(void)) {
        [tableView performBatchUpdates:^{
            if (callback) callback();
        } completion:nil];
    }];
    
    cell.alpha = 0;
    [UIView animateWithDuration:FADE_ANIMATION_DURATION animations:^{
        cell.alpha = 1;
    }];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presenter.numberOfItems;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.presenter didSelectItemAt:indexPath.row];
}

// MARK: - UVChannelFeedViewType

- (void)updatePresentation {
    [self hidePlaceholderMessage];
    [self.tableView reloadData];
    self.navigationItem.title = [self.presenter.channel channelTitle];
    [self.refreshControl endRefreshing];
}

- (void)rotateActivityIndicator:(BOOL)show {
    if (show) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
}

- (void)presentError:(NSError *)error {
    if (self.refreshControl.isRefreshing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REFRESH_ENDING_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
        });
    }
    [self showError:error];
}

- (void)presentWebPageOnURL:(NSURL *)url {
    [self.webView openURL:url];
    [self.navigationController pushViewController:self.webView animated:YES];
}

- (void)clearState {
    [self showPlaceholderMessage:NSLocalizedString(NO_CONTENTS_MESSAGE, "")];
    self.navigationItem.title = nil;
    [self.tableView reloadData];
}

@end
