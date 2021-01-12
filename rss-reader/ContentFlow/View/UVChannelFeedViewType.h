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
- (void)presentWebPageOnURL:(NSURL *)url;
- (void)clearState;

@end

NS_ASSUME_NONNULL_END
