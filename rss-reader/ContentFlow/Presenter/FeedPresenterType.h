//
//  FeedPresenterType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FeedViewType;
@protocol FeedChannelViewModel;

@protocol FeedPresenterType <NSObject>

- (void)updateFeed;
- (void)openArticleAt:(NSInteger)row;
- (id<FeedChannelViewModel>)viewModel;

@end

NS_ASSUME_NONNULL_END
