//
//  UVSourcesListViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import "UVSourcesListViewController.h"
#import "UVSearchViewController.h"
#import "UIViewController+ErrorPresenter.h"
// TODO:
#import "UVSourceDetailPresenter.h"
#import "UVSourceDetailViewController.h"
#import "UVSourceManager.h"

@interface UVSourcesListViewController () <UITableViewDataSource, UITableViewDelegate, UVSearchViewControllerDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIBarButtonItem *addSourceButton;
@property (nonatomic, retain) UVSearchViewController *searchController;

@property (nonatomic, retain) id<UVSourcesListPresenterType> presenter;

@end

@implementation UVSourcesListViewController

- (instancetype)initWithPresenter:(id<UVSourcesListPresenterType>)presenter
{
    self = [super init];
    if (self) {
        _presenter = [presenter retain];
    }
    return self;
}

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = self.presenter.items[indexPath.row].sourceTitle;
    cell.textLabel.numberOfLines = 0;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.presenter selectItemWithIndex:indexPath.row];
}

// MARK: - Lazy

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"reuseIdentifier"];
    }
    return _tableView;
}

- (UIBarButtonItem *)addSourceButton {
    if(!_addSourceButton) {
        _addSourceButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"]
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
    UINavigationController *navigationController = [UINavigationController new];    
    [navigationController setViewControllers:@[self.searchController]];
    [self presentViewController:[navigationController autorelease] animated:YES completion:nil];
}

- (void)updatePresentation {
    
}

- (void)presentError:(NSError *)error {
    
}

// MARK: - UVSearchViewControllerDelegate

- (void)searchAcceptedWithKey:(NSString *)key {
    [self.presenter parseAddress:key];
}

- (void)searchCancelled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// MARK: - UVSourcesListViewType

- (void)stopSearchWithUpdate:(BOOL)update {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (update) {
        [self.tableView reloadData];
    }
}

// TODO: 
- (void)presentDetailWithModel:(RSSSource *)model {
    UVSourceDetailPresenter *presenter = [[UVSourceDetailPresenter alloc] initWithModel:model
                                                                          sourceManager:UVSourceManager.defaultManager];
    UVSourceDetailViewController *controller = [[UVSourceDetailViewController alloc] initWithPresenter:[presenter autorelease]];
    presenter.view = controller;
    [self.navigationController pushViewController:[controller autorelease] animated:YES];
}

@end
