//
//  UVFeedPresenterType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "UVFeedChannelDisplayModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVChannelFeedPresenterType <NSObject>

- (void)updateFeed;
- (void)didSelectItemAt:(NSInteger)row;
- (id<UVFeedChannelDisplayModel>)channel;
- (id<UVFeedItemDisplayModel>)feedItemAt:(NSInteger)row;
- (NSInteger)numberOfItems;
- (void)didTapSettingsButton;

@end

NS_ASSUME_NONNULL_END
