//
//  UVLinksViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import "UVLinksViewController.h"
#import "UIBarButtonItem+PrettiInitializable.h"
#import "UVLinksPresenter.h"

NSString *const cellReuseIdentifier = @"reuseIdentifier";

@interface UVLinksViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UITextField *urlField;
@property (nonatomic, retain) UIButton *urlConfirmButton;

@property (nonatomic, retain, readwrite) id<UVLinksPresenterType> presenter;

@end

@implementation UVLinksViewController

- (instancetype)initWithPresenter:(id<UVLinksPresenterType>)presenter
{
    self = [super init];
    if (self) {
        _presenter = [presenter retain];
        [_presenter assignView:self];
    }
    return self;
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
            [cell.contentView addSubview:self.urlField];
            [NSLayoutConstraint activateConstraints:@[
                [self.urlField.leadingAnchor constraintEqualToAnchor:cell.safeAreaLayoutGuide.leadingAnchor constant:16],
                [self.urlField.topAnchor constraintEqualToAnchor:cell.topAnchor],
                [self.urlField.trailingAnchor constraintEqualToAnchor:cell.safeAreaLayoutGuide.trailingAnchor constant:-16],
                [self.urlField.bottomAnchor constraintEqualToAnchor:cell.bottomAnchor]
            ]];
            break;
        case 1:
            cell.textLabel.text = self.presenter.source.sourceRSSLinks[indexPath.row].linkTitle;
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

- (UITextField *)urlField {
    if(!_urlField) {
        _urlField = [UITextField new];
        _urlField.keyboardType = UIKeyboardTypeURL;
        _urlField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _urlField.translatesAutoresizingMaskIntoConstraints = NO;
        _urlField.rightView = self.urlConfirmButton;
        _urlField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _urlField;
}

- (UIButton *)urlConfirmButton {
    if(!_urlConfirmButton) {
        _urlConfirmButton = [UIButton new];
        [_urlConfirmButton setImage:[UIImage imageNamed:@"checkmark"]
                           forState:UIControlStateNormal];
        [_urlConfirmButton addTarget:self action:@selector(urlConfirm)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    return _urlConfirmButton;
}

// MARK: -

- (void)urlConfirm {
    [self.presenter updateChannelsWithPlainUrl:self.urlField.text];
}

// MARK: - UVLinksViewType

- (void)updatePresentation {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)presentError:(NSError *)error {
    
}

@end
