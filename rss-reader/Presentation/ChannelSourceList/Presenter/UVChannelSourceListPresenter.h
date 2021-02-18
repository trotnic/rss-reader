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

@property (nonatomic, assign) UIViewController<UVChannelSourceListViewType> *viewDelegate;

@end

NS_ASSUME_NONNULL_END
