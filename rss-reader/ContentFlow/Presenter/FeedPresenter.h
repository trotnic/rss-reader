//
//  FeedPresenter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "FeedPresenterType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RouterType;
@protocol FeedViewType;
@protocol FeedProviderType;

@interface FeedPresenter : NSObject <FeedPresenterType>

- (instancetype)initWithProvider:(id<FeedProviderType>)provider router:(id<RouterType>)router;
- (void)assignView:(id<FeedViewType>)view;

@end

NS_ASSUME_NONNULL_END
