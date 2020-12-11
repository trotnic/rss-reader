//
//  FeedPresenter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "FeedPresenterType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FeedViewType;
@protocol FeedProviderType;
@protocol ErrorManagerType;

@interface FeedPresenter : NSObject <FeedPresenterType>

- (instancetype)initWithProvider:(id<FeedProviderType>)provider errorManager:(id<ErrorManagerType>)manager;

- (void)assignView:(id<FeedViewType>)view;

@end

NS_ASSUME_NONNULL_END
