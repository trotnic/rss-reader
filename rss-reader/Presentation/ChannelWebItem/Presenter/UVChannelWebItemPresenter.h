//
//  UVChannelWebItemPresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 15.02.21.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "UVChannelWebItemPresenterType.h"
#import "UVChannelWebItemViewType.h"
#import "UVCoordinatorType.h"
#import "UVFeedManagerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVChannelWebItemPresenter : NSObject <UVChannelWebItemPresenterType>

@property (nonatomic, weak) id<UVChannelWebItemViewType> view;

- (instancetype)initWithCoordinator:(id<UVCoordinatorType>)coordinator feed:(id<UVFeedManagerType>)feed;

@end

NS_ASSUME_NONNULL_END
