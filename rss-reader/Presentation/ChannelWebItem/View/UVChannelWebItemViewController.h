//
//  UVChannelWebItemViewController.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 15.02.21.
//

#import <UIKit/UIKit.h>
#import "UVChannelWebItemViewType.h"
#import "UVChannelWebItemPresenterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVChannelWebItemViewController : UIViewController <UVChannelWebItemViewType>

@property (nonatomic, strong) id<UVChannelWebItemPresenterType> presenter;

@end

NS_ASSUME_NONNULL_END
