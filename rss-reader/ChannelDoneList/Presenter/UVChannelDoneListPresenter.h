//
//  UVChannelDoneListPresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 3.03.21.
//

#import "UVBasePresenter.h"
#import "UVChannelDoneListPresenterType.h"
#import "UVChannelDoneListViewType.h"
#import "UVFeedManagerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVChannelDoneListPresenter : UVBasePresenter <UVChannelDoneListPresenterType>

@property (nonatomic, weak) id<UVChannelDoneListViewType> view;

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                            source:(id<UVSourceManagerType>)source
                           network:(id<UVNetworkType>)network
                              feed:(id<UVFeedManagerType>)feed
                       coordinator:(id<UVCoordinatorType>)coordinator;

@end

NS_ASSUME_NONNULL_END
