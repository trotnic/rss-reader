//
//  UVChannelDoneListViewController.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 3.03.21.
//

#import <UIKit/UIKit.h>
#import "UVChannelDoneListViewType.h"
#import "UVChannelDoneListPresenterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVChannelDoneListViewController : UIViewController <UVChannelDoneListViewType>

@property (nonatomic, strong) id<UVChannelDoneListPresenterType> presenter;

@end

NS_ASSUME_NONNULL_END
