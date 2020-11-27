//
//  FeedPresenter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "FeedPresenterType.h"
#import "FeedViewType.h"
#import "FeedProviderType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MainRouter;

@interface FeedPresenter : NSObject <FeedPresenterType>

- (instancetype)initWithProvider:(id<FeedProviderType>)provider router:(id<MainRouter>)router;
- (void)assignView:(id<FeedViewType>)view;

@end

NS_ASSUME_NONNULL_END
