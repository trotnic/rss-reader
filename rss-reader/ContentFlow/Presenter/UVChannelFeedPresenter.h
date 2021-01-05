//
//  UVChannelFeedPresenter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "UVBasePresenter.h"
#import "UVChannelFeedPresenterType.h"
#import "UVChannelFeedViewType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVChannelFeedPresenter : UVBasePresenter <UVChannelFeedPresenterType>

@property (nonatomic, assign) id<UVChannelFeedViewType> view;

@end

NS_ASSUME_NONNULL_END
