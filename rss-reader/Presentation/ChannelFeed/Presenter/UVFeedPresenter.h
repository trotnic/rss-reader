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
#import "UVBasePresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVFeedPresenter : UVBasePresenter <UVFeedPresenterType>

@property (nonatomic, assign) id<UVFeedViewType> view;

- (instancetype)initWithProvider:(id<UVFeedProviderType>)provider
                         network:(id<UVNetworkType>)network;

@end

NS_ASSUME_NONNULL_END
