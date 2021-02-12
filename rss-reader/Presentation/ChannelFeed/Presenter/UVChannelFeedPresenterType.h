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
- (id<UVFeedChannelDisplayModel>)channel;
- (void)settingsButtonClicked;

@end

NS_ASSUME_NONNULL_END
