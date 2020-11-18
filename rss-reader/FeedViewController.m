//
//  FeedViewController.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "FeedViewController.h"
#import "FeedItemViewModel.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) id<FeedPresenterType> presenter;
@property (nonatomic, retain) NSMutableArray<id<FeedItemViewModel>> *data;

@end

@implementation FeedViewController

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter
{
    self = [super init];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _data = [NSMutableArray new];
        // TODO: think about retain count -
        _presenter = [presenter retain];
    }
    return self;
}

- (void)dealloc
{
    [_presenter release];
    [_tableView release];
    [_data release];
    [super dealloc];
}

// MARK: -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self.presenter updateFeed];
}

- (void)setupTableView {
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"identifier"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

// MARK: UITableViewDataSource -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: -
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.data[indexPath.row] articleTitle];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

// MARK: UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// MARK: FeedViewType -

- (void)setFeed:(NSArray<id<FeedItemViewModel>> *)feed {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // TODO: no no no no
        [self.data removeAllObjects];
        [self.data addObjectsFromArray:feed];
        [self.tableView reloadData];
    });
}

@end
