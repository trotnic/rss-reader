//
//  UVSourcesListViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import "UVSourcesListViewController.h"
#import "UVSearchViewController.h"

#import "UIViewController+ErrorPresenter.h"

@interface UVSourcesListViewController () <UITableViewDataSource, UITableViewDelegate, UVSearchViewControllerDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIBarButtonItem *addSourceButton;
@property (nonatomic, retain) UVSearchViewController *searchController;

@end

@implementation UVSourcesListViewController

- (void)dealloc
{
    [_tableView release];
    [_presenter release];
    [_addSourceButton release];
    [_searchController release];
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
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.navigationItem.rightBarButtonItem = self.addSourceButton;
    
    self.tableView.tableFooterView = [[UIView new] autorelease];
}

// MARK: - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presenter.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)
                                                            forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = self.presenter.items[indexPath.row].linkTitle;
    cell.textLabel.numberOfLines = 0;
    if (self.presenter.items[indexPath.row].isSelected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.presenter selectItemAtIndex:indexPath.row];
}

// MARK: - Lazy

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:UITableViewCell.class
           forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}

- (UIBarButtonItem *)addSourceButton {
    if(!_addSourceButton) {
        _addSourceButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus"]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(addSource)];
    }
    return _addSourceButton;
}

- (UVSearchViewController *)searchController {
    if(!_searchController) {
        _searchController = [UVSearchViewController new];
        _searchController.delegate = self;
    }
    return _searchController;
}

// MARK: -

- (void)addSource {
    [self.navigationController pushViewController:self.searchController animated:YES];
}

- (void)updatePresentation {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)presentError:(NSError *)error {
    [self.navigationController.topViewController showError:error];
}

// MARK: - UVSearchViewControllerDelegate

- (void)searchAcceptedWithKey:(NSString *)key {
    [self.presenter discoverAddress:key];
}

// MARK: - UVSourcesListViewType

- (void)stopSearchWithUpdate:(BOOL)update {
    [self.navigationController popViewControllerAnimated:YES];
    if (update) {
        [self.tableView reloadData];
    }
}

@end
