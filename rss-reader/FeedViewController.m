//
//  FeedViewController.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "FeedViewController.h"
#import "FeedChannelViewModel.h"
#import "FeedTableViewCell.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) id<FeedPresenterType> presenter;
@property (nonatomic, assign) id<FeedChannelViewModel> channel;

@end

@implementation FeedViewController

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter
{
    self = [super init];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _presenter = [presenter retain];
    }
    return self;
}

- (void)dealloc
{
    [_presenter release];
    [_tableView release];
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
    
    [self.tableView registerClass:FeedTableViewCell.class forCellReuseIdentifier:@"identifier"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

// MARK: - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    cell.alpha = 0;
    [((FeedTableViewCell *)cell) attachViewModel:self.channel.channelItems[indexPath.row]];
    [UIView animateWithDuration:0.1 animations:^{
        cell.alpha = 1;
    }];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.channel.channelItems.count;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.presenter selectRowAt:indexPath.row];
}

// MARK: - FeedViewType

- (void)setChannel:(id<FeedChannelViewModel>)channel {
    if(_channel != channel) {
        _channel = channel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            self.navigationItem.title = channel.channelTitle;
        });
    }
}

- (void)showError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:error.localizedDescription
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];        
        [self presentViewController:alert animated:YES completion:nil];
    });
}

@end
