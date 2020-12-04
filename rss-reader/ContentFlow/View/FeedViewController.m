//
//  FeedViewController.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "FeedViewController.h"
#import "FeedChannelViewModel.h"
#import "FeedTableViewCell.h"
#import "FeedPresenterType.h"
#import "UIViewController+ErrorPresenter.h"
#import "FeedItemWebViewController.h"

CGFloat const kFadeAnimationDuration = 0.1;

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIRefreshControl *refreshControl;

@property (nonatomic, retain) UIViewController<FeedItemWebViewType> *webView;

@property (nonatomic, retain) id<FeedPresenterType> presenter;


//@property (nonatomic, assign) CGPoint frozenContentOffsetForRowAnimation;

@end

@implementation FeedViewController

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter
{
    self = [super init];
    if (self) {
        _presenter = [presenter retain];
        [_presenter assignView:self];
    }
    return self;
}

- (void)dealloc
{
    [_presenter release];
    [_tableView release];
    [_refreshControl release];
    [_activityIndicator release];
    [_refreshControl release];
    [super dealloc];
}

// MARK: -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    [self.presenter updateFeed];
}

- (void)setupLayout {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.activityIndicator];

    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
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
        [_tableView registerClass:FeedTableViewCell.class forCellReuseIdentifier:FeedTableViewCell.cellIdentifier];
    }
    return _tableView;
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

- (id<FeedItemWebViewType>)webView {
    if(!_webView) {
        _webView = [FeedItemWebViewController new];
    }
    return _webView;
}

// MARK: - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedTableViewCell.cellIdentifier forIndexPath:indexPath];
    CGPoint originalContentOffset = tableView.contentOffset;
    [cell setupWithViewModel:self.presenter.viewModel.channelItems[indexPath.row] reloadCompletion:^(BOOL toExpand) {
        
        
        
//        CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
//        BOOL completelyVisible = CGRectContainsRect(tableView.bounds, cellRect);
        
        [tableView performBatchUpdates:^{
            [tableView beginUpdates];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
            
//            if(!CGPointEqualToPoint(originalContentOffset, tableView.contentOffset)) {
//                self.frozenContentOffsetForRowAnimation = tableView.contentOffset;
//            }
        } completion:^(BOOL finished) {

        }];
        [tableView beginUpdates];
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
    [self.presenter selectRowAt:indexPath.row];
}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 0.5*self.presenter.viewModel.channelItems[indexPath.row].frame.size.height;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return self.presenter.viewModel.channelItems[indexPath.row].frame.size.height;
//}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.frozenContentOffsetForRowAnimation = CGPointZero;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if(!CGPointEqualToPoint(self.frozenContentOffsetForRowAnimation, CGPointZero) &&
//       !CGPointEqualToPoint(scrollView.contentOffset, self.frozenContentOffsetForRowAnimation)) {
//        [scrollView setContentOffset:self.frozenContentOffsetForRowAnimation animated:NO];
//    }
//}

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
