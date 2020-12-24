//
//  FeedPresenter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "FeedPresenterType.h"
#import "BasePresenter.h"
#import "FeedProviderType.h"
#import "UVSourceManagerType.h"
#import "FeedViewType.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedPresenter : BasePresenter <FeedPresenterType>

@property (nonatomic, assign) id<FeedViewType> view;

- (instancetype)initWithProvider:(id<FeedProviderType>)provider sourceManager:(id<UVSourceManagerType>)sourceManager;

@end

NS_ASSUME_NONNULL_END
