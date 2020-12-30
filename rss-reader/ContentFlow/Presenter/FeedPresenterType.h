//
//  FeedPresenterType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "FeedChannelViewModel.h"
#import "UVChannelFeedViewType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FeedPresenterType <NSObject>

- (void)updateFeed;
- (void)showDetailAt:(NSInteger)row;
- (id<FeedChannelViewModel>)viewModel;

@end

NS_ASSUME_NONNULL_END
