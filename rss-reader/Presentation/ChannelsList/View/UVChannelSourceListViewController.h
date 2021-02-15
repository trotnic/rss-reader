//
//  UVChannelSourceListViewController.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import <UIKit/UIKit.h>
#import "UVChannelSourceListViewType.h"
#import "UVChannelSourceListPresenterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVChannelSourceListViewController : UIViewController <UVChannelSourceListViewType>

@property (nonatomic, retain) id<UVChannelSourceListPresenterType> presenter;

@end

NS_ASSUME_NONNULL_END
