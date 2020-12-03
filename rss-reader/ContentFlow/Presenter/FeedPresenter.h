//
//  FeedPresenter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "FeedPresenterType.h"
#import "FeedItemWebViewType.h"
#import "ErrorManagerType.h"
#import "FeedProviderType.h"
#import "FeedViewType.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedPresenter : NSObject <FeedPresenterType>

- (instancetype)initWithProvider:(id<FeedProviderType>)provider errorManager:(id<ErrorManagerType>)manager feedWebView:(id<FeedItemWebViewType>)webView;
- (void)assignView:(id<FeedViewType>)view;

@end

NS_ASSUME_NONNULL_END
