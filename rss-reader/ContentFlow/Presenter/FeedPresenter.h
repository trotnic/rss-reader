//
//  FeedPresenter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "FeedPresenterType.h"
#import "UVNetworkType.h"
#import "FeedViewType.h"
#import "FeedProviderType.h"
#import "ErrorManagerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedPresenter : NSObject <FeedPresenterType>

@property (nonatomic, assign) id<FeedViewType> view;

- (instancetype)initWithProvider:(id<FeedProviderType>)provider
                    errorManager:(id<ErrorManagerType>)manager
                         network:(id<UVNetworkType>)network;

@end

NS_ASSUME_NONNULL_END
