//
//  FeedViewController.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

<<<<<<< HEAD:rss-reader/ContentFlow/View/UVChannelFeedViewController.m
#import "UVChannelFeedViewController.h"
#import "UVFeedChannelViewModel.h"
#import "UVFeedTableViewCell.h"
#import "UVChannelFeedPresenterType.h"
#import "UIViewController+ErrorPresenter.h"
#import "UVFeedItemWebViewController.h"
#import "UIBarButtonItem+PrettiInitializable.h"

static CGFloat const kFadeAnimationDuration = 0.1;

@interface UVChannelFeedViewController () <UITableViewDelegate, UITableViewDataSource>
=======
#import "UVFeedViewController.h"
#import "UVFeedTableViewCell.h"
#import "UVFeedChannelDisplayModel.h"

#import "UIViewController+ErrorPresenter.h"
#import "UVFeedItemWebViewController.h"

static CGFloat const kFadeAnimationDuration = 0.1;

@interface UVFeedViewController () <UITableViewDelegate, UITableViewDataSource>
>>>>>>> develop_v1.2:rss-reader/Presentation/ChannelFeed/View/UVFeedViewController.m

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (nonatomic, retain) UIBarButtonItem *settingsButton;
@property (nonatomic, retain) UIViewController<UVFeedItemWebViewType> *webView;

<<<<<<< HEAD:rss-reader/ContentFlow/View/UVChannelFeedViewController.m
@property (nonatomic, retain) id<UVChannelFeedPresenterType> presenter;

@property (nonatomic, copy) void(^rightButtonClickAction)(void);

@end

@implementation UVChannelFeedViewController

- (instancetype)initWithPresenter:(id<UVChannelFeedPresenterType>)presenter
{
    self = [super init];
    if (self) {
        _presenter = [presenter retain];
    }
    return self;
}
=======
@property (nonatomic, retain) UIViewController<UVFeedItemWebViewType> *webView;

@property (nonatomic, retain) id<UVFeedChannelDisplayModel> channel;

@end

@implementation UVFeedViewController
>>>>>>> develop_v1.2:rss-reader/Presentation/ChannelFeed/View/UVFeedViewController.m

- (void)dealloc
{
    [_webView release];
    [_channel release];
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
    
<<<<<<< HEAD:rss-reader/ContentFlow/View/UVChannelFeedViewController.m
    self.navigationItem.rightBarButtonItem = self.settingsButton;
    
=======
>>>>>>> develop_v1.2:rss-reader/Presentation/ChannelFeed/View/UVFeedViewController.m
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
<<<<<<< HEAD:rss-reader/ContentFlow/View/UVChannelFeedViewController.m
        [_tableView registerClass:UVFeedTableViewCell.class
           forCellReuseIdentifier:UVFeedTableViewCell.cellIdentifier];
=======
        [_tableView registerClass:UVFeedTableViewCell.class forCellReuseIdentifier:UVFeedTableViewCell.cellIdentifier];
>>>>>>> develop_v1.2:rss-reader/Presentation/ChannelFeed/View/UVFeedViewController.m
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

- (id<UVFeedItemWebViewType>)webView {
    if(!_webView) {
        _webView = [UVFeedItemWebViewController new];
    }
    return _webView;
}

// MARK: - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
<<<<<<< HEAD:rss-reader/ContentFlow/View/UVChannelFeedViewController.m
    UVFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UVFeedTableViewCell.cellIdentifier
                                                              forIndexPath:indexPath];
    [cell setupWithViewModel:self.presenter.viewModel.channelItems[indexPath.row]
            reloadCompletion:^(BOOL toExpand) {
=======
    UVFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UVFeedTableViewCell.cellIdentifier forIndexPath:indexPath];
    [cell setupWithModel:self.channel.channelItems[indexPath.row] reloadCompletion:^ {
>>>>>>> develop_v1.2:rss-reader/Presentation/ChannelFeed/View/UVFeedViewController.m
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
    return self.channel.channelItems.count;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.presenter openArticleAt:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.channel.channelItems[indexPath.row].frame.size.height;
}

// MARK: - FeedViewType

- (void)updatePresentationWithChannel:(id<UVFeedChannelDisplayModel>)channel {
    self.channel = channel;
    [self.tableView reloadData];
    self.navigationItem.title = [self.channel channelTitle];
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
    [self showError:error];
}

- (void)presentWebPageOnURL:(NSURL *)url {
    [self.webView openURL:url];
    [self.navigationController pushViewController:self.webView animated:YES];
}

@end
