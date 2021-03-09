//
//  FeedViewController.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "UVChannelFeedViewController.h"
#import "UVFeedTableViewCell.h"
#import "UVChannelFeedPresenterType.h"

#import "UIImage+AppIcons.h"
#import "UITableViewCell+Util.h"
#import "UIViewController+Util.h"
#import "UIBarButtonItem+PrettiInitializable.h"

static CGFloat const FADE_ANIMATION_DURATION    = 0.1;
static NSInteger const REFRESH_ENDING_DELAY     = 1;

@interface UVChannelFeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *settingsButton;
@property (nonatomic, strong) UIBarButtonItem *trashButton;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation UVChannelFeedViewController

// MARK: - Lazy Properties

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.refreshControl = self.refreshControl;
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
                                                          action:@selector(settingsButtonClicked)];
    }
    return _settingsButton;
}

- (UIBarButtonItem *)trashButton {
    if (!_trashButton) {
        _trashButton = [[UIBarButtonItem alloc] initWithImage:UIImage.trashIcon
                                                        style:UIBarButtonItemStylePlain
                                                       target:self.presenter
                                                       action:@selector(trashButtonClicked)];
    }
    return _trashButton;
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
        [_refreshControl addTarget:self.presenter action:@selector(updateFeed) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

// MARK: -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAppearance];
    [self.presenter updateFeed];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) [self.presenter updateFeed];
}

// MARK: - Private

- (void)setupAppearance {
    self.navigationItem.rightBarButtonItem = self.settingsButton;
    self.navigationItem.leftBarButtonItem = self.trashButton;
    [self layoutActivityIndicator];
    [self layoutTableView];
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

// MARK: - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UVFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UVFeedTableViewCell.cellIdentifier forIndexPath:indexPath];
    [cell setupWithModel:[self.presenter itemAt:indexPath.row]
        reloadCompletion:^(void (^callback)(void)) {
        [tableView performBatchUpdates:^{
            callback();
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
    [self.presenter openArticleAt:indexPath.row];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIContextualAction *markDone = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:NSLocalizedString(DONE, "")
                                                                         handler:^(UIContextualAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        [self.presenter markItemDoneAtIndex:indexPath.row];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
        completionHandler(YES);
    }];
    markDone.backgroundColor = UIColor.blueColor;
    UIContextualAction *markRead = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:NSLocalizedString(READ, "")
                                                                         handler:^(UIContextualAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        [self.presenter markItemReadAtIndex:indexPath.row];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
        completionHandler(YES);
    }];
    markRead.backgroundColor = UIColor.orangeColor;
    return [UISwipeActionsConfiguration configurationWithActions:@[markDone, markRead]];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:NSLocalizedString(DELETE, "")
                                                                       handler:^(UIContextualAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        [self.presenter deleteItemAtIndex:indexPath.row];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView reloadData];
            completionHandler(YES);
        });
    }];
    return [UISwipeActionsConfiguration configurationWithActions:@[delete]];
}

// MARK: - UVChannelFeedViewType

- (void)updatePresentation {
    [self hidePlaceholderMessage];
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REFRESH_ENDING_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
    });
}

- (void)presentError:(NSError *)error {
    if (self.refreshControl.isRefreshing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REFRESH_ENDING_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [self.activityIndicator stopAnimating];
        });
    }
    [self showError:error];
}

- (void)rotateActivityIndicator:(BOOL)show {
    if (show) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
}

- (void)clearState {
    [self showPlaceholderMessage:NSLocalizedString(NO_CONTENTS_MESSAGE, "")];
    self.navigationItem.title = nil;
    [self.tableView reloadData];
}

- (void)setSettingsButtonActive:(BOOL)active {
    self.navigationItem.rightBarButtonItem.enabled = active;
}

@end
