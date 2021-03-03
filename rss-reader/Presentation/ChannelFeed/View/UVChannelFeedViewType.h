//
//  FeedViewType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "UVFeedChannelDisplayModel.h"
#import "UVBaseViewType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVChannelFeedViewType <UVBaseViewType>

- (void)rotateActivityIndicator:(BOOL)show;
- (void)clearState;
- (void)setSettingsButtonActive:(BOOL)active;

@end

NS_ASSUME_NONNULL_END
