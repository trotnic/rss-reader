//
//  UVFeedViewType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "UVFeedChannelDisplayModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVFeedViewType <NSObject>

- (void)updatePresentationWithChannel:(id<UVFeedChannelDisplayModel>)channel;
- (void)presentWebPageOnURL:(NSURL *)url;
- (void)rotateActivityIndicator:(BOOL)show;
- (void)presentError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
