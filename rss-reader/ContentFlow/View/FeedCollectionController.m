//
//  FeedCollectionController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12/4/20.
//

#import "FeedCollectionController.h"
#import "FeedCollectionViewCell.h"

@interface FeedCollectionController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, retain) UICollectionView *collectionView;

@property (nonatomic, retain) id<FeedPresenterType> presenter;

@end

@implementation FeedCollectionController

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter
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
    [_collectionView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = UIColor.whiteColor;
    [self setupLayout];
    [self.presenter updateFeed];
}

- (void)setupLayout {
    [self.view addSubview:self.collectionView];
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

// MARK: - Lazy

- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout new] autorelease];
//        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:FeedCollectionViewCell.class forCellWithReuseIdentifier:FeedCollectionViewCell.cellIdentifier];
    }
    return _collectionView;
}

// MARK: CollectionViewDelegate

// MARK: CollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.presenter.viewModel.channelItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedCollectionViewCell.cellIdentifier forIndexPath:indexPath];
    
    [cell setupWithViewModel:self.presenter.viewModel.channelItems[indexPath.item] reloadCompletion:^{
            
    }];
    
//    [cell.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = YES;
    
    return cell;
}

// MARK: - FeedViewType

- (void)updatePresentation {
    [self.collectionView reloadData];
//    [self.tableView reloadData];
    self.navigationItem.title = [self.presenter.viewModel channelTitle];
//    [self.refreshControl endRefreshing];
}

- (void)toggleActivityIndicator:(BOOL)show {
    if (show) {
//        [self.activityIndicator startAnimating];
    } else {
//        [self.activityIndicator stopAnimating];
    }
}

- (void)presentError:(NSError *)error {
//    [self showError:error];
}

- (void)presentWebPageOnLink:(NSString *)link {
//    [self.webView openURL:[NSURL URLWithString:link]];
//    [self.navigationController pushViewController:self.webView animated:YES];
}

@end
