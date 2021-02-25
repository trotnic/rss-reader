//
//  FeedViewType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "UVFeedChannelDisplayModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVChannelFeedViewType

- (void)rotateActivityIndicator:(BOOL)show;
- (void)presentWebPageOnURL:(NSURL *)url;
- (void)clearState;
- (void)updatePresentation;
- (void)presentError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
