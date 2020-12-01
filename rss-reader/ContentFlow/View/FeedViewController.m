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

CGFloat const kFadeAnimationDuration = 0.1;

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) id<FeedPresenterType> presenter;

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
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [_tableView registerClass:FeedTableViewCell.class forCellReuseIdentifier:FeedTableViewCell.cellIdentifier];
    }
    return _tableView;
}

// MARK: - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedTableViewCell.cellIdentifier forIndexPath:indexPath];
    [cell setupWithViewModel:self.presenter.viewModel.channelItems[indexPath.row]];
    
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

// MARK: - FeedViewType

- (void)updatePresentation {
    [self.tableView reloadData];
    self.navigationItem.title = self.presenter.viewModel.channelTitle;
}

@end
