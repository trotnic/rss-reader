//
//  UVChannelSearchViewController.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11.02.21.
//

#import "UVBaseViewController.h"
#import "UVChannelSearchViewType.h"
#import "UVChannelSearchPresenterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVChannelSearchViewController : UVBaseViewController <UVChannelSearchViewType>

@property (nonatomic, strong) id<UVChannelSearchPresenterType> presenter;

@end

NS_ASSUME_NONNULL_END
