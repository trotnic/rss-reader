//
//  UVChannelSourceListViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import "UVChannelSourceListViewController.h"

#import "LocalConstants.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
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
    
    self.navigationItem.title = NSLocalizedString(RSS_LINKS_TITLE, "");
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, self.addSourceButton];
    
    self.tableView.tableFooterView = [[UIView new] autorelease];
}

// MARK: - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presenter.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)
                                                            forIndexPath:indexPath];
    // TODO: -
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = self.presenter.items[indexPath.row].linkTitle;
    cell.textLabel.numberOfLines = 0;
    if (self.presenter.items[indexPath.row].isSelected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
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
                                                           target:self.presenter
                                                           action:@selector(searchButtonClicked)];
    }
    return _addSourceButton;
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
