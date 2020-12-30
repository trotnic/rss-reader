//
//  FeedViewController.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "UVChanngelFeedViewController.h"
#import "FeedChannelViewModel.h"
#import "FeedTableViewCell.h"
#import "FeedPresenterType.h"
#import "UIViewController+ErrorPresenter.h"
#import "FeedItemWebViewController.h"
#import "UIBarButtonItem+PrettiInitializable.h"

CGFloat const kFadeAnimationDuration = 0.1;

@interface UVChanngelFeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, retain) UIBarButtonItem *settingsButton;
@property (nonatomic, retain) UIViewController<FeedItemWebViewType> *webView;

@property (nonatomic, retain) id<FeedPresenterType> presenter;

@property (nonatomic, copy) void(^rightButtonClickAction)(void);

@end

@implementation UVChanngelFeedViewController

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter
{
    self = [super init];
    if (self) {
        _presenter = [presenter retain];
    }
    return self;
}

- (void)dealloc
{
    [_webView release];
    [_presenter release];
    [_tableView release];
    [_refreshControl release];
    [_activityIndicator release];
    [_rightButtonClickAction release];
    [_settingsButton release];
    [super dealloc];
}

// MARK: -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.presenter updateFeed];
}

- (void)setupLayout {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.activityIndicator];
    
    self.navigationItem.rightBarButtonItem = self.settingsButton;
    
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

// MARK: - Lazy Properties

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.refreshControl = self.refreshControl;
        _tableView.tableFooterView = [[UIView new] autorelease];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [_tableView registerClass:FeedTableViewCell.class
           forCellReuseIdentifier:FeedTableViewCell.cellIdentifier];
    }
    return _tableView;
}

- (UIBarButtonItem *)settingsButton {
    if(!_settingsButton) {
        _settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear"]
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(settingsButtonClick)];
    }
    return _settingsButton;
}

- (void)settingsButtonClick {
    self.rightButtonClickAction();
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
        [_refreshControl addTarget:self.presenter action:@selector(updateFeed)
                  forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (id<FeedItemWebViewType>)webView {
    if(!_webView) {
        _webView = [FeedItemWebViewController new];
    }
    return _webView;
}

// MARK: - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedTableViewCell.cellIdentifier
                                                              forIndexPath:indexPath];
    [cell setupWithViewModel:self.presenter.viewModel.channelItems[indexPath.row]
                 reloadBlock:^(BOOL toExpand) {
        CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
        [tableView beginUpdates];
        if (!CGRectContainsRect(tableView.bounds, cellRect)) {
            [tableView scrollToRowAtIndexPath:indexPath
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:YES];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }];
    
    cell.alpha = 0;
    [UIView animateWithDuration:kFadeAnimationDuration animations:^{
        cell.alpha = 1;
    }];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presenter.viewModel.channelItems.count;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.presenter showDetailAt:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.presenter.viewModel.channelItems[indexPath.row].frame.size.height;
}

// MARK: - FeedViewType

- (void)updatePresentation {
    [self.tableView reloadData];
    self.navigationItem.title = [self.presenter.viewModel channelTitle];
    [self.refreshControl endRefreshing];
}

- (void)toggleActivityIndicator:(BOOL)show {
    if (show) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
}

- (void)presentError:(NSError *)error {
    [self showError:error];
}

- (void)presentWebPageOnLink:(NSString *)link {
    [self.webView openURL:[NSURL URLWithString:link]];
    [self.navigationController pushViewController:self.webView animated:YES];
}

@end
