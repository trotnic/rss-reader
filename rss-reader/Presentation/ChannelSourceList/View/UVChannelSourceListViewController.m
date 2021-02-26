//
//  UVChannelSourceListViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import "UVChannelSourceListViewController.h"

#import "UVChannelSourceTableViewCell.h"
#import "LocalConstants.h"

#import "UIImage+AppIcons.h"
#import "UIViewController+Util.h"

@interface UVChannelSourceListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIBarButtonItem *addSourceButton;

@end

@implementation UVChannelSourceListViewController

- (void)dealloc
{
    [_tableView release];
    [_presenter release];
    [_addSourceButton release];
    [super dealloc];
}

// MARK: - Lazy Properties

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [_tableView registerClass:UVChannelSourceTableViewCell.class
           forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}

- (UIBarButtonItem *)addSourceButton {
    if(!_addSourceButton) {
        _addSourceButton = [[UIBarButtonItem alloc] initWithImage:UIImage.plusIcon
                                                            style:UIBarButtonItemStylePlain
                                                           target:self.presenter
                                                           action:@selector(searchButtonClicked)];
    }
    return _addSourceButton;
}

// ЬФКЛЖ -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAppearance];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

// MARK: -

- (void)setupAppearance {
    [self layoutTableView];
    self.navigationItem.title = NSLocalizedString(RSS_LINKS_TITLE, "");
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, self.addSourceButton];
    
    self.tableView.tableFooterView = [[UIView new] autorelease];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presenter.numberOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UVChannelSourceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)
                                                                         forIndexPath:indexPath];
    [cell configureWithViewModel:[self.presenter itemAt:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.presenter deleteItemAtIndex:indexPath.row];
    }
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.presenter selectItemAtIndex:indexPath.row];
}

// MARK: -

- (void)updatePresentation {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)presentError:(NSError *)error {
    [self showError:error];
}

// MARK: - UVSourcesListViewType

- (void)stopSearchWithUpdate:(BOOL)update {
    [self.navigationController popViewControllerAnimated:YES];
    if (update) {
        [self.tableView reloadData];
    }
}

@end
