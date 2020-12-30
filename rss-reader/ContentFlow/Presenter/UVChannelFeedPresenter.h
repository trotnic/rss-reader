//
//  FeedPresenter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "FeedPresenterType.h"
#import "UVBasePresenter.h"
#import "UVDataRecognizerType.h"
#import "UVSourceManagerType.h"
#import "UVChannelFeedViewType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVChannelFeedPresenter : UVBasePresenter <FeedPresenterType>

@property (nonatomic, assign) id<UVChannelFeedViewType> view;

@end

NS_ASSUME_NONNULL_END
