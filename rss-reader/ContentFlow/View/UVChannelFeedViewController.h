//
//  FeedViewController.h
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import <UIKit/UIKit.h>
#import "UVChannelFeedViewType.h"
#import "UVFeedItemWebViewType.h"
#import "UVChannelFeedPresenterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVChannelFeedViewController : UIViewController <UVChannelFeedViewType>

- (instancetype)initWithPresenter:(id<UVChannelFeedPresenterType>)presenter;
- (void)setupOnRighButtonClickAction:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
