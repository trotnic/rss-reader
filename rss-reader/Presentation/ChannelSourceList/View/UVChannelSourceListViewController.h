//
//  UVChannelSourceListViewController.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import "UVBaseViewController.h"
#import "UVChannelSourceListViewType.h"
#import "UVChannelSourceListPresenterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVChannelSourceListViewController : UVBaseViewController <UVChannelSourceListViewType>

@property (nonatomic, retain) id<UVChannelSourceListPresenterType> presenter;

@end

NS_ASSUME_NONNULL_END
