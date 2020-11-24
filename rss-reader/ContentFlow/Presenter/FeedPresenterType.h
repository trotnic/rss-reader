//
//  FeedPresenterType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FeedChannelViewModel;

@protocol FeedPresenterType <NSObject>

- (void)updateFeed;
- (id<FeedChannelViewModel>)viewModel;
- (void)selectRowAt:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
