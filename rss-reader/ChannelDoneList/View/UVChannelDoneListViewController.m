//
//  UVChannelDoneListViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 3.03.21.
//

#import "UVChannelDoneListViewController.h"

#import "UVFeedTableViewCell.h"
#import "UITableViewCell+Util.h"

@interface UVChannelDoneListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation UVChannelDoneListViewController

// MARK: - Lazy Properties

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:UVFeedTableViewCell.class forCellReuseIdentifier:UVFeedTableViewCell.cellIdentifier];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _tableView;
}

// MARK: -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutTableView];
    // FEED: 
    self.navigationItem.title = @"lolkek😅";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

// MARK: - Private

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presenter.numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UVFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UVFeedTableViewCell.cellIdentifier forIndexPath:indexPath];
    [cell setupWithModel:[self.presenter itemAt:indexPath.row]
        reloadCompletion:^(void (^ _Nonnull callback)(void)) {
        [tableView performBatchUpdates:^{
            if (callback) callback();
        } completion:nil];
    }];
    return cell;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.presenter didSelectItemAt:indexPath.row];
}

@end
