//
//  UVSourceSearchViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 18.12.20.
//

#import "UVSourceSearchViewController.h"
#import "UIViewController+ErrorPresenter.h"

@interface UVSourceSearchViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (nonatomic, retain) id<UVSourceSearchPresenterType> presenter;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation UVSourceSearchViewController

- (instancetype)initWithPresenter:(id<UVSourceSearchPresenterType>)presenter
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
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
}

// MARK: -

- (void)setupLayout {
    [self.view addSubview:self.tableView];
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
    self.navigationItem.titleView = self.searchBar;
}

// MARK: - Lazy

- (UISearchBar *)searchBar {
    if(!_searchBar) {
        _searchBar = [UISearchBar new];
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"Address";
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.dataSource = self;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"reuseIdentifier"];
    }
    return _tableView;
}

// MARK: - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.presenter searchForAddress:searchBar.text];
}

// MARK: - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presenter.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = self.presenter.items[indexPath.row].linkTitle;
    return cell;
}

// MARK: - UVSourceSearchViewType

- (void)presentError:(NSError *)error {
    [self showError:error];
}

- (void)updatePresentation {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationMiddle];
}

@end
