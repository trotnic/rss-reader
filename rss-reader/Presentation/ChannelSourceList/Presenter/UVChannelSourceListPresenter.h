//
//  UVChannelSourceListPresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import <UIKit/UIKit.h>
#import "UVBasePresenter.h"
#import "UVChannelSourceListPresenterType.h"
#import "UVChannelSourceListViewType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVChannelSourceListPresenter : UVBasePresenter <UVChannelSourceListPresenterType>

@property (nonatomic, assign) UIViewController<UVChannelSourceListViewType> *view;

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                            source:(id<UVSourceManagerType>)source
                           network:(id<UVNetworkType>)network
                       coordinator:(id<UVCoordinatorType>)coordinator;

@end

NS_ASSUME_NONNULL_END
