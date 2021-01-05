//
//  FeedPresenter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "UVFeedPresenterType.h"
#import "UVNetworkType.h"
#import "UVFeedViewType.h"
#import "UVFeedProviderType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVFeedPresenter : NSObject <UVFeedPresenterType>

- (instancetype)initWithView:(id<UVFeedViewType>)view
                    provider:(id<UVFeedProviderType>)provider
                     network:(id<UVNetworkType>)network;

@end

NS_ASSUME_NONNULL_END
