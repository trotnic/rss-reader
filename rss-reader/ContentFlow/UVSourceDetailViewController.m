//
//  UVLinksViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import "UVSourceDetailViewController.h"
#import "UIBarButtonItem+PrettiInitializable.h"
#import "UIViewController+ErrorPresenter.h"
#import "UVSourceDetailPresenter.h"

NSString *const cellReuseIdentifier = @"reuseIdentifier";

@interface UVSourceDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) UIBarButtonItem *saveButton;

@property (nonatomic, retain, readwrite) id<UVSourceDetailPresenterType> presenter;


@end

@implementation UVSourceDetailViewController

- (instancetype)initWithPresenter:(id<UVSourceDetailPresenterType>)presenter
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
    [_saveButton release];
    [_presenter release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
}

- (void)setupLayout {
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
    
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

// MARK: UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        default:
            if (self.presenter.source) {
                return self.presenter.source.sourceRSSLinks.count;
            } else {
                return 0;
            }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"RSS URL";
        case 1:
            return @"Channels";
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = self.presenter.source.sourceAddress;
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = self.presenter.source.sourceRSSLinks[indexPath.row].linkTitle;
            if (self.presenter.source.sourceRSSLinks[indexPath.row].isSelected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
    }
    
    return cell;
}

// MARK: UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 1:
            [self.presenter selectChannelAtIndex:indexPath.row];
            break;
        default:
            break;
    }
}

// MARK: - Lazy

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIBarButtonItem *)saveButton {
    if(!_saveButton) {
        _saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                    style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(save)];
    }
    return _saveButton;
}

// MARK: -

- (void)save {
    [self.navigationController popViewControllerAnimated:YES];
    [self.presenter saveSource];
}

// MARK: - UVLinksViewType

- (void)updatePresentation {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)presentError:(NSError *)error {
    [self showError:error];
}

- (void)updateLinkAtIndex:(NSInteger)index {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                  withRowAnimation:UITableViewRowAnimationNone];
}

@end
