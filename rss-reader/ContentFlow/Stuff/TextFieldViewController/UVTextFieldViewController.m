//
//  UVTextFieldViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 17.12.20.
//

#import "UVTextFieldViewController.h"
#import "UVTextFieldTableViewCell.h"

@interface UVTextFieldViewController () <UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, copy) NSString *initialText;
@property (nonatomic, copy) void(^completion)(NSString *);

@end

@implementation UVTextFieldViewController

- (instancetype)initWithCompletion:(void(^)(NSString *))completion
{
    self = [super init];
    if (self) {
        _completion = [completion copy];
    }
    return self;
}

- (void)dealloc
{
    [_tableView release];
    [_textField release];
    [_initialText release];
    [_completion release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.completion(self.textField.text);
}

// MARK: - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UVTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UVTextFieldTableViewCell.reuseIdentifier forIndexPath:indexPath];
    cell.textField.text = self.initialText;
    self.textField = cell.textField;
    return cell;
}

// MARK: - Lazy

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.dataSource = self;
        [_tableView registerClass:UVTextFieldTableViewCell.class forCellReuseIdentifier:UVTextFieldTableViewCell.reuseIdentifier];
    }
    return _tableView;
}

@end
