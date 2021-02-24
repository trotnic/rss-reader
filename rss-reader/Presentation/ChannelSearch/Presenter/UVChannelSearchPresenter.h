//
//  UVChannelSearchPresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11.02.21.
//

#import <UIKit/UIKit.h>
#import "UVBasePresenter.h"
#import "UVChannelSearchPresenterType.h"
#import "UVChannelSearchViewType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVChannelSearchPresenter : UVBasePresenter <UVChannelSearchPresenterType>

@property (nonatomic, weak) UIViewController<UVChannelSearchViewType> *view;

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                            source:(id<UVSourceManagerType>)source
                           network:(id<UVNetworkType>)network
                       coordinator:(id<UVCoordinatorType>)coordinator;

@end

NS_ASSUME_NONNULL_END
