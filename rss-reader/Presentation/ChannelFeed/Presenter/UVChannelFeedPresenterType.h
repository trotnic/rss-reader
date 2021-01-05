//
//  UVFeedPresenterType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "UVFeedChannelViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVChannelFeedPresenterType <NSObject>

- (void)updateFeed;
- (void)openArticleAt:(NSInteger)row;
- (id<UVFeedChannelViewModel>)viewModel;

@end

NS_ASSUME_NONNULL_END
