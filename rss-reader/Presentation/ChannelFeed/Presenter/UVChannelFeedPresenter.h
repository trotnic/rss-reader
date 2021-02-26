//
//  UVChannelFeedPresenter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "UVBasePresenter.h"
#import "UVChannelFeedPresenterType.h"
#import "UVChannelFeedViewType.h"
#import "UVFeedManagerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVChannelFeedPresenter : UVBasePresenter <UVChannelFeedPresenterType>

@property (nonatomic, assign) UIViewController<UVChannelFeedViewType> *view;

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                            source:(id<UVSourceManagerType>)source
                           network:(id<UVNetworkType>)network
                              feed:(id<UVFeedManagerType>)feed
                       coordinator:(id<UVCoordinatorType>)coordinator;

@end

NS_ASSUME_NONNULL_END
