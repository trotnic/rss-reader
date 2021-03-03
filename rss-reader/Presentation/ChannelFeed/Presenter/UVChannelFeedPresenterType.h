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
- (void)openArticleAt:(NSInteger)row;

- (void)settingsButtonClicked;
- (void)trashButtonClicked;

- (id<UVFeedItemDisplayModel>)itemAt:(NSInteger)index;
- (NSInteger)numberOfItems;
// FEED:
//- (NSString *)channelTitle;

@end

NS_ASSUME_NONNULL_END
